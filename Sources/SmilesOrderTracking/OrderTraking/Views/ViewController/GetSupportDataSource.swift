//
//  File.swift
//
//
//  Created by Shmeel Ahmad on 04/12/2023.
//

import UIKit

final class GetSupportDataSource: NSObject {
    
    
    // MARK: - Properties
    private var orderStatusModel = GetSupportModel()
    private let headerName = OrderConstans.headerName.rawValue
    private let viewModel: GetSupportViewModel
    weak var delegate: GetSupportViewDelegate?
   
    // MARK: - Init
    init(viewModel: GetSupportViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Functions
    func updateState(with model: GetSupportModel) {
        orderStatusModel = model
    }
    
}
// MARK: - DataSource
extension GetSupportDataSource: UICollectionViewDataSource {
    
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
        case .support(model: let model):
            let cell = collectionView.dequeueReusableCell(withClass: GetSupportCollectionViewCell.self, for: indexPath)
            cell.updateCell(with: model, delegate: self)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let type = orderStatusModel.header
        
        switch type {
        case .supportImageHeader(model: let model):
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: headerName, withClass: GetSupportImageHeaderCollectionViewCell.self, for: indexPath)
            header.updateCell(with: model)
            return header
        }
    }
}

// MARK: - Header Delegate
extension GetSupportDataSource: GetSupportCollectionViewCellActionDelegate {
    
    func didClick(_ model: GetSupportCollectionViewCell.ViewModel) {
        delegate?.performAction(model)
    }
}
