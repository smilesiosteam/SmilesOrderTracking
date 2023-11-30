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
        case pauseOrder(ordeId:String)
        case resumeOrder(ordeId:String)
    }
    
    enum Output {
        case cancelOrderDidSucceed(response: OrderCancelResponse)
        case cancelOrderDidFail(error: Error)
        
        case pauseOrderDidSucceed(response: BaseMainResponse)
        case pauseOrderDidFail(error: Error)
        
        case resumeOrderDidSucceed(response: BaseMainResponse)
        case resumeOrderDidFail(error: Error)
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
            case .pauseOrder(let orderId):
                self?.pauseOrder(id: orderId)
            case .resumeOrder(let orderId):
                self?.resumeOrder(id: orderId)
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
    
    func pauseOrder(id:String) {
        service.pauseOrder(orderId: id)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.pauseOrderDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.pauseOrderDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
    
    func resumeOrder(id:String) {
        service.resumeOrder(orderId: id)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.resumeOrderDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.resumeOrderDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
    
    
}
