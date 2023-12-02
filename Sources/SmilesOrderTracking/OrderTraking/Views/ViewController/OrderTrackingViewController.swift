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
import SmilesLoader

protocol OrderTrackingViewDelegate: AnyObject {
    func presentCancelFlow(orderId: String)
    func presentRateFlow()
    func dismiss()
}

extension OrderTrackingViewController: OrderTrackingViewDelegate {
    func presentCancelFlow(orderId: String) {
        let vc = ConfirmationPopupViewController(
            popupData: ConfirmationPopupViewModelData(
                showCloseButton: false,
                message: OrderTrackingLocalization.wantCancelOrder.text,
                descriptionMessage: OrderTrackingLocalization.cancelOrderDescription.text,
                primaryButtonTitle: OrderTrackingLocalization.dontCancel.text,
                secondaryButtonTitle:OrderTrackingLocalization.yesCancel.text,
                primaryAction: {
                    self.cancelOrderInput.send(.resumeOrder(ordeId: "\(orderId)"))
                },
                secondaryAction:{
                    self.cancelOrderInput.send(.cancelOrder(ordeId: "\(orderId)", reason: nil))
                }
            )
        )
        self.present(vc)
    }
    
    func presentRateFlow() {
        let uiModel = OrderRatingUIModel(ratingType: "food", contentType: "tracking", isLiveTracking: true, orderId: "466832")
        let serviceHandler = OrderTrackingServiceHandler()
        let model = OrderRatingViewModel(orderRatingUIModel: uiModel, serviceHandler: serviceHandler)
        let viewController = OrderRatingViewController.create(with: model, delegate: self)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController)
    }
    
    func dismiss() {
        self.dismissMe()
    }
}

extension OrderTrackingViewController: OrderRatingViewDelegate {
    func shouldOpenItemRatingViewController(with model: RateOrderResponse, orderItems: [OrderItemDetail]) {
        let itemRatingUIModel = ItemRatingUIModel(itemWiseRatingEnabled: model.itemLevelRatingEnable ?? false, isAccrualPointsAllowed: model.isAccrualPointsAllowed ?? false, orderItems: orderItems, ratingOrderResponse: model)
        let itemRatingViewModel = ItemRatingViewModel(itemRatingUIModel: itemRatingUIModel, serviceHandler: viewModel.serviceHandler)
        let itemRatingViewController = ItemRatingViewController.create(with: itemRatingViewModel, delegate: self)
        itemRatingViewController.modalPresentationStyle = .overFullScreen
        
        self.present(itemRatingViewController)
    }
    
    func shouldOpenFeedbackSuccessViewController(with model: RateOrderResponse) {
        let ratingOrderResult = model.ratingOrderResult
        let feedBackSuccessUIModel = FeedbackSuccessUIModel(popupTitle: ratingOrderResult?.title ?? "", description: ratingOrderResult?.description ?? "", boldText: ratingOrderResult?.accrualTitle ?? "")
        let feedBackSuccessViewModel = FeedbackSuccessViewModel(feedBackSuccessUIModel: feedBackSuccessUIModel)
        let feedBackSuccessViewController = FeedbackSuccessViewController.create(with: feedBackSuccessViewModel)
        feedBackSuccessViewController.modalPresentationStyle = .overFullScreen
        
        self.present(feedBackSuccessViewController)
    }
}

public final class OrderTrackingViewController: UIViewController, Toastable {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var cancellables: Set<AnyCancellable> = []
    private let cancelOrderviewModel = SmilesOrderCancelledViewModel()
    private let cancelOrderInput: PassthroughSubject<SmilesOrderCancelledViewModel.Input, Never> = .init()
    var viewModel: OrderTrackingViewModel!
    private lazy var dataSource = OrderTrackingDataSource(viewModel: viewModel)
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        dataSource.delegate = self
        bindCancelFlow()
        bindStatus()
        viewModel.fetchStatus(with: nil)
    }
    
    private func bindCancelFlow() {
        cancelOrderviewModel.transform(input: cancelOrderInput.eraseToAnyPublisher())
            .sink { [weak self] event in
                switch event {
                // MARK: -- Success cases
                case .cancelOrderDidSucceed(let response):
                    self?.navigateToOrderCancelledScreen(response: response)
                case .pauseOrderDidSucceed:
                    //puase animations
                    break
                case .resumeOrderDidSucceed:
                    //resume animations
                    break
                //MARK: -- Failure cases
                case .cancelOrderDidFail(let error):
                    debugPrint(error)
                case .pauseOrderDidFail(let error):
                    debugPrint(error)
                case .resumeOrderDidFail(let error):
                    debugPrint(error)
                }
            }.store(in: &cancellables)
    }
    

    private func navigateToThanksForFeedback(response:OrderCancelResponse) {
        let vc = SuccessMessagePopupViewController(popupData: SuccessPopupViewModelData(message: response.title ?? "", descriptionMessage: response.description ?? "", primaryButtonTitle: "Back to home".localizedString, primaryAction: {
            // TODO: - for ahmed move to food home
        }))
        self.present(vc)
    }
    
    private func navigateToOrderCancelledScreen(response:OrderCancelResponse){
        // TODO: - for ahmed pass order id and number
        let vc = SmilesOrderCancelledViewController.init(orderId: "", orderNumber: "", cancelResponse: response, onSubmitSuccess: {feedBacksubmittedResponse in
            if feedBacksubmittedResponse.status == 204 {
                self.navigateToThanksForFeedback(response: feedBacksubmittedResponse)
            }else{
                // TODO: - for ahmed: move to restaurant details vc
//                self.router?.popToViewRestaurantDetailVC()
            }
        }) {
            //support
        }
        self.present(vc)
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
    
    private func bindStatus() {
        viewModel.orderStatusPublisher.sink { [weak self] states in
            guard let self else {
                return
            }
            switch states {
            case .showLoader:
                SmilesLoader.show(isClearBackground: false)
            case .hideLoader:
                SmilesLoader.dismiss()
            case .showError(let message):
                self.showAlertWithOkayOnly(message: message)
            case .showToastForArrivedOrder(let isShow):
                if isShow {
                    self.showToastForOrderArrived()
                }
            case .showToastForNoLiveTracking(let isShow):
                if isShow {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.presentToastForNoTracking()
                    }
                }
            case .success(let model):
                self.dataSource.updateState(with: model)
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
    private func showToastForOrderArrived() {
        let icon = UIImage(resource: .sucess)
        let model = ToastModel()
        model.title = OrderTrackingLocalization.orderAccepted.text
        model.imageIcon = icon
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showToast(model: model)
        }
    }
    
    private func presentToastForNoTracking() {
        let model = ToastModel()
        let text = OrderTrackingLocalization.liveTrackingAvailable.text
        let dismiss = OrderTrackingLocalization.dismiss.text
        
        let attributedString = NSMutableAttributedString(string: "\(text) \(dismiss)")
        let textRange = NSRange(location: 0, length: text.count)
        
        let textFont = SmilesFontsManager.defaultAppFont.getFont(style: .medium, size: 14)
        attributedString.addAttribute(.font, value: textFont, range: textRange)

        let dismissRange = NSRange(location: text.count + 1, length: dismiss.count)
        let dismissFont = SmilesFontsManager.defaultAppFont.getFont(style: .medium, size: 16)
        attributedString.addAttribute(.font, value: dismissFont, range: dismissRange)

        model.attributedString = attributedString
        
        let toastView = showToast(model: model)
        model.viewDidTapped = {
            toastView.removeFromSuperview()
        }
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
