//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import Combine
import SmilesUtilities

protocol OrderTrackingUseCaseProtocol {
    func fetchOrderStates()
    func loadOrderStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool)
    func pauseTimer()
    func resumeTimer()
    var statePublisher: AnyPublisher<OrderTrackingUseCase.State, Never> { get }
}

final class OrderTrackingUseCase: OrderTrackingUseCaseProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    private var stateSubject = PassthroughSubject<State, Never>()
    private var isTimerRunning = false
    private var elapsedTime: TimeInterval = 0
    private(set) var statusResponse: OrderTrackingStatusResponse?
    private let orderId: String
    private let orderNumber: String
    private let services: OrderTrackingServiceHandlerProtocol
    private var timer: TimerManagerProtocol
    let hideCancelOrderAfter: TimeInterval = 10 // Hide the cancel button after 10s
    private var showLoader = true
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(orderId: String, orderNumber: String, 
         services: OrderTrackingServiceHandlerProtocol, 
         timer: TimerManagerProtocol) {
        self.orderId = orderId
        self.orderNumber = orderNumber
        self.services = services
        self.timer = timer
    }
    
    deinit {
        timer.stop()
    }
    
    func fetchOrderStates() {
        loadOrderStatus(orderId: orderId, orderStatus: "\(OrderTrackingType.confirmation.rawValue)",
                        orderNumber: orderNumber, isComingFromFirebase: false)
    }
    
     func configOrderStatus(response: OrderTrackingStatusResponse) -> OrderTrackable {
        timer.stop() // Stop timer when the status is changed
        guard let status = response.orderDetails?.orderStatus,
              let value = OrderTrackingType(rawValue: status) else {
            return WaitingOrderConfig(response: response)
        }
        
        switch value {
        case .orderProcessing, .pickupChanged:
            return getProcessingOrderModel(response: response)
        case .waitingForTheRestaurant:
            return WaitingOrderConfig(response: response)
        case .orderAccepted:
            stateSubject.send(.showToastForArrivedOrder(isShow: true))
            return AcceptedOrderConfig(response: response)
        case .inTheKitchen, .orderHasBeenPickedUpDelivery:
            return InTheKitchenOrderConfig(response: response)
        case .orderIsReadyForPickup:
            return ReadyForPickupOrderConfig(response: response)
        case .orderHasBeenPickedUpPickup:
            return OrderHasBeenDeliveredConfig(response: response)
        case .orderIsOnTheWay:
            let status = OnTheWayOrderConfig(response: response)
            stateSubject.send(.showToastForNoLiveTracking(isShow: status.isLiveTracking))
            if status.isLiveTracking {
                let liveTracingId = response.orderDetails?.liveTrackingId ?? ""
                stateSubject.send(.trackDriverLocation(liveTrackingId: liveTracingId))
            }
            return status
        case .orderCancelled:
            return CanceledOrderConfig(response: response)
        case .changedToPickup:
            return ChangedToPickupOrderConfig(response: response)
        case .confirmation:
            return ConfirmationOrderConfig(response: response)
        case .someItemsAreUnavailable:
            return SomeItemsUnavailableConfig(response: response)
        case .orderNearYourLocation:
            return NearOfLocationConfig(response: response)
        case .delivered:
            return DeliveredOrderConfig(response: response)
        }
    }
    
    private func getProcessingOrderModel(response: OrderTrackingStatusResponse) -> OrderTrackable {
        let processOrder = ProcessingOrderConfig(response: response)
        
        if processOrder.isCancelationAllowed {
            timer.start(stopTimerAfter: hideCancelOrderAfter)
            
            timer.timerTickHandler = { [weak self] in
                self?.hideCancelButton()
            }
        }
        
        return processOrder
    }
    
    func loadOrderStatus(orderId: String, orderStatus: String, orderNumber: String, isComingFromFirebase: Bool) {
        // Show Loader only one timer
        if showLoader {
            self.stateSubject.send(.showLoader)
            showLoader = false
        }
        services.getOrderTrackingStatus(orderId: orderId,
                                       orderStatus: orderStatus,
                                       orderNumber: orderNumber, isComingFromFirebase: isComingFromFirebase)
        .sink { [weak self] completion in
            self?.stateSubject.send(.hideLoader)
            if case .failure(let error) = completion {
                debugPrint(error.localizedDescription)
//                self?.stateSubject.send(.showErrorAndPop(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] response in
            guard let self else {
                return
            }
            self.stateSubject.send(.hideLoader)
            let status = self.configOrderStatus(response: response).build()
            self.statusResponse = response
            self.stateSubject.send(.success(model: status))
            let orderId = response.orderDetails?.orderId
            let orderNumber = response.orderDetails?.orderNumber
            let orderStatus = response.orderDetails?.orderStatus
            let type = OrderTrackingType(rawValue: orderStatus.asIntOrEmpty()) ?? .inTheKitchen
            self.stateSubject.send(.orderId(id: "\(orderId.asIntOrEmpty())", orderNumber: orderNumber.asStringOrEmpty(), orderStatus: type))
            let isLiveTracking = response.orderDetails?.liveTracking
            self.stateSubject.send(.isLiveTracking(isLiveTracking: isLiveTracking.asBoolOrFalse()))
        }.store(in: &cancellables)
    }
    
    func pauseTimer() {
        timer.pause()
    }
    
    func resumeTimer() {
        timer.resume()
    }
    
    private func hideCancelButton() {
        guard var statusResponse else {
            return
        }
        statusResponse.orderDetails?.showCancelButtonTimeout = true
        statusResponse.orderDetails?.isCancelationAllowed = false
        self.statusResponse = statusResponse
        let status = ProcessingOrderConfig(response: statusResponse).build()
        stateSubject.send(.success(model: status))
    }
}

extension OrderTrackingUseCase {
    enum State: Equatable {
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
