//
//  ChangedToPickupOrderConfigTests.swift
//  
//
//  Created by Ahmed Naguib on 21/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class ChangedToPickupOrderConfigTests: XCTestCase {

    // MARK: - Properties
    private var sut: ChangedToPickupOrderConfig!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        sut = .init(response: OrderStatusStub.getOrderStatusModel)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_cells() {
        // Given
        let response = OrderStatusStub.getOrderStatusModel
        let text = OrderStatusStub.text
        // Canceled Order
        var canceled = OrderCancelledTimerCollectionViewCell.ViewModel()
        canceled.buttonTitle = OrderTrackingLocalization.orderCancelledLikeToPickupOrder.text
        canceled.title = response.orderDetails?.orderDescription ?? ""
        let orderId = response.orderDetails?.orderId ?? 0
        canceled.orderId = "\(orderId)"
        canceled.orderNumber = response.orderDetails?.orderNumber ?? ""
        let timeOut = response.orderDetails?.changeTypeTimer ?? 0
        canceled.timerCount = timeOut
        canceled.restaurantAddress = response.orderDetails?.restaurantAddress ?? ""
        // Actions
        let action = OrderStatusStub.orderAction
        let cells: [TrackingCellType] = [
            .text(model: text),
            .orderCancelled(model: canceled),
            .orderActions(model: action)
        ]
        // When
        let result = sut.build().cells
        // Then
        XCTAssertEqual(result, cells)
    }
    
    func test_header() {
        
        // Given
        let color = UIColor(red: 74, green: 9, blue: 0)
        let image = "Cancelled"
        var viewModel = ImageHeaderCollectionViewCell.ViewModel(type: .image(imageName: image, backgroundColor: color))
        viewModel.isShowSupportHeader = true
        let header: TrackingHeaderType = .image(model: viewModel)
        // When
        let result = sut.build().header
        // Then
        XCTAssertEqual(result, header)
    }
}
