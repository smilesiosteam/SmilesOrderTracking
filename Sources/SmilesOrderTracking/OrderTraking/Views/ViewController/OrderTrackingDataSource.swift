//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import UIKit

final class OrderTrackingDataSource: NSObject {
    
    // MARK: - Properties
    private var orderStatusModel = OrderTrackingModel()
    private let headerName = OrderConstans.headerName.rawValue
    private let viewModel: OrderTrackingViewModel
    weak var delegate: OrderTrackingViewDelegate?
    // MARK: - Init
    init(viewModel: OrderTrackingViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Functions
    func updateState(with model: OrderTrackingModel) {
        orderStatusModel = model
    }
    
}
// MARK: - DataSource
extension OrderTrackingDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderStatusModel.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = orderStatusModel.cells[indexPath.row]
        
        switch type {
        case .progressBar(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: OrderProgressCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        case .text(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: TextCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        case .location(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: LocationCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .restaurant(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: RestaurantCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        case .subscription(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: FreeDeliveryCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .point(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: PointsCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        case .driver(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: DriverCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .rating(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: RatingCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .confirmation(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: OrderConfirmationCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .orderActions(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: OrderCancelledCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .cashVoucher(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: CashCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        case .orderCancelled(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: OrderCancelledTimerCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let type = orderStatusModel.header
        
        switch type {
        case .image(model: let model):
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: headerName, withClass: ImageHeaderCollectionViewCell.self, for: indexPath)
            header.updateCell(with: model, delegate: self)
            return header
        case .map(model: let model):
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: headerName, withClass: MapHeaderCollectionViewCell.self, for: indexPath)
            header.updateCell(with: model, delegate: self)
            return header
        }
    }
}

// MARK: - Location Delegate
extension OrderTrackingDataSource: LocationCollectionViewProtocol {
    func didTappPhoneCall(with mobileNumber: String?) {
        print("didTappPhoneCall")
       
    }
    
    func didTappOrderDetails(orderId: String, restaurantId: String) {
        print("didTappOrderDetails")
        viewModel.orderNavigation(.orderDetails(orderId: orderId, restaurantId: restaurantId))
       
    }
    
    func didTappCancelDetails(orderId: String) {
        delegate?.presentCancelFlow(orderId: orderId)
    }
}

// MARK: - Header Delegate
extension OrderTrackingDataSource: HeaderCollectionViewProtocol {
    func didTappDismiss() {
        delegate?.dismiss()
    }
    
    func didTappSupport() {
        
    }
}

// MARK: - Subscription Delegate
extension OrderTrackingDataSource: FreeDeliveryCollectionViewProtocol {
    func didTappSubscribeNow() {
        print("didTappSubscribeNow")
    }
}

// MARK: - Driver Delegate
extension OrderTrackingDataSource: DriverCellActionDelegate {
    func opneMap(lat: Double, lng: Double) {
        
    }
}

// MARK: - Rating Delegate
extension OrderTrackingDataSource: RatingCellActionDelegate {
    func rateOrderDidTap(orderId: Int) {
        print("rateOrderDidTap")
    }
    
    func rateDeliveryDidTap(orderId: Int) {
        print("rateDeliveryDidTap")
        delegate?.presentRateFlow()
    }
}
// MARK: - Confirmation Delegate
extension OrderTrackingDataSource: OrderConfirmationCellActionDelegate {
    func didGetTheOrder(with orderId: Int) {
//        viewModel.fetchOrderStatus(status: OrderTrackingType.orderHasBeenPickedUpPickup.rawValue)
        
    }
    
    func didNotGetTheOrder(with orderId: Int) {
        print("No")
    }
}
// MARK: - Canceled order Delegate
extension OrderTrackingDataSource: OrderCancelledTimerCellActionDelegate {
    func likeToPickupOrderDidTap() {
        print("likeToPickupOrderDidTap")
    }
}
