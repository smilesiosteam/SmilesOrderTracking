//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 06/12/2023.
//

import Foundation
import Combine
import SmilesLoader

final class GetSupportViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var serviceHandler = OrderTrackingServiceHandler(repository: TrackOrderConfigurator.repository)
    private let useCase: GetSupportUseCase
    private var statusSubject = PassthroughSubject<GetSupportViewModel.State, Never>()
    var orderId = ""
    var orderNumber = ""
    var liveChatUseCase = LiveChatUseCase()
    var chatbotType = ""
    @Published private(set) var liveChatUrl: String?
    var orderStatusPublisher: AnyPublisher<GetSupportViewModel.State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    var navigationDelegate: OrderTrackingNavigationProtocol?
    
    // MARK: - Init
    init(useCase: GetSupportUseCase, orderId:String, orderNumber:String, chatBotType:String) {
        self.useCase = useCase
        self.orderId = orderId
        self.orderNumber = orderNumber
        self.chatbotType = chatBotType
    }
    
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
    
    func fetchStatus() {
        bindUseCase()
        useCase.fetchOrderStates()
    }
    
    private func bindUseCase() {
        statusSubject.send(.showLoader)
        useCase.statePublisher.sink { [weak self] states in
            guard let self else {
                return
            }
            self.statusSubject.send(.hideLoader)
            switch states {
            case .showError(let message):
                self.statusSubject.send(.showError(message: message))
            case .showToastForArrivedOrder:
                break
            case .showToastForNoLiveTracking:
                break
//                self.statusSubject.send(.showToastForNoLiveTracking(isShow: isShow))
            case .success(let model):
                self.statusSubject.send(.success(model: model))
            }
        }
        .store(in: &cancellables)
    }
}

extension GetSupportViewModel {
    enum State {
        case showLoader
        case hideLoader
        case showError(message: String)
        case success(model: GetSupportModel)
    }
}
