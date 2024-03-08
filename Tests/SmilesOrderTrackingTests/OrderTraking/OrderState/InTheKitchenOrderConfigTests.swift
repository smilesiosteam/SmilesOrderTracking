//
//  InTheKitchenOrderConfigTests.swift
//
//
//  Created by Ahmed Naguib on 19/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class InTheKitchenOrderConfigTests: XCTestCase {
    // MARK: - Properties
    private var sut: InTheKitchenOrderConfig!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        let response = OrderStatusStub.getOrderStatusModel
        sut = .init(response: response)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Tests
    func test_header_mapHeader() {
        // Given
        let header = OrderStatusStub.mapHeader
        // When
        let result = sut.build().header
        // Then
        XCTAssertEqual(result, header)
    }
    
    func test_cell_delivery_hasAllTypes() {
        // Progress Bar
        var progressBar = OrderStatusStub.progressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = false
        
        // Location
        var location = OrderStatusStub.location
        location.type = .details
        
        // Point
        let point = OrderStatusStub.point
        
        // Subscription
        let subscription = OrderStatusStub.subscription
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .location(model: location),
            .point(model: point),
            .subscription(model: subscription)
        ]
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
    
    func test_cells_hasOnlyProgressBarAndLocation() {
        // Given
        var response = OrderStatusStub.getOrderStatusModel
        response.orderDetails?.subscriptionBannerV2 = nil
        response.orderDetails?.earnPoints = 0
        response.orderDetails?.orderDescription = nil
        sut = .init(response: response)
        
        // Progress Bar
        var progressBar = OrderStatusStub.progressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = false
        
        // Location
        var location = OrderStatusStub.location
        location.type = .details
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .location(model: location),
        ]
        
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
    
    func test_cells_orderIsPickup() {
        // Given
        var response = OrderStatusStub.getOrderStatusModel
        response.orderDetails?.orderType = "PICK_UP"
        sut = .init(response: response)
        // Progress Bar
        var progressBar = OrderStatusStub.progressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = false
        
        // Driver
        var driver = OrderStatusStub.driver
        driver.title = OrderTrackingLocalization.pickUpOrderFrom.text
        driver.subTitle = response.orderDetails?.restaurantAddress
        driver.cellType = .pickup
        driver.placeName = response.orderDetails?.restaurantName ?? ""
        
        // Location
        let location = OrderStatusStub.orderAction
        
        // Point
        let point = OrderStatusStub.point
        
        // Subscription
        let subscription = OrderStatusStub.subscription
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .driver(model: driver),
            .orderActions(model: location),
            .point(model: point),
            .subscription(model: subscription)
        ]
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
    
    func test_cell_delivery_delay() {
        var response = OrderStatusStub.getOrderStatusModel
        response.orderDetails?.delayStatusText = "Driver will delay a bit timer"
        sut = .init(response: response)
        // Progress Bar
        var progressBar = OrderStatusStub.progressBar
        progressBar.step = .second
        progressBar.hideTimeLabel = false
        
        // Location
        var location = OrderStatusStub.location
        location.type = .details
        
        // Point
        let point = OrderStatusStub.point
        
        // Subscription
        let subscription = OrderStatusStub.subscription
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: response.orderDetails?.delayStatusText ?? "")),
            .location(model: location),
            .point(model: point),
            .subscription(model: subscription)
        ]
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
}
