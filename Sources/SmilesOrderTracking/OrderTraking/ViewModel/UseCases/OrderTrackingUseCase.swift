//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import Combine

protocol OrderTrackingUseCaseProtocol {
    func fetchOrderStates()
    func loadOrderStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool)
    func pauseTimer()
    func resumeTimer()
    var statePublisher: AnyPublisher<OrderTrackingUseCase.State, Never> { get }
}

final class OrderTrackingUseCase: OrderTrackingUseCaseProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    private let orderId: String
    private let orderNumber: String
    private var stateSubject = PassthroughSubject<State, Never>()
    private let services: OrderTrackingServiceHandlerProtocol
    private var timer: Timer?
    private var isTimerRunning = false
    private var elapsedTime: TimeInterval = 0
    private let hideCancelOrderAfter: TimeInterval = 10 // Hide the cancel button after 10s
    private var statusResponse: OrderTrackingStatusResponse?
    
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(orderId: String, orderNumber: String, services: OrderTrackingServiceHandlerProtocol) {
        self.orderId = orderId
        self.orderNumber = orderNumber
        self.services = services
    }
    
    deinit {
        stopTimer()
    }
    
    func fetchOrderStates() {
        loadOrderStatus(orderId: orderId,
                        orderStatus: "\(OrderTrackingType.confirmation.rawValue)",
                        orderNumber: orderNumber, isComingFromFirebase: false)
//        if let jsonData = jsonString.data(using: .utf8) {
//            do {
//                let orderResponse = try JSONDecoder().decode(OrderTrackingStatusResponse.self, from: jsonData)
//                _ = orderResponse.orderDetails?.orderStatus
//                statusResponse =  orderResponse
//                let status = self.configOrderStatus(response: orderResponse)
//                stateSubject.send(.success(model: status))
//            } catch {
//                print("Error decoding JSON: \(error)")
//            }
//        }
    }
    
    private func configOrderStatus(response: OrderTrackingStatusResponse) -> OrderTrackingModel {
        stopTimer()  // Stop timer when the status is changed
        guard let status = response.orderDetails?.orderStatus,
              let value = OrderTrackingType(rawValue: status) else {
            return .init()
        }
        
        switch value {
        case .orderProcessing, .pickupChanged:
            return getProcessingOrderModel(response: response)
        case .waitingForTheRestaurant:
            return WaitingOrderConfig(response: response).build()
        case .orderAccepted:
            stateSubject.send(.showToastForArrivedOrder(isShow: true))
            return AcceptedOrderConfig(response: response).build()
        case .inTheKitchen, .orderHasBeenPickedUpDelivery:
            return InTheKitchenOrderConfig(response: response).build()
        case .orderIsReadyForPickup:
            return ReadyForPickupOrderConfig(response: response).build()
        case .orderHasBeenPickedUpPickup:
            return OrderHasBeenDeliveredConfig(response: response).build()
        case .orderIsOnTheWay:
            let status = OnTheWayOrderConfig(response: response)
            stateSubject.send(.showToastForNoLiveTracking(isShow: status.isLiveTracking))
            if status.isLiveTracking {
                let liveTracingId = response.orderDetails?.liveTrackingId ?? ""
                stateSubject.send(.trackDriverLocation(liveTrackingId: liveTracingId))
            }
            return status.build()
        case .orderCancelled:
            return CanceledOrderConfig(response: response).build()
        case .changedToPickup:
            return ChangedToPickupOrderConfig(response: response).build()
        case .confirmation:
            return ConfirmationOrderConfig(response: response).build()
        case .someItemsAreUnavailable:
            return SomeItemsUnavailableConfig(response: response).build()
        case .orderNearYourLocation:
            return NearOfLocationConfig(response: response).build()
        case .delivered:
            return OrderHasBeenDeliveredConfig(response: response).build()
        }
    }
    
    private func getProcessingOrderModel(response: OrderTrackingStatusResponse) -> OrderTrackingModel {
        let processOrder = ProcessingOrderConfig(response: response)
        
        if processOrder.isCancelationAllowed {
            startTimer()
        }
        
        return processOrder.build()
    }
    
    func loadOrderStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) {
        self.stateSubject.send(.showLoader)

        let handler = OrderTrackingServiceHandler()
        handler.getOrderTrackingStatus(orderId: orderId,
                                       orderStatus: orderStatus,
                                       orderNumber: orderNumber, isComingFromFirebase: isComingFromFirebase)
        .sink { [weak self] completion in
            self?.stateSubject.send(.hideLoader)
            switch completion {
                
            case .finished:
                print("finished")
            case .failure(let error):
                self?.stateSubject.send(.showErrorAndPop(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] response in
            guard let self else {
                return
            }
            self.stateSubject.send(.hideLoader)
            let status = self.configOrderStatus(response: response)
            self.stateSubject.send(.success(model: status))
            let orderId = response.orderDetails?.orderId ?? 0
            let orderNumber = response.orderDetails?.orderNumber ?? ""
            let orderStatus = response.orderDetails?.orderStatus ?? 0
            let type = OrderTrackingType(rawValue: orderStatus) ?? .inTheKitchen
            self.stateSubject.send(.orderId(id: "\(orderId)", orderNumber: orderNumber, orderStatus: type))
            let isLiveTracking = response.orderDetails?.liveTracking ?? false
            self.stateSubject.send(.isLiveTracking(isLiveTracking: isLiveTracking))
        }.store(in: &cancellables)
    }
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    
    @objc private func timerTick() {
        elapsedTime += 1
        print("Timer: \(elapsedTime) seconds")
        
        // Check if 10 seconds have passed
        if elapsedTime >= hideCancelOrderAfter {
            stopTimer()
            hideCancelButton()
        }
    }
    
    func pauseTimer() {
        if isTimerRunning {
            timer?.invalidate()
            timer = nil
            isTimerRunning = false
            print("Timer paused")
        }
    }
    
    func resumeTimer() {
        if !isTimerRunning {
            startTimer()
            print("Timer resumed")
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
        isTimerRunning = false
        print("Timer stopped")
    }
    
    private func hideCancelButton() {
        guard let statusResponse else {
            return
        }
        var orderResponse = statusResponse
        orderResponse.orderDetails?.showCancelButtonTimeout = true
        orderResponse.orderDetails?.isCancelationAllowed = false
        let status = self.configOrderStatus(response: orderResponse)
        stateSubject.send(.success(model: status))
    }
}

extension OrderTrackingUseCase {
    enum State {
        case showErrorAndPop(message: String)
        case showToastForArrivedOrder(isShow: Bool)
        case showToastForNoLiveTracking(isShow: Bool)
        case success(model: OrderTrackingModel)
        case orderId(id: String, orderNumber: String, orderStatus: OrderTrackingType)
        case trackDriverLocation(liveTrackingId: String)
        case showLoader
        case hideLoader
        case isLiveTracking(isLiveTracking: Bool)
    }
}



let jsonString = """
{
  "orderDetails" : {
    "estimateTime" : "08 Dec 2023 08:15 PM",
    "restaurentNumber" : "043062981",
    "orderType" : "DELIVERY",
    "orderId" : 467034,
    "earnPoints" : 0,
    "isLiveChatEnable" : true,
    "restaurantName" : "Pizzalicious",
    "orderRatings" : [
      {
        "userRating" : 0,
        "title" : "Rate your order",
        "ratingType" : "food",
        "image" : "https://cdn.eateasily.com/mamba/BurgerIcon.png"
      },
      {
        "userRating" : 0,
        "title" : "Rate delivery",
        "ratingType" : "delivery",
        "image" : "https://cdn.eateasily.com/mamba/MotorcycleIcon.png"
      }
    ],
    "deliveryTimeRange" : "40-50",
    "orderStatus" : 0,
    "deliveryTimeRangeText" : "08:05PM - 08:15PM",
    "subscriptionBanner" : {
      "subscriptionIcon" : "https://cdn.eateasily.com/mamba/food_bogo.png",
      "colorCode" : "#9400D3",
      "redirectionUrl" : "smiles://smilessubscription",
      "subscriptionTitle" : "Subscribe for Unlimited free delivery!"
    },
    "orderDescription" : "Your order was delivered at 08 dec 2023 08:15 pm",
    "pickupTime" : "50",
    "driverName" : "Irshad Ahmed",
    "liveTracking" : true,
    "ratingStatus" : false,
    "addressTitle" : "Home",
    "subStatusText" : "Your Smiles Champion  is on the way to pick it up.",
    "subscriptionBannerV2" : {
      "bannerImageUrl" : "https://www.smilesuae.ae/images/APP/BANNERS/ENGLISH/BOTTOM/OrderTrackingULFD_V2.jpg",
      "redirectionUrl" : "smiles://smilessubscription"
    },
    "longitude" : "55.275466496589324",
    "deliveryAdrress" : "123, My tower, 100, 57WHVV - Downtown Dubai - Dubai - United Arab Emirates, Downtown Dubai",
    "fullfilledTime" : "10 Dec 2023 01:09 AM",
    "liveTrackingUrl" : "https://test-web.eateasy.ae/dubai/track/smiles/441e8d13-2814-45cd-aab1-b33bd1e7ae6c/25.206286627010712/55.275466496589324/25.1972/55.2797",
    "deliveryBy" : "Delivered By Smiles",
    "deliveryLongitude" : "55.2797",
    "trackingType" : "live",
    "iconUrl" : "https://cdn.eateasily.com/restaurants/af29d7fc24afb5ec93096564b367f676/16646_small.jpg",
    "deliveryTime" : "50",
    "determineStatus" : false,
    "restaurantAddress" : "DIFC, Dubai",
    "isFirstOrder" : false,
    "orderTimeOut" : 300,
    "orderNumber" : "SMHD120820230000467534",
    "isCancelationAllowed" : false,
    "inlineItemIncluded" : false,
    "imageUrl" : "https://cdn.eateasily.com/restaurants/profile/app/400X300/16453.jpg",
    "liveTrackingId" : "441e8d13-2814-45cd-aab1-b33bd1e7ae6c",
    "statusText" : "Delivered",
    "title" : "Your order has been delivered!",
    "deliveryLatitude" : "25.1972",
    "partnerNumber" : "971545861399",
    "driverStatusText" : "has delivered your order",
    "latitude" : "25.206286627010712"
  },
"orderItems": [
{"quantity": 10, "itemName": "Pesi"},
{"quantity": 9, "itemName": "ahmed"},
{"quantity": 3, "itemName": "nanan"},
],
  "extTransactionId" : "2731272666123"
}
"""
