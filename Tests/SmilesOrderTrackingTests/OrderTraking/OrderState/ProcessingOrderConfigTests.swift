//
//  ProcessingOrderConfigTests.swift
//
//
//  Created by Ahmed Naguib on 18/12/2023.
//

import XCTest
@testable import SmilesOrderTracking

final class ProcessingOrderConfigTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: ProcessingOrderConfig!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        let response = OrderStatusStub.getOrderStatusModel
        sut = ProcessingOrderConfig(response: response)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Tests
    func test_OrderTrackingCellTypeNaming() {
        XCTAssertEqual(OrderTrackingCellType.delivery.rawValue, "DELIVERY")
        XCTAssertEqual(OrderTrackingCellType.pickup.rawValue, "PICK_UP")
    }
    
    func test_header_animationHeader() {
        
        // Given
        let response = OrderStatusStub.getOrderStatusModel
        let url = URL(string: response.orderDetails?.largeImageAnimationUrl ?? "")
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .animation(url: url, backgroundColor: response.orderDetails?.trackingColorCode ?? ""))
        viewModel.isShowSupportHeader = false
        let header: TrackingHeaderType = .image(model: viewModel)
        // When
        let result = sut.build().header
        // Then
        XCTAssertEqual(result, header)
    }
    
    func test_cells_withNoDelay() {
        // Given
        var response = OrderStatusStub.getOrderStatusModel
        response.orderDetails?.isCancelationAllowed = true
        sut = ProcessingOrderConfig(response: response)
        let orderDetails = response.orderDetails
        
        // Progress Bar
        let title = orderDetails?.title
        var progressBar: OrderProgressCollectionViewCell.ViewModel = .init()
        progressBar.title = title
        progressBar.step = .first
        progressBar.hideTimeLabel = true
        progressBar.time = orderDetails?.deliveryTimeRangeText
        
        // Text
        let text = orderDetails?.orderDescription
        
        // Location
        var location = LocationCollectionViewCell.ViewModel()
        location.startAddress = orderDetails?.restaurantAddress
        location.endAddress = orderDetails?.deliveryAdrress
        location.restaurantNumber = orderDetails?.restaurentNumber
        location.orderId = "466715"
        location.restaurantId = "17338"
        location.type = .showCancelButton
        
        // Restaurant
        var restaurant: RestaurantCollectionViewCell.ViewModel = .init()
        restaurant.name = response.orderDetails?.restaurantName
        restaurant.iconUrl = response.orderDetails?.iconUrl
        restaurant.items = """
        1 x Quattro Box
        4 x Dummy Box
        10 x Beef
        18 x Burger
        """
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: text)),
            .location(model: location),
            .restaurant(model: restaurant)
        ]
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
    
    func test_cells_withHasDelay() {
        // Given
        var response = OrderStatusStub.getOrderStatusModel
        response.orderDetails?.isCancelationAllowed = false
        response.orderDetails?.delayStatusText = "The driver will delay a bit"
        sut = ProcessingOrderConfig(response: response)
        let orderDetails = response.orderDetails
        
        // Progress Bar
        let title = orderDetails?.title
        var progressBar: OrderProgressCollectionViewCell.ViewModel = .init()
        progressBar.title = title
        progressBar.step = .first
        progressBar.hideTimeLabel = true
        progressBar.time = orderDetails?.deliveryTimeRangeText
        
        // Text
        let text = orderDetails?.delayStatusText
        
        // Location
        var location = LocationCollectionViewCell.ViewModel()
        location.startAddress = orderDetails?.restaurantAddress
        location.endAddress = orderDetails?.deliveryAdrress
        location.restaurantNumber = orderDetails?.restaurentNumber
        location.orderId = "466715"
        location.restaurantId = "17338"
        location.type = .details
        
        // Restaurant
        var restaurant: RestaurantCollectionViewCell.ViewModel = .init()
        restaurant.name = response.orderDetails?.restaurantName
        restaurant.iconUrl = response.orderDetails?.iconUrl
        restaurant.items = """
        1 x Quattro Box
        4 x Dummy Box
        10 x Beef
        18 x Burger
        """
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: text)),
            .location(model: location),
            .restaurant(model: restaurant)
        ]
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
}
