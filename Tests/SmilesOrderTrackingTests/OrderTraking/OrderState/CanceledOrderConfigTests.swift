//
//  CanceledOrderConfigTests.swift
//  
//
//  Created by Ahmed Naguib on 21/12/2023.
//

import XCTest
import SmilesTests
@testable import SmilesOrderTracking

final class CanceledOrderConfigTests: XCTestCase {
    // MARK: - Properties
    private var sut: CanceledOrderConfig!
    
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
        // Cancel
        var cancelledModel = OrderStatusStub.cancelModel
        cancelledModel.buttonTitle = OrderTrackingLocalization.restaurantCanceledButtonTitle.text
        cancelledModel.type = .cancelled
        
        // Text
        let text = OrderStatusStub.text
        
        // Cash Voucher
        let cashVoucher = OrderStatusStub.cashVoucher
        
        // Actions
        let action = OrderStatusStub.orderAction
        let cells: [TrackingCellType] = [
            .text(model: text),
            .orderCancelled(model: cancelledModel),
            .cashVoucher(model: cashVoucher),
            .orderActions(model: action)
        ]
        
        // When
        let result = sut.build()
        // Then
        XCTAssertEqual(result.cells, cells)
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
