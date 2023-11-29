//
//  SmilesOrderCancelledViewModel.swift
//
//
//  Created by Shmeel Ahmed on 28/11/2023.
//


import Foundation
import Combine
import NetworkingLayer

class SmilesOrderCancelledViewModel: NSObject {
    let service = OrderTrackingServiceHandler()
    // MARK: - INPUT. View event methods
    enum Input {
        case cancelOrder(ordeId:String, reason:String?)
    }
    
    enum Output {
        case cancelOrderDidSucceed(response: OrderCancelResponse)
        case cancelOrderDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension SmilesOrderCancelledViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .cancelOrder(let orderId, let reason):
                self?.cancelOrder(id: orderId, rejectionReason: reason)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func cancelOrder(id:String, rejectionReason:String?) {
        service.cancelOrder(orderId: id, rejectionReason: rejectionReason)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.cancelOrderDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.cancelOrderDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
