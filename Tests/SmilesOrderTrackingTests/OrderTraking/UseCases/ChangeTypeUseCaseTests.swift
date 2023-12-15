//
//  ChangeTypeUseCaseTests.swift
//  
//
//  Created by Ahmed Naguib on 13/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class ChangeTypeUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: ChangeTypeUseCase!
    private var services: OrderTrackingServiceHandlerMock!

    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = OrderTrackingServiceHandlerMock()
        sut = ChangeTypeUseCase(services: services)
    }

    override func tearDownWithError() throws {
        sut = nil
        services = nil
    }
    
    // MARK: - Tests
    func test_changeType_successResponse_navigateToOrderConfirmation() throws {
        // Given
        let model = OrderChangeStub.getChangeTypeModel(isChanged: true)
        services.changeOrderTypeResponse = .success(model)
        let orderId = Constants.orderId.rawValue
        let orderNumber = Constants.orderNumber.rawValue
        // When
        let publisher = sut.changeType(orderId: orderId, orderNumber: orderNumber)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = ChangeTypeUseCase.State.navigateToOrderConfirmation(orderId: orderId, orderNumber: orderNumber)
        XCTAssertEqual(result, expectedResult, "Expected navigate to Order Confirmation but is not happened")
    }
    
    func test_changeType_successResponse_callOrderStatus() throws {
        // Given
        let model = OrderChangeStub.getChangeTypeModel(isChanged: false)
        services.changeOrderTypeResponse = .success(model)
        let orderId = "12334"
        let orderNumber = "#343434"
        // When
        let publisher = sut.changeType(orderId: orderId, orderNumber: orderNumber)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = ChangeTypeUseCase.State.callOrderStatus
        XCTAssertEqual(result, expectedResult, "Expected navigate to call Order Status but is not happened")
    }
    
    func test_changeType_failureResponse_showError() throws {
        // Given
        let error = "Server error"
        services.changeOrderTypeResponse = .failure(.badURL(error))
        let orderId = "12334"
        let orderNumber = "#343434"
        // When
        let publisher = sut.changeType(orderId: orderId, orderNumber: orderNumber)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = ChangeTypeUseCase.State.showError(message: error)
        XCTAssertEqual(result, expectedResult, "Expected navigate to show error message but is not happened")
    }
}
