//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 27/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

final public class ItemRatingViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 12.0)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], cornerRadius: 12.0)
            doneButton.setTitle(OrderTrackingLocalization.done.text, for: .normal)
            doneButton.setTitleColor(.white, for: .normal)
            doneButton.backgroundColor = .appPurpleColor1
            doneButton.fontTextStyle = .smilesTitle1
        }
    }
    
    // MARK: - Properties
    var viewModel: ItemRatingViewModel?
    var dataSource: ItemRatingDataSource?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
        if let viewModel {
            dataSource = ItemRatingDataSource(viewModel: viewModel)
        }
        dataSource?.delegate = self
        setupCollectionView()
    }
    
    // MARK: - Actions
    @IBAction private func doneButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Methods
    private func setupCollectionView() {
        [
            FoodRatingSuccessCollectionViewCell.self,
            ItemRatingTitleCollectionViewCell.self,
            ItemRatingCollectionViewCell.self
        ].forEach {
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forCellWithReuseIdentifier: String(describing: $0.self))
        }
        collectionView.dataSource = dataSource
        if let dataSource {
            collectionView.collectionViewLayout = dataSource.createCollectionViewLayout()
        }
    }
}

// MARK: - Create
extension ItemRatingViewController {
    static func create(with viewModel: ItemRatingViewModel) -> ItemRatingViewController {
        let viewController = ItemRatingViewController(nibName: String(describing: ItemRatingViewController.self), bundle: .module)
        return viewController
    }
}

// MARK: - ItemRatingDataSourceDelegate
extension ItemRatingViewController: ItemRatingDataSourceDelegate {
    func collectionViewShouldReload() {
//        collectionView.reloadData()
    }
}
