//
//  OrderTrackingUseCaseTests 2.swift
//  
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import XCTest
import SmilesTests
import Combine
@testable import SmilesOrderTracking

final class OrderTrackingUseCaseTests: XCTestCase {

    // MARK: - Properties
    private var sut: OrderTrackingUseCase!
    private var services: OrderTrackingServiceHandlerMock!
    private var timer: TimerManagerMock!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = OrderTrackingServiceHandlerMock()
        timer = TimerManagerMock()
        sut = OrderTrackingUseCase(orderId: Constants.orderId.rawValue, orderNumber: Constants.orderNumber.rawValue, services: services, timer: timer)
    }

    override func tearDownWithError() throws {
        services = nil
        sut = nil
    }

    // MARK: - Tests
    func test_fetchOrderStates_success_orderProcessing()  {
        // Given
        let model = OrderStatusStub.getOrderStatusModel
        let result = PublisherSpy(sut.statePublisher.collectNext(5))
        services.getOrderTrackingStatus = .success(model)
        // When
        sut.fetchOrderStates()
        // Then
        let type: OrderTrackingUseCase.State = .orderId(id: "466715", orderNumber: "SMHD112020230000467215", orderStatus: .orderProcessing)
        XCTAssertEqual(result.value, [.hideLoader, .success(model: .init()), type, .isLiveTracking(isLiveTracking: false), .hideLoader])
    }
    
    func test_fetchOrderStates_fail_showError() {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        let result = PublisherSpy(sut.statePublisher.collectNext(2))
        services.getOrderTrackingStatus = .failure(.badURL(errorMessage))
        // When
        sut.fetchOrderStates()
        // Then
        XCTAssertEqual(result.value, [.hideLoader, .showErrorAndPop(message: errorMessage)])
    }
    
    func test_hideCancelOrderAfter_mustBe10Seconds() {
        XCTAssertEqual(sut.hideCancelOrderAfter, 10, "The seconds must be 10s")
    }
    
    func test_getProcessingOrderModel_isCancelationAllowed_startTimer() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.isCancelationAllowed = true
        services.getOrderTrackingStatus = .success(model)
        // When
        sut.fetchOrderStates()
        // Then
        XCTAssertTrue(timer.isCalledStartTimer)
    }
    
    func test_getProcessingOrderModel_isCancelationAllowed_hideCancelButton() {
        // Given
        let result = PublisherSpy(sut.statePublisher.collectNext(6))
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.isCancelationAllowed = true
        services.getOrderTrackingStatus = .success(model)
        // When
        sut.fetchOrderStates()
        timer.stop()
        // Then
        XCTAssertTrue(timer.isCalledStartTimer)
        XCTAssertTrue(sut.statusResponse?.orderDetails?.showCancelButtonTimeout ?? false)
        XCTAssertFalse(sut.statusResponse?.orderDetails?.isCancelationAllowed ?? true)
        let type: OrderTrackingUseCase.State = .orderId(id: "466715", orderNumber: "SMHD112020230000467215", orderStatus: .orderProcessing)
        XCTAssertEqual(result.value, [.hideLoader, .success(model: .init()), type, .isLiveTracking(isLiveTracking: false), .hideLoader, .success(model: .init())])
    }
    
    func test_pauseTimer_isCalled() {
        // When
        sut.pauseTimer()
        // Then
        XCTAssertTrue(timer.isCalledPauseTimer)
    }
    
    func test_resumeTimer_isCalled() {
        // When
        sut.resumeTimer()
        // Then
        XCTAssertTrue(timer.isCalledResumeTimer)
    }
    
    func test_stopTimer_isCalled() {
        // Given
        let model = OrderStatusStub.getOrderStatusModel
        // When
       let _ = sut.configOrderStatus(response: model)
        // Then
        XCTAssertTrue(timer.isCalledStopTimer)
    }
    
    func test_configOrderStatus_orderProcessing() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 0
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is ProcessingOrderConfig)
    }
    
    func test_configOrderStatus_pickupChanged() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 12
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is ProcessingOrderConfig)
    }
    
    func test_configOrderStatus_waitingForTheRestaurant() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 1
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is WaitingOrderConfig)
    }
    
    func test_configOrderStatus_orderAccepted() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 2
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is AcceptedOrderConfig)
    }
    
    func test_configOrderStatus_inTheKitchen() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 3
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is InTheKitchenOrderConfig)
    }
    
    func test_configOrderStatus_orderHasBeenPickedUpDelivery() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 13
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is InTheKitchenOrderConfig)
    }
    
    func test_configOrderStatus_orderIsReadyForPickup() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 4
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is ReadyForPickupOrderConfig)
    }
    
    func test_configOrderStatus_orderHasBeenPickedUpPickup() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 5
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is OrderHasBeenDeliveredConfig)
    }
    
    func test_configOrderStatus_orderIsOnTheWay() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 6
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is OnTheWayOrderConfig)
    }
    
    func test_configOrderStatus_orderCancelled() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 8
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is CanceledOrderConfig)
    }
    
    func test_configOrderStatus_changedToPickup() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 9
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is ChangedToPickupOrderConfig)
    }
    
    func test_configOrderStatus_confirmation() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 10
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is ConfirmationOrderConfig)
    }
    
    func test_configOrderStatus_someItemsAreUnavailable() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 11
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is SomeItemsUnavailableConfig)
    }
    
    func test_configOrderStatus_orderNearYourLocation() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 14
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is NearOfLocationConfig)
    }
    
    func test_configOrderStatus_delivered() {
        // Given
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 7
        // When
        let result = sut.configOrderStatus(response: model)
        XCTAssertTrue(result is DeliveredOrderConfig)
    }
    
    func test_configOrderStatus_orderIsOnTheWay_hasLiveTracking_showToast() {
        // Given
        let publisher = PublisherSpy(sut.statePublisher)
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 6
        model.orderDetails?.liveTracking = true
        let liveTracingId = model.orderDetails?.liveTrackingId ?? ""
        // When
        let result = sut.configOrderStatus(response: model)
        // Then
        XCTAssertTrue(result is OnTheWayOrderConfig)
        
        XCTAssertEqual(publisher.value, .trackDriverLocation(liveTrackingId: liveTracingId))
    }
    
    func test_configOrderStatus_orderIsOnTheWay_notHasLiveTracking_showToast() {
        // Given
        let publisher = PublisherSpy(sut.statePublisher)
        var model = OrderStatusStub.getOrderStatusModel
        model.orderDetails?.orderStatus = 6
        model.orderDetails?.liveTracking = false
        // When
        let result = sut.configOrderStatus(response: model)
        // Then
        XCTAssertTrue(result is OnTheWayOrderConfig)
        
        XCTAssertEqual(publisher.value, .showToastForNoLiveTracking(isShow: false))
    }
}
