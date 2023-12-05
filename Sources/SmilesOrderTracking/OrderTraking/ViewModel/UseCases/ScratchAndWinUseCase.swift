//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 05/12/2023.
//

import Foundation
import Combine
import SmilesScratchHandler

protocol ScratchAndWinUseCaseProtocol {
    func configureScratchAndWin(with orderId: String, isVoucherScratched: Bool)
    var statePublisher: AnyPublisher<ScratchAndWinUseCase.State, Never> { get }
}

final class ScratchAndWinUseCase: ScratchAndWinUseCaseProtocol {
    private let scratchViewModel = ScratchAndWinViewModel()
    private var scratchAndWinUseCaseInput: PassthroughSubject<ScratchAndWinViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var stateSubject = PassthroughSubject<State, Never>()
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func configureScratchAndWin(with orderId: String, isVoucherScratched: Bool) {
        bind(to: scratchViewModel)
        scratchAndWinUseCaseInput.send(.getScratchAndWinData(orderId: orderId, isVoucherScratched: isVoucherScratched))
    }
    
    private func bind(to viewModel: ScratchAndWinViewModel) {
        scratchAndWinUseCaseInput = PassthroughSubject<ScratchAndWinViewModel.Input, Never>()
        let output = viewModel.transform(input: scratchAndWinUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchScratchAndWinDidFail(let error):
                    self?.stateSubject.send(.showError(message: error.localizedDescription))
                case .fetchScratchAndWinDidSucceed(let response):
                    if response.showPopup ?? false {
                        self?.stateSubject.send(.presentScratchAndWin(response: response))
                    }
                }
            }.store(in: &cancellables)
    }
}

extension ScratchAndWinUseCase {
    enum State {
        case showError(message: String)
        case presentScratchAndWin(response: ScratchAndWinResponse)
    }
}
