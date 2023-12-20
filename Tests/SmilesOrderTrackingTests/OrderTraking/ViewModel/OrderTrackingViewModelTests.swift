//
//  OrderTrackingViewModelTests.swift
//
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import XCTest
import SmilesTests
import Combine
@testable import SmilesOrderTracking

final class OrderTrackingViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: OrderTrackingViewModel!
    private var orderTrackingUseCase: OrderTrackingUseCaseMock!
    private var confirmUseCase: OrderConfirmationUseCaseMock!
    private var changeTypeUseCase: ChangeTypeUseCaseMock!
    private var scratchAndWinUseCase: ScratchAndWinUseCaseMock!
    private var firebasePublisher = PassthroughSubject<LiveTrackingState, Never>()
    private var pauseOrderUseCase: PauseOrderUseCaseMock!
    private var navigationDelegate: OrderTrackingNavigationSpy!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        orderTrackingUseCase = OrderTrackingUseCaseMock()
        confirmUseCase = OrderConfirmationUseCaseMock()
        changeTypeUseCase = ChangeTypeUseCaseMock()
        scratchAndWinUseCase = ScratchAndWinUseCaseMock()
        pauseOrderUseCase = PauseOrderUseCaseMock()
        navigationDelegate = OrderTrackingNavigationSpy()
        sut = OrderTrackingViewModel(useCase: orderTrackingUseCase,
                                     confirmUseCase: confirmUseCase,
                                     changeTypeUseCase: changeTypeUseCase,
                                     scratchAndWinUseCase: scratchAndWinUseCase,
                                     firebasePublisher: firebasePublisher.eraseToAnyPublisher(),
                                     pauseOrderUseCase: pauseOrderUseCase)
        sut.navigationDelegate = navigationDelegate
    }
    
    override func tearDownWithError() throws {
        orderTrackingUseCase = nil
        confirmUseCase = nil
        changeTypeUseCase = nil
        scratchAndWinUseCase = nil
        pauseOrderUseCase = nil
        sut = nil
    }
    
    // MARK: - Tests
    func test_fetchStatus_showErrorAndPop() {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        let result = PublisherSpy(sut.orderStatusPublisher)
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.showErrorAndPop(message: errorMessage))
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
        
        if case let OrderTrackingViewModel.State.showErrorAndPop(message) = result.value! {
            XCTAssertTrue(message == errorMessage)
        } else {
            XCTFail("Expected .showErrorAndPop, but got \(result.value ?? .hideLoader)")
        }
    }
    
    func test_fetchStatus_showToastForArrivedOrder() {
        // Given
        let result = PublisherSpy(sut.orderStatusPublisher)
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.showToastForArrivedOrder(isShow: true))
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
        
        if case let OrderTrackingViewModel.State.showToastForArrivedOrder(isShow: show) = result.value! {
            XCTAssertTrue(show)
        } else {
            XCTFail("Expected .showToastForArrivedOrder, but got \(result.value ?? .hideLoader)")
        }
    }
    
    func test_fetchStatus_showToastForNoLiveTracking() {
        // Given
        let result = PublisherSpy(sut.orderStatusPublisher)
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.showToastForNoLiveTracking(isShow: true))
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
        
        if case let OrderTrackingViewModel.State.showToastForNoLiveTracking(isShow: show) = result.value! {
            XCTAssertTrue(show)
        } else {
            XCTFail("Expected .showToastForNoLiveTracking, but got \(result.value ?? .hideLoader)")
        }
    }
    
    func test_fetchStatus_success() {
        // Given
        let result = PublisherSpy(sut.orderStatusPublisher)
        let orderTrackingModel = OrderTrackingModel(header:
                .image(model: .init(type: .animation(url: nil, backgroundColor: ""))),
                                                    cells: [.cashVoucher(model: .init())])
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.success(model: orderTrackingModel))
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
        
        if case let OrderTrackingViewModel.State.success(model: model) = result.value! {
            XCTAssertEqual(model, orderTrackingModel)
        } else {
            XCTFail("Expected .success, but got \(result.value ?? .hideLoader)")
        }
    }
    
    func test_fetchStatus_orderId() {
        // Given
        let orderId = Constants.orderId.rawValue
        let orderNumber = Constants.orderNumber.rawValue
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.orderId(id: orderId, orderNumber: orderNumber, orderStatus: .orderProcessing))
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
        XCTAssertEqual(sut.orderId, orderId)
        XCTAssertEqual(sut.orderNumber, orderNumber)
        XCTAssertEqual(sut.orderStatus, .orderProcessing)
    }
    
    func test_fetchStatus_trackDriverLocation() {
        // Given
        let liveTrackingId = "#eewewe"
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.trackDriverLocation(liveTrackingId: liveTrackingId))
        // Then
        XCTAssertTrue(navigationDelegate.isLiveLocationCalled)
        XCTAssertEqual(navigationDelegate.liveTrackingId, liveTrackingId)
    }
    
    func test_fetchStatus_showLoader() {
        // Given
        let result = PublisherSpy(sut.orderStatusPublisher)
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.showLoader)
        // Then
        if case OrderTrackingViewModel.State.showLoader = result.value! {
        // Success
        } else {
            XCTFail("Expected .success, but got \(result.value ?? .hideLoader)")
        }
    }
    
    func test_fetchStatus_hideLoader() {
        // Given
        let result = PublisherSpy(sut.orderStatusPublisher)
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.hideLoader)
        // Then
        if case OrderTrackingViewModel.State.hideLoader = result.value! {
        // Success
        } else {
            XCTFail("Expected .success, but got \(result.value ?? .hideLoader)")
        }
    }
    
    func test_fetchStatus_isLiveTracking() {
        // When
        sut.fetchStatus()
        orderTrackingUseCase.stateSubject.send(.isLiveTracking(isLiveTracking: true))
        // Then
        XCTAssertTrue(sut.isLiveTracking)
    }
    
    func test_pauseTimer_isCalled() {
        // When
        sut.pauseTimer()
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledPauseTimer)
    }
    
    func test_resumeTimer_isCalled() {
        // When
        sut.resumeTimer()
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledResumeTimer)
    }
    
    func test_setConfirmationStatus_success_callOrderStatus() {
        // Given
        confirmUseCase.orderConfirmationResponse = .success(.callOrderStatus)
        // When
        sut.setConfirmationStatus(orderId: Constants.orderId.rawValue, orderStatus: .confirmation, isUserDeliveredOrder: true, orderNumber: Constants.orderNumber.rawValue)
        // Then
        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
        
    }
    
//    func test_setConfirmationStatus_success_openLiveChat() {
//        // Given
//        let result = PublisherSpy(sut.orderStatusPublisher.collectNext(2))
//        confirmUseCase.orderConfirmationResponse = .success(.openLiveChat)
//        // When
//        sut.setConfirmationStatus(orderId: Constants.orderId.rawValue, orderStatus: .confirmation, isUserDeliveredOrder: true, orderNumber: Constants.orderNumber.rawValue)
//        // Then
//        XCTAssertTrue(orderTrackingUseCase.isCalledFetchOrderStates)
//        
//        
//    }
}
