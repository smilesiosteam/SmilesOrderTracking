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
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = OrderTrackingServiceHandlerMock()
        sut = OrderTrackingUseCase(orderId: Constants.orderId.rawValue, orderNumber: Constants.orderNumber.rawValue, services: services, timer: TimerManager())
    }

    override func tearDownWithError() throws {
        services = nil
        sut = nil
    }

    // MARK: - Tests
    func test_fetchOrderStates_success_orderProcessing()  {
        // Given
        let model = OrderStatusStub.getOrderStatusModel
        let result = PublisherSpy(sut.stateSubject.collectNext(5))
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
        let result = PublisherSpy(sut.stateSubject.collectNext(2))
        services.getOrderTrackingStatus = .failure(.badURL(errorMessage))
        // When
        sut.fetchOrderStates()
        // Then
        XCTAssertEqual(result.value, [.hideLoader, .showErrorAndPop(message: errorMessage)])
    }
    
    func test_hideCancelOrderAfter_mustBe10Seconds() {
        XCTAssertEqual(sut.hideCancelOrderAfter, 10, "The seconds must be 10s")
    }
}
