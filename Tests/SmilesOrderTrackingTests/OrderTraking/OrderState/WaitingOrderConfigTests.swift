//
//  WaitingOrderConfigTests.swift
//
//
//  Created by Ahmed Naguib on 19/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class WaitingOrderConfigTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: WaitingOrderConfig!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        let response = OrderStatusStub.getOrderStatusModel
        sut = WaitingOrderConfig(response: response)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Tests
    func test_header_animationHeader() {
        // Given
        let response = OrderStatusStub.getOrderStatusModel
        let url = URL(string: response.orderDetails?.largeImageAnimationUrl ?? "")
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .animation(url: url, backgroundColor: response.orderDetails?.trackingColorCode ?? ""))
        viewModel.isShowSupportHeader = true
        let header: TrackingHeaderType = .image(model: viewModel)
        // When
        let result = sut.build().header
        // Then
        XCTAssertEqual(result, header)
    }
    
    func test_cell_hasAllCells() {
        // Given
        let response = OrderStatusStub.getOrderStatusModel
        sut = WaitingOrderConfig(response: response)
        let orderDetails = response.orderDetails
        
        // Progress Bar
        let title = orderDetails?.title
        var progressBar: OrderProgressCollectionViewCell.ViewModel = .init()
        progressBar.title = title
        progressBar.step = .first
        progressBar.hideTimeLabel = true
        progressBar.time = orderDetails?.deliveryTimeRangeText
        
        // Location
        var location = LocationCollectionViewCell.ViewModel()
        location.startAddress = orderDetails?.restaurantAddress
        location.endAddress = orderDetails?.deliveryAdrress
        location.restaurantNumber = orderDetails?.restaurentNumber
        location.orderId = "466715"
        location.restaurantId = "17338"
        location.type = .details
        
        // Points
        let point = response.orderDetails?.earnPoints ?? 0
        var pointModel = PointsCollectionViewCell.ViewModel()
        pointModel.numberOfPoints = point
        pointModel.text = response.orderDetails?.earnPointsText
        
        // Subscription
           
        let bannerImageUrl = response.orderDetails?.subscriptionBannerV2?.bannerImageUrl ?? ""
        var subscriptionModel = FreeDeliveryCollectionViewCell.ViewModel()
        subscriptionModel.imageURL = bannerImageUrl
        subscriptionModel.redirectUrl = response.orderDetails?.subscriptionBannerV2?.redirectionUrl ?? ""
        
        let cells: [TrackingCellType] = [
            .progressBar(model: progressBar),
            .text(model: .init(title: orderDetails?.orderDescription ?? "")),
            .location(model: location),
            .point(model: pointModel),
            .subscription(model: subscriptionModel)
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
        sut = WaitingOrderConfig(response: response)
        let orderDetails = response.orderDetails
        
        // Progress Bar
        let title = orderDetails?.title
        var progressBar: OrderProgressCollectionViewCell.ViewModel = .init()
        progressBar.title = title
        progressBar.step = .first
        progressBar.hideTimeLabel = true
        progressBar.time = orderDetails?.deliveryTimeRangeText
        
        // Location
        var location = LocationCollectionViewCell.ViewModel()
        location.startAddress = orderDetails?.restaurantAddress
        location.endAddress = orderDetails?.deliveryAdrress
        location.restaurantNumber = orderDetails?.restaurentNumber
        location.orderId = "466715"
        location.restaurantId = "17338"
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
}
