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
    
    // MARK: - Init
    init(orderStatusModel: OrderTrackingModel = OrderTrackingModel()) {
        self.orderStatusModel = orderStatusModel
    }
    
    // MARK: - Functions
    func updateState(with model: OrderTrackingModel) {
        orderStatusModel = model
    }
    
}
// MARK: - DataSource
extension OrderTrackingDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderStatusModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = orderStatusModel.items[indexPath.row]
        
        switch type {
        case .progressBar(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: OrderProgressCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        case .text(message: let message):
            let cell = collectionView.dequeueReusableCell(withClass: TextCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: message)
            return cell
        case .location(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: LocationCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        case .restaurant(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: RestaurantCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let type = orderStatusModel.header
        
        switch type {
        case .image(model: let model):
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: headerName, withClass: ImageHeaderCollectionViewCell.self, for: indexPath)
            header.updateCell(with: model)
            return header
        case .map(model: let model):
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: headerName, withClass: MapHeaderCollectionViewCell.self, for: indexPath)
            header.updateCell(with: model)
            return header
        }
    }
}


extension OrderTrackingDataSource: LocationCollectionViewProtocol {
    
}
