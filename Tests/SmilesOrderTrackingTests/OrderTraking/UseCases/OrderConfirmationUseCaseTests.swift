//
//  OrderTrackingUseCaseTests.swift
//
//
//  Created by Ahmed Naguib on 13/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class OrderConfirmationUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: OrderConfirmationUseCase!
    private var services: OrderTrackingServiceHandlerMock!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = OrderTrackingServiceHandlerMock()
        sut = OrderConfirmationUseCase(services: services)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        services = nil
    }
    
    // MARK: - Tests
    func test_setOrderConfirmation_success_callOrderStatusAPi() throws {
        // Given
        let response = OrderStatusStub.getOrderStatusModel
        services.setOrderConfirmationStatus = .success(response)
        let orderId = Constants.orderId.rawValue
        let status = OrderTrackingType.confirmation
        
        // When
        let publisher = sut.setOrderConfirmation(orderId: orderId, 
                                                 orderStatus: status,
                                                 isUserDeliveredOrder: true)
        
        // Then
        let result = try awaitPublisher(publisher)
        let expectedResult = OrderConfirmationUseCase.State.callOrderStatus
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_setOrderConfirmation_success_openLiveChat() throws {
        // Given
        let response = OrderStatusStub.getOrderStatusModel
        services.setOrderConfirmationStatus = .success(response)
        let orderId = Constants.orderId.rawValue
        let status = OrderTrackingType.confirmation
        // When
        let publisher = sut.setOrderConfirmation(orderId: orderId, orderStatus: status, isUserDeliveredOrder: false)
        // Then
        let result = try awaitPublisher(publisher)
        let expectedResult = OrderConfirmationUseCase.State.openLiveChat
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_setOrderConfirmation_success_showErrorMessage() throws {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        var response = OrderStatusStub.getOrderStatusModel
        response.responseMsg = errorMessage
        response.responseCode = Constants.responseCode.rawValue
        services.setOrderConfirmationStatus = .success(response)
        let orderId = Constants.orderId.rawValue
        let status = OrderTrackingType.confirmation
        // When
        let publisher = sut.setOrderConfirmation(orderId: orderId, orderStatus: status, isUserDeliveredOrder: false)
        // Then
        let result = try awaitPublisher(publisher)
        let expectedResult = OrderConfirmationUseCase.State.showError(message: errorMessage)
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_setOrderConfirmation_fail_showErrorMessage() throws {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        services.setOrderConfirmationStatus = .failure(.badURL(errorMessage))
        let orderId = Constants.orderId.rawValue
        let status = OrderTrackingType.confirmation
        // When
        let publisher = sut.setOrderConfirmation(orderId: orderId, orderStatus: status, isUserDeliveredOrder: false)
        // Then
        let result = try awaitPublisher(publisher)
        let expectedResult = OrderConfirmationUseCase.State.showError(message: errorMessage)
        XCTAssertEqual(result, expectedResult)
    }
    
}



