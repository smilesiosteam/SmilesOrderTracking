//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import Combine

protocol GetSupportUseCaseProtocol {
    func fetchOrderStates()
    var statePublisher: AnyPublisher<GetSupportUseCase.State, Never> { get }
}

final class GetSupportUseCase: GetSupportUseCaseProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    private let orderId: String
    private let orderNumber: String
    private var stateSubject = PassthroughSubject<State, Never>()
    private let services: OrderTrackingServiceHandlerProtocol
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
    
    
    func fetchOrderStates() {
        loadOrderStatus()
    }
    
    private func configOrderStatus(response: OrderTrackingStatusResponse) -> GetSupportModel {
        guard let status = response.orderDetails?.orderStatus,
              let value = OrderTrackingType(rawValue: status) else {
            return .init()
        }
        
        switch value {
        case .orderProcessing, .pickupChanged:
            return getProcessingOrderModel(response: response)
        case .waitingForTheRestaurant:
            return WaitingOrderConfig(response: response).buildConfig()
        case .orderAccepted:
            stateSubject.send(.showToastForArrivedOrder(isShow: true))
            return AcceptedOrderConfig(response: response).buildConfig()
        case .inTheKitchen, .orderHasBeenPickedUpDelivery:
            return InTheKitchenOrderConfig(response: response).buildConfig()
        case .orderIsReadyForPickup:
            return ReadyForPickupOrderConfig(response: response).buildConfig()
        case .orderHasBeenPickedUpPickup:
            return OrderHasBeenDeliveredConfig(response: response).buildConfig()
        case .orderIsOnTheWay:
            let status = OnTheWayOrderConfig(response: response)
            stateSubject.send(.showToastForNoLiveTracking(isShow: status.isLiveTracking))
            return status.buildConfig()
        case .orderCancelled:
            return CanceledOrderConfig(response: response).buildConfig()
        case .changedToPickup:
            return ChangedToPickupOrderConfig(response: response).buildConfig()
        case .confirmation:
            return ConfirmationOrderConfig(response: response).buildConfig()
        case .someItemsAreUnavailable:
            return SomeItemsUnavailableConfig(response: response).buildConfig()
        case .orderNearYourLocation:
            return NearOfLocationConfig(response: response).buildConfig()
        case .delivered:
            return DeliveredOrderConfig(response: response).buildConfig()
        }
    }
    
    private func getProcessingOrderModel(response: OrderTrackingStatusResponse) -> GetSupportModel {
        let processOrder = ProcessingOrderConfig(response: response)
        return processOrder.buildConfig()
    }
    
    private func loadOrderStatus() {
        let handler = OrderTrackingServiceHandler(repository: TrackOrderConfigurator.repository)
        handler.getOrderTrackingStatus(orderId: orderId,
                                       orderStatus: "5",
                                       orderNumber: orderNumber, isComingFromFirebase: false)
        .sink { completion in
            switch completion {
                
            case .finished:
                print("finished")
            case .failure(let error):
//                self?.stateSubject.send(.showError(message: error.localizedDescription))
                debugPrint(error.localizedDescription)
            }
        } receiveValue: { [weak self] response in
            guard let self else {
                return
            }
            
            self.statusResponse = response
            let status = self.configOrderStatus(response: response)
            self.stateSubject.send(.success(model: status))
        }.store(in: &cancellables)
    }
    
}

extension GetSupportUseCase {
    enum State {
        case showError(message: String)
        case showToastForArrivedOrder(isShow: Bool)
        case showToastForNoLiveTracking(isShow: Bool)
        case success(model: GetSupportModel)
    }
}
