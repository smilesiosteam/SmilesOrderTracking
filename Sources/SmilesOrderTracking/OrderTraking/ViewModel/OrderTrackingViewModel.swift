//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation
import Combine
final class OrderTrackingViewModel {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let useCase = OrderTrackingUseCase()
//    var orderStatusModel = OrderTrackingModel()
    var orderStatusSubject = PassthroughSubject<OrderTrackingModel, Never>()
    var serviceHandler = OrderTrackingServiceHandler()
//     var firebaseDatabaseManager = FirebaseDatabaseManager()
    @Published private(set) var isShowToast = false
    init() {
//        firebaseDatabaseManager.delegate = self
//        configProcessingOrder()
        
       
        useCase.$isOrderArrived.sink { [weak self] value in
            self?.isShowToast = value
        }.store(in: &cancellables)
        bindOrderStatus()
    }
    
    func fetchOrderStatus(status: Int? = nil) {
        useCase.fetchOrderStates(with: status)
    }
    
    private func bindOrderStatus() {
        useCase.orderStatus.sink { result in
            self.orderStatusSubject.send(result)
        }
        .store(in: &cancellables)
    }
}

// MARK: - FirebaseDatabaseManagerDelegate
//extension OrderTrackingViewModel: FirebaseDatabaseManagerDelegate {
//    func orderStatusDidChange(with orderId: String, orderNumber: String, orderStatus: OrderTrackingType, comingFromFirebase: Bool) {
//        // Todo: Call getOrderStatus api here
//    }
//    
//    func liveLocationDidUpdate(with latitude: Double, longitude: Double) {
//        // Todo: Update rider location on map
//    }
//}
