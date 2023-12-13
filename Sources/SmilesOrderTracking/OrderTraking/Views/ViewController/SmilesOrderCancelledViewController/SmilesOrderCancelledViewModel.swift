//
//  SmilesOrderCancelledViewModel.swift
//
//
//  Created by Shmeel Ahmed on 28/11/2023.
//


import Foundation
import Combine
import NetworkingLayer
import SmilesLoader

class SmilesOrderCancelledViewModel: NSObject {
    let service = OrderTrackingServiceHandler(repository: TrackOrderConfigurator.repository)
    var liveChatUseCase = LiveChatUseCase()
    var chatbotType = ""
    var orderId = ""
    var orderNumber = ""
    @Published private(set) var liveChatUrl: String?
    
    // MARK: - INPUT. View event methods
    enum Input {
        case cancelOrder(ordeId:String, reason:String?)
        case pauseOrder(ordeId:String)
        case resumeOrder(ordeId:String)
    }
    
    enum Output {
        case cancelOrderDidSucceed(response: OrderCancelResponse)
        case cancelOrderDidFail(error: NetworkError)
        
        case pauseOrderDidSucceed(response: BaseMainResponse)
        case pauseOrderDidFail(error: NetworkError)
        
        case resumeOrderDidSucceed(response: BaseMainResponse)
        case resumeOrderDidFail(error: NetworkError)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension SmilesOrderCancelledViewModel {
    func getLiveChatUrl() {
        liveChatUseCase.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .showError(let error):
                SmilesLoader.dismiss()
                print(error.localizedString)
            case .navigateToLiveChatWebview(let url):
                SmilesLoader.dismiss()
                self.liveChatUrl = url
            }
        }.store(in: &cancellables)
        
        SmilesLoader.show()
        liveChatUseCase.getLiveChatUrl(with: "\(orderId)", chatbotType: chatbotType, orderNumber: orderNumber)
    }
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
        SmilesLoader.show()
        service.cancelOrder(orderId: id, rejectionReason: rejectionReason)
            .sink {completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    SmilesLoader.dismiss()
                    self.output.send(.cancelOrderDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: {response in
                SmilesLoader.dismiss()
                debugPrint("got my response here \(response)")
                self.output.send(.cancelOrderDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
    
    func pauseOrder(id:String) {
        SmilesLoader.show()
        service.pauseOrder(orderId: id)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    SmilesLoader.dismiss()
                    self?.output.send(.pauseOrderDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                SmilesLoader.dismiss()
                debugPrint("got my response here \(response)")
                self?.output.send(.pauseOrderDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
    
    func resumeOrder(id:String) {
        SmilesLoader.show()
        service.resumeOrder(orderId: id)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    SmilesLoader.dismiss()
                    self?.output.send(.resumeOrderDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                SmilesLoader.dismiss()
                self?.output.send(.resumeOrderDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
    
    
}
