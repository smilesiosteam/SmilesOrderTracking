//
//  OrderHasBeenDeliveredConfigTests.swift
//
//
//  Created by Ahmed Naguib on 19/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class OrderHasBeenDeliveredConfigTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: OrderHasBeenDeliveredConfig!
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        sut = OrderHasBeenDeliveredConfig(response: OrderStatusStub.getOrderStatusModel)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Tests
    func test_header_mapHeader() {
        // Given
        let color = UIColor(red: 11, green: 68, blue: 18)
        let image = "Delivered"
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .image(imageName: image, backgroundColor: color))
        viewModel.isShowSupportHeader = true
        let header: TrackingHeaderType = .image(model: viewModel)
        // When
        let result = sut.build().header
        // Then
        XCTAssertEqual(result, header)
    }
    
    func test_cell_delivery_hasAllTypes() {
        // Progress Bar
        var progressBar = OrderStatusStub.progressBar
        progressBar.step = .completed
        progressBar.hideTimeLabel = true
        
        // Location
        var location = OrderStatusStub.location
        location.type = .details
        
        // Rate
        var rateModel = RatingCollectionViewCell.RateModel(type: .food)
        rateModel.title = "how was the food from Hardee's?"
        rateModel.iconUrl = "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg"
        var rate = RatingCollectionViewCell.ViewModel()
        rate.orderId = 466715
        rate.items = [rateModel]
        
        // Point
        let point = OrderStatusStub.point
        
        // Subscription
        let subscription = OrderStatusStub.subscription
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .location(model: location),
            .rating(model: rate),
            .point(model: point),
            .subscription(model: subscription)
        ]
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
    }
}
