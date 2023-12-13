//
//  ChangeTypeUseCaseTests.swift
//  
//
//  Created by Ahmed Naguib on 13/12/2023.
//

import XCTest
import Combine
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
        let orderId = "12334"
        let orderNumber = "#343434"
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


extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        action: (() throws -> Void) = {  },
        timeout: TimeInterval = 1.0,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        try? action()
        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
