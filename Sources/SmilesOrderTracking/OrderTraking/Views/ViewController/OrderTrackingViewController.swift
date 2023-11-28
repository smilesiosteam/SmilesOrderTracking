//
//  OrderTrackingViewController.swift
//
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager
import Combine
import GoogleMaps

protocol OrderTrackingViewDelegate: AnyObject {
    func presentCancelFlow(orderId: Int)
    func presentRateFlow()
}

extension OrderTrackingViewController: OrderTrackingViewDelegate {
    func presentCancelFlow(orderId: Int) {
        print("presentCancelFlow")
    }
    
    func presentRateFlow() {
        print("presentRateFlow")
    }
}

public final class OrderTrackingViewController: UIViewController, Toastable {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = OrderTrackingViewModel()
    private lazy var dataSource = OrderTrackingDataSource(viewModel: viewModel)
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionView()
        viewModel.load()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource.updateState(with: viewModel.orderStatusModel)
        collectionView.reloadData()
        bindData()
        
    }
    
    private func bindData() {
        viewModel.$isShowToast.sink { [weak self] value in
            if value  {
                let icon = UIImage(resource: .sucess)
                var model = ToastModel()
                model.title =  OrderTrackingLocalization.orderAccepted.text
                model.imageIcon = icon
                self?.showToast(model: model)
            }
        }.store(in: &cancellables)
    }
    
    // MARK: - Functions
    private func configCollectionView() {
        [RestaurantCollectionViewCell.self,
         CashCollectionViewCell.self,
         OrderCancelledCollectionViewCell.self,
         PointsCollectionViewCell.self,
         LocationCollectionViewCell.self,
         OrderConfirmationCollectionViewCell.self,
         TextCollectionViewCell.self,
         DriverCollectionViewCell.self,
         OrderProgressCollectionViewCell.self,
         RatingCollectionViewCell.self,
         RestaurantCancelCollectionViewCell.self,
         FreeDeliveryCollectionViewCell.self,
         OrderCancelledTimerCollectionViewCell.self,
        ].forEach({
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forCellWithReuseIdentifier: String(describing: $0.self))
        })
        
        [ImageHeaderCollectionViewCell.self, MapHeaderCollectionViewCell.self].forEach({
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forSupplementaryViewOfKind: OrderConstans.headerName.rawValue,
                withReuseIdentifier: String(describing: $0.self))
        })
        
        collectionView.collectionViewLayout = OrderTrackingLayout.createLayout()
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - Create
extension OrderTrackingViewController {
    static public func create() -> OrderTrackingViewController {
        let viewController = OrderTrackingViewController(nibName: String(describing: OrderTrackingViewController.self), bundle: .module)
        return viewController
    }
}




//    func updateMapWithLocation(newLocation: CLLocation) {
//        // Assuming you have a reference to the MapHeaderCell
//        let indexPath = IndexPath(item: 0, section: 0)
//        let headerView = collectionView?.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath)
//        print(headerView)
//
//        if let mapHeaderCell = getFirstMapHeader() {
//            let camera = GMSCameraPosition.camera(withTarget: newLocation.coordinate, zoom: 15.0)
//            mapHeaderCell.mapView.camera = camera
//
//            // Remove existing markers if any
//            mapHeaderCell.mapView.clear()
//
//            // Add a new marker for the updated location
//            let marker = GMSMarker(position: newLocation.coordinate)
//            marker.title = "New Location"
//            marker.map = mapHeaderCell.mapView
//        }
//    }

//    func getNewLocationFromAPI() {
//
//            // Assume you get a new location (CLLocation) from your API
//            let newLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
//            updateMapWithLocation(newLocation: newLocation)
//        }
//
//    func getFirstMapHeader() -> MapHeaderCollectionViewCell? {
//        guard let collectionView = collectionView else {
//            return nil
//        }
//
//        // Iterate through visible supplementary views
//        for indexPath in collectionView.indexPathsForVisibleSupplementaryElements(ofKind: OrderConstans.headerName.rawValue) {
//            if let headerView = collectionView.supplementaryView(forElementKind: OrderConstans.headerName.rawValue, at: indexPath) as? MapHeaderCollectionViewCell {
//                // Found the first MapHeaderCollectionViewCell
//                return headerView
//            }
//        }
//
//        // If no MapHeaderCollectionViewCell is found
//        return nil
//    }
