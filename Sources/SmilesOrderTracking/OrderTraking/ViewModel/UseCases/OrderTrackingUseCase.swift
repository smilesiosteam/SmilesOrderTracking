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
                self?.stateSubject.send(.showError(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] response in
            guard let self else {
                return
            }
            self.stateSubject.send(.hideLoader)
            self.statusResponse = response
            let status = self.configOrderStatus(response: response)
            self.stateSubject.send(.success(model: status))
            let orderId = response.orderDetails?.orderId ?? 0
            let orderNumber = response.orderDetails?.orderNumber ?? ""
            self.stateSubject.send(.orderId(id: "\(orderId)", orderNumber: orderNumber))
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
        case showError(message: String)
        case showToastForArrivedOrder(isShow: Bool)
        case showToastForNoLiveTracking(isShow: Bool)
        case success(model: OrderTrackingModel)
        case orderId(id: String, orderNumber: String, orderStatus: OrderTrackingType)
        case trackDriverLocation(liveTrackingId: String)
        case showLoader
        case hideLoader
    }
}



let jsonString = """
{
  "extTransactionId": "3530191483630",
  "orderDetails": {
    "orderStatus": 7,
     "smallImageAnimationUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/ENGLISH/SMALL/Delivering.json",
     "largeImageAnimationUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/ENGLISH/LARGE/Waiting.json",
     "trackingColorCode": "#a5deef",
     "earnPointsText": "smiles points earned and will be credited soon.",
   "partnerNumber": "010300349340340",
    "title": "Wow, your order has arrived X min early. Enjoy! Ya Naguib",
    "orderDescription": "Hardee's should accept your order soon.",
    "orderNumber": "SMHD111620230000467198",
    "restaurantName": "Hardee's",
    "deliveryRegion": "Al Kifaf",
    "recipient": "SYMEON STEFANIDIS",
    "totalAmount": "56",
    "deliveryCharges": "9",
    "discount": "0",
    "promoCodeDiscount": 0.0,
    "grandTotal": 65.0,
    "vatPrice": 3.1,
    "totalSaving": 0,
    "orderTime": "20-11-2023 03:46 PM",
    "deliveryTime": "40",
    "deliveryTimeRange": "30-40",
    "deliveryTimeRangeText": "04:16PM - 04:26PM",
    "deliveryTimeRangeV2": "Your order will be delivered between 04:16PM - 04:26PM to: Home",
    "pickupTime": "20",
    "restaurantAddress": "Sheikh Essa Tower  Beside Financial Centre Metro Station- Dubai - UAE",
    "phone": "0543936216",
    "latitude": "25.211333693767923",
    "longitude": "55.274305138728316",
    "restaurentNumber": "065092434",
    "estimateTime": "20 Nov 2023 04:26 PM",
    "deliveryAdrress": "maama, Annan, Alan, amann, Sheikh Zayed Rd - Za'abeel - Dubai - United Arab Emirates, Al Kifaf",
    "orderTimeOut": 2,
    "isCancelationAllowed": true,
    "orderType": "DELIVERY",
    "determineStatus": false,
    "earnPoints": 120,
    "addressTitle": "Home",
    "reOrder": true,
    "liveTracking": true,
    "orderId": 466698,
    "imageUrl": "https://cdn.eateasily.com/restaurants/profile/app/400X300/17316.jpg",
    "iconUrl": "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg",
    "deliveryLatitude": "25.230654",
    "subscriptionBanner": {
            "subscriptionTitle": "Subscribe for Unlimited free delivery!",
            "subscriptionIcon": "https://cdn.eateasily.com/mamba/food_bogo.png",
            "redirectionUrl": "smiles://smilessubscription"
        },
    "deliveryLongitude": "55.291472",
    "trackingType": "no",
    "delayAlert": {
         "title": "A slight delay in your order",
         "description": "description description description description"
     },
    "paymentType": "cashOnDelivery",
   "changeTypeTimer": 1,
    "paidAedAmount": "65",
    "isFirstOrder": false,
    "statusText": "Order Received",
    "inlineItemIncluded": false,
    "virtualRestaurantIncluded": false,
    "inlineItemTotal": 0.0,
    "restaurantId": "17338",
    "isDeliveryFree": false,
    "deliveryTip": 0,
    "isLiveChatEnable": true,
    "deliveryBy": "Delivered By Restaurant",
    "driverStatusText": "has picked up your order",
    "driverName": "Osama Tester Driver",
    "driverImageIconUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/driverimageIcon.png",
    "driverPhoneImageUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/driverphoneIcon.png",
    "mapImageIconUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/mapIcon.png",
    "subTitleImageIconUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/SubTitleimageIcon.png",
    "bannerImageUrl": "https://www.smilesuae.ae/images/APP/BANNERS/ENGLISH/BOTTOM/OrderTrackingULFD_V2.png",

 "delayStatusText": "delayStatusText delayStatusText delayStatusText ",

  },
"orderRatings": [
            {
                "ratingType": "food",
                "userRating": 0.0,
                "title": "how was the food from Hardee's?",
                "image": "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg"
            },
            {
                "ratingType": "delivery",
                "userRating": 0.0,
                "title": "Rate delivery",
                "image": "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg"
            }
        ],
  "orderItems": [
    {
      "quantity": 1,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Quattro Box",
      "price": 56.0,
      "inlineItemIncluded": false
    },
    {
      "quantity": 4,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Dummy Box",
      "price": 56.0,
      "inlineItemIncluded": false
    },
    {
      "quantity": 10,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Beef",
      "price": 56.0,
      "inlineItemIncluded": false
    },
    {
      "quantity": 18,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Burger",
      "price": 56.0,
      "inlineItemIncluded": false
    }
  ]
}
"""
