//
//  PauseOrderUseCaseTests.swift
//  
//
//  Created by Ahmed Naguib on 14/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class PauseOrderUseCaseTests: XCTestCase {
    // MARK: - Properties
    private var sut: PauseOrderUseCase!
    private var services: OrderTrackingServiceHandlerMock!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
       services = OrderTrackingServiceHandlerMock()
        sut = PauseOrderUseCase(services: services)
    }

    override func tearDownWithError() throws {
        services = nil
        sut = nil
    }
    
    // MARK: - Tests
    func test_pauseOrder_success_presentPopupCancelFlow() throws {
        // Given
        services.pauseOrderResponse = .success(.init())
        let orderId = Constants.orderId.rawValue
        // When
       let publisher = sut.pauseOrder(orderId: orderId)
        // Then
        let result = try awaitPublisher(publisher)
        let expectedResult = PauseOrderUseCase.State.presentPopupCancelFlow
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_pauseOrder_fail_showErroe() throws {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        services.pauseOrderResponse = .failure(.badURL(errorMessage))
        let orderId = Constants.orderId.rawValue
        // When
       let publisher = sut.pauseOrder(orderId: orderId)
        // Then
        let result = try awaitPublisher(publisher)
        let expectedResult = PauseOrderUseCase.State.showError(message: errorMessage)
        XCTAssertEqual(result, expectedResult)
    }
}
