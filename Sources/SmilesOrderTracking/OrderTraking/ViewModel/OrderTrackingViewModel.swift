//
//  File.swift
//
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation
import Combine
import SmilesScratchHandler

final class OrderTrackingViewModel {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var serviceHandler = OrderTrackingServiceHandler()
    
    private let useCase: OrderTrackingUseCaseProtocol
    private let confirmUseCase: OrderConfirmationUseCaseProtocol
    private let pauseOrderUseCase: PauseOrderUseCaseProtocol
    private var statusSubject = PassthroughSubject<State, Never>()
    private let changeTypeUseCase: ChangeTypeUseCaseProtocol
    private let scratchAndWinUseCase: ScratchAndWinUseCaseProtocol
    private let firebasePublisher: AnyPublisher<LiveTrackingState, Never>
    var orderId = ""
    var orderNumber = ""
    var checkForVoucher = false
    var chatbotType = ""
    var orderStatusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    var navigationDelegate: OrderTrackingNavigationProtocol?
    
    // MARK: - Init
    init(useCase: OrderTrackingUseCaseProtocol,
         confirmUseCase: OrderConfirmationUseCaseProtocol,
         changeTypeUseCase: ChangeTypeUseCaseProtocol,
         scratchAndWinUseCase: ScratchAndWinUseCaseProtocol,
         firebasePublisher: AnyPublisher<LiveTrackingState, Never>,
         pauseOrderUseCase: PauseOrderUseCaseProtocol) {
        self.useCase = useCase
        self.confirmUseCase = confirmUseCase
        self.changeTypeUseCase = changeTypeUseCase
        self.scratchAndWinUseCase = scratchAndWinUseCase
        self.firebasePublisher = firebasePublisher
        self.pauseOrderUseCase = pauseOrderUseCase
    }
    
    func fetchStatus() {
        bindLiveTracking()
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
            case .showToastForArrivedOrder(let isShow):
                self.statusSubject.send(.showToastForArrivedOrder(isShow: isShow))
            case .showToastForNoLiveTracking(let isShow):
                self.statusSubject.send(.showToastForNoLiveTracking(isShow: isShow))
            case .success(let model):
                self.statusSubject.send(.success(model: model))
            case .orderId(let id, let orderNumber):
                self.orderId = id
                self.orderNumber = orderNumber
            case .trackDriverLocation(liveTrackingId: let liveTrackingId):
                self.navigationDelegate?.liveLocation(liveTrackingId: liveTrackingId)
            }
        }
        .store(in: &cancellables)
    }
    
    
    func setConfirmationStatus(orderId: String, orderStatus: OrderTrackingType, isUserDeliveredOrder: Bool, orderNumber: String) {
        statusSubject.send(.showLoader)
        confirmUseCase.setOrderConfirmation(orderId: orderId,
                                            orderStatus: orderStatus,
                                            isUserDeliveredOrder: isUserDeliveredOrder)
        .sink { [weak self] state in
            guard let self else {
                return
            }
            
            switch state {
            case .showError(message: let message):
                self.statusSubject.send(.hideLoader)
                self.statusSubject.send(.showError(message: message))
            case .openLiveChat:
                self.statusSubject.send(.hideLoader)
                self.navigationDelegate?.openLiveChat(orderId: orderId, orderNumber: orderNumber)
            case .callOrderStatus:
                self.fetchStatus()
            }
        }
        .store(in: &cancellables)
    }
    
    func changeType(orderId: String, orderNumber: String) {
        statusSubject.send(.showLoader)
        changeTypeUseCase.changeType(orderId: orderId, orderNumber: orderNumber)
            .sink { [weak self] state in
                guard let self else {
                    return
                }
                switch state {
                    
                case .showError(message: let message):
                    self.statusSubject.send(.hideLoader)
                    self.statusSubject.send(.showError(message: message))
                    self.statusSubject.send(.timerIsOff)
                case .navigateToOrderConfirmation(orderId: let orderId, orderNumber: let orderNumber):
                    self.statusSubject.send(.hideLoader)
                    self.navigationDelegate?.navigationToOrderConfirmation(orderId: orderId, orderNumber: orderNumber)
                case .callOrderStatus:
                    self.fetchStatus()
                }
            }
            .store(in: &cancellables)
    }
    
    func pauseTimer() {
        useCase.pauseTimer()
    }
    
    func resumeTimer() {
        useCase.resumeTimer()
    }
    
    func pauseOrder(orderId: String) {
        statusSubject.send(.showLoader)
        pauseOrderUseCase.pauseOrder(orderId: orderId)
            .sink { [weak self] state in
                guard let self else {
                    return
                }
                self.statusSubject.send(.hideLoader)
                switch state {
                    
                case .showError(message: let message):
                    self.statusSubject.send(.showError(message: message))
                case .presentPopupCancelFlow:
                    self.statusSubject.send(.presentCancelFlow(orderId: self.orderId))
                }
            }
            .store(in: &cancellables)
    }
    
    func setupScratchAndWin(orderId: String, isVoucherScratched: Bool) {
        scratchAndWinUseCase.statePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .showError(let message):
                self.statusSubject.send(.hideLoader)
                self.statusSubject.send(.showError(message: message))
            case .presentScratchAndWin(let response):
                self.statusSubject.send(.hideLoader)
                self.statusSubject.send(.presentScratchAndWin(response: response))
            }
        }.store(in: &cancellables)
        
        statusSubject.send(.showLoader)
        scratchAndWinUseCase.configureScratchAndWin(with: orderId, isVoucherScratched: isVoucherScratched)
    }
    
    func bindLiveTracking() {
        firebasePublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .orderStatusDidChange(let orderId, let orderNumber, let orderStatus, let comingFromFirebase):
                print("LIVE ORDER: \(orderId) \(orderStatus)")
            case .liveLocationDidUpdate(let latitude, let longitude):
                print("LIVE LOCATION: \(latitude) \(longitude)")
            }
        }.store(in: &cancellables)
    }
}

extension OrderTrackingViewModel {
    enum State {
        case showLoader
        case hideLoader
        case showError(message: String)
        case showToastForArrivedOrder(isShow: Bool)
        case showToastForNoLiveTracking(isShow: Bool)
        case success(model: OrderTrackingModel)
        case timerIsOff
        case presentScratchAndWin(response: ScratchAndWinResponse)
        case presentCancelFlow(orderId: String)
        case driverLocation(lat: Double, long: Double)
    }
}
