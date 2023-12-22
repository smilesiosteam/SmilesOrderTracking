//
//  ConfirmationOrderConfigTests.swift
//
//
//  Created by Ahmed Naguib on 21/12/2023.
//

import XCTest
@testable import SmilesOrderTracking

final class ConfirmationOrderConfigTests: XCTestCase {
    // MARK: - Properties
    private var sut: ConfirmationOrderConfig!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        sut = .init(response: OrderStatusStub.getOrderStatusModel)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Test
    func test_cells() {
        
        // Given
        var progressBar = OrderStatusStub.progressBar
        progressBar.step = .fourth
        progressBar.hideTimeLabel = true
        
        let text = OrderStatusStub.text
        
        var location = OrderStatusStub.location
        location.type = .details
        
        
        // When
        // Then
    }
    
}
