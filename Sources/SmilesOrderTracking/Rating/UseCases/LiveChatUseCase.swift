//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 06/12/2023.
//

import Foundation
import Combine
import SmilesSharedServices

protocol LiveChatUseCaseProtocol {
    func getLiveChatUrl(with orderId: String, chatbotType: String, orderNumber: String)
    var statePublisher: AnyPublisher<LiveChatUseCase.State, Never> { get }
}

final class LiveChatUseCase: LiveChatUseCaseProtocol {
    private let liveChatUrlViewModel = LiveChatUrlViewModel()
    private var liveChatUrlUseCaseInput: PassthroughSubject<LiveChatUrlViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var stateSubject = PassthroughSubject<State, Never>()
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private func bind(to viewModel: LiveChatUrlViewModel) {
        liveChatUrlUseCaseInput = PassthroughSubject<LiveChatUrlViewModel.Input, Never>()
        let output = viewModel.transform(input: liveChatUrlUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .getLiveChatUrlDidFail(let error):
                    self?.stateSubject.send(.showError(message: error.localizedDescription))
                case .getLiveChatUrlDidSucceed(let response):
                    self?.stateSubject.send(.navigateToLiveChatWebview(url: response.chatbotUrl.asStringOrEmpty()))
                }
            }.store(in: &cancellables)
    }
    
    func getLiveChatUrl(with orderId: String, chatbotType: String, orderNumber: String) {
        bind(to: liveChatUrlViewModel)
        liveChatUrlUseCaseInput.send(.getLiveChatUrl(orderId: orderId, chatbotType: chatbotType, orderNumber: orderNumber))
    }
}

extension LiveChatUseCase {
    enum State {
        case showError(message: String)
        case navigateToLiveChatWebview(url: String)
    }
}
