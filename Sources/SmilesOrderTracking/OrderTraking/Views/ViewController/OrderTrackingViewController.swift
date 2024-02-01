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
import SmilesScratchHandler

protocol OrderTrackingViewDelegate: AnyObject {
    func presentConfirmationPickup(location: String, didTappedContinue: (()-> Void)?)
    func presentRateFlow(orderId: String, type: String)
    func dismiss()
    func phoneCall(with number: String)
    func openMaps(lat: Double, lng: Double, placeName: String)
    func timerIs(on: Bool)
    func getSupport()
    func pauseAnimation()
}

extension OrderTrackingViewController: OrderTrackingViewDelegate {
    func getSupport() {
        let dependence = GetSupportDependance(orderId: viewModel.orderId, orderNumber: viewModel.orderNumber, chatbotType: viewModel.chatbotType)
        let supportViewController = TrackOrderConfigurator.getOrderSupportView(dependance: dependence, navigationDelegate: viewModel.navigationDelegate)
        self.navigationController?.pushViewController(viewController: supportViewController)
    }
    
    func presentCancelFlow(orderId: String) {
        let vc = ConfirmationPopupViewController(
            popupData: ConfirmationPopupViewModelData(
                showCloseButton: false,
                message: OrderTrackingLocalization.wantCancelOrder.text,
                descriptionMessage: OrderTrackingLocalization.cancelOrderDescription.text,
                primaryButtonTitle: OrderTrackingLocalization.dontCancel.text,
                secondaryButtonTitle:OrderTrackingLocalization.yesCancel.text,
                primaryAction: { [weak self] in
                    self?.cancelOrderInput.send(.resumeOrder(ordeId: "\(orderId)"))
                },
                secondaryAction:{ [weak self] in
                    self?.cancelOrderInput.send(.cancelOrder(ordeId: "\(orderId)", reason: nil))
                }
            )
        )
        
      
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        present(vc, animated: true, completion: nil)
    }
    
    func presentRateFlow(orderId: String, type: String) {
        let uiModel = OrderRatingUIModel(ratingType: type, contentType: "tracking", isLiveTracking: viewModel.isLiveTracking, orderId: orderId, chatbotType: viewModel.chatbotType)
        let model = OrderRatingViewModel(orderRatingUIModel: uiModel)
        let viewController = OrderRatingViewController.create(with: model, delegate: self)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController)
    }
    
    func dismiss() {
        viewModel.navigationDelegate?.closeTracking()
        if isCameFromMyOrder {
            self.dismissMe()
        } else {
            viewModel.navigationDelegate?.popToViewRestaurantDetailVC()
        }
    }
    
    func presentConfirmationPickup(location: String, didTappedContinue: (()-> Void)?) {
        let viewController = TrackOrderConfigurator.getConfirmationPopup(locationText: location, didTappedContinue: didTappedContinue)
        present(viewController)
    }
    
    func phoneCall(with number: String) {
        makePhoneCall(phoneNumber: number)
    }
    
    func openMaps(lat: Double, lng: Double, placeName: String) {
        presentAlertForMaps(lat: lat, lang: lng, locationName: placeName)
    }
    
    func timerIs(on: Bool) {
        timerIsOn = on
    }
    
    func pauseAnimation() {
        processAnimation(stop: true)
    }
}

extension OrderTrackingViewController: OrderRatingViewDelegate {
    func shouldOpenItemRatingViewController(with model: RateOrderResponse, orderItems: [OrderItemDetail]) {
        let itemRatingUIModel = ItemRatingUIModel(itemWiseRatingEnabled: model.itemLevelRatingEnable ?? false, isAccrualPointsAllowed: model.isAccrualPointsAllowed ?? false, orderItems: orderItems, ratingOrderResponse: model)
        let itemRatingViewModel = ItemRatingViewModel(itemRatingUIModel: itemRatingUIModel)
        let itemRatingViewController = ItemRatingViewController.create(with: itemRatingViewModel, delegate: self)
        itemRatingViewController.modalPresentationStyle = .overFullScreen
        
        self.present(itemRatingViewController)
    }
    
    func shouldOpenFeedbackSuccessViewController(with model: RateOrderResponse) {
        let ratingOrderResult = model.ratingOrderResult
        let feedBackSuccessUIModel = FeedbackSuccessUIModel(popupTitle: ratingOrderResult?.title ?? "", description: ratingOrderResult?.description ?? "", boldText: ratingOrderResult?.accrualTitle ?? "")
        let feedBackSuccessViewModel = FeedbackSuccessViewModel(feedBackSuccessUIModel: feedBackSuccessUIModel)
        let feedBackSuccessViewController = FeedbackSuccessViewController.create(with: feedBackSuccessViewModel)
        feedBackSuccessViewController.delegate = self
        feedBackSuccessViewController.modalPresentationStyle = .overFullScreen
        
        self.present(feedBackSuccessViewController)
    }
    
    func shouldOpenGetSupport(with url: String) {
        viewModel.navigationDelegate?.navigateToLiveChatWebview(url: url)
    }
    
    func ratingDidComplete() {
        viewModel.fetchStatus()
    }
}

public final class OrderTrackingViewController: UIViewController, Toastable, MapsNavigationProtocol {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    private let cancelOrderviewModel = SmilesOrderCancelledViewModel()
    private let cancelOrderInput: PassthroughSubject<SmilesOrderCancelledViewModel.Input, Never> = .init()
    private lazy var dataSource = OrderTrackingDataSource(viewModel: viewModel)
    private var floatingView: FloatingView!
    private var timerIsOn = false
    private var isAnimationPlay = true
    private lazy var collectionViewDataSource = OrderTrackingLayout()
    private var isNoLiveTrackingToastPresented = false
    private var isOrderAcceptedToastPresented = false
    var isHeaderVisible = true
    var lastContentOffset: CGFloat = 0
    var viewModel: OrderTrackingViewModel!
    var isCameFromMyOrder = false
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        dataSource.delegate = self
        bindCancelFlow()
        bindStatus()
        viewModel.setPersonalizationEventSource()
        if viewModel.checkForVoucher {
            viewModel.setupScratchAndWin(orderId: viewModel.orderId, isVoucherScratched: false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFloatingView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if !timerIsOn {
            viewModel.fetchStatus()
        }
        
        if isBeingDismissed {
            viewModel.navigationDelegate?.closeTracking()
        }
        
        viewModel.navigationDelegate?.fireSuccessfulOrderCompletionEvent()
        viewModel.navigationDelegate?.fireOrderTrackingEvent()
        processAnimation(stop: false)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideFloatingView()
        
        processAnimation(stop: true)
    }
    
    @objc private func applicationDidBecomeActive(notification: NSNotification) {
        if !timerIsOn {
            viewModel.fetchStatus()
        }
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
                    self?.processAnimation(stop: true)
                    break
                case .resumeOrderDidSucceed:
                    //resume animations
                    self?.processAnimation(stop: false)
                    //MARK: -- Failure cases
                case .cancelOrderDidFail(let error):
                    self?.showErrorMessage(message: error.localizedDescription)
                case .pauseOrderDidFail(let error):
                    self?.showErrorMessage(message: error.localizedDescription)
                case .resumeOrderDidFail(let error):
                    self?.showErrorMessage(message: error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
    
    private func navigateToThanksForFeedback() {
        let vc = SuccessMessagePopupViewController(popupData:
                                                    SuccessPopupViewModelData(message:OrderTrackingLocalization.thankyouForFeedback.text, descriptionMessage: OrderTrackingLocalization.alwaysWrokingToImprove.text,
                                                                              primaryButtonTitle: OrderTrackingLocalization.backToHome.text, primaryAction: { [weak self] in
            self?.viewModel.navigationDelegate?.closeTracking()
            self?.viewModel.navigationDelegate?.popToViewRestaurantDetailVC()
            
        }))
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc)
    }
    
    private func navigateToOrderCancelledScreen(response:OrderCancelResponse){
        let vc = SmilesOrderCancelledViewController.init(orderId: viewModel.orderId, orderNumber: viewModel.orderNumber, chatbotType: viewModel.chatbotType, cancelResponse: response, delegate: viewModel.navigationDelegate, onSubmitSuccess: { [weak self]feedBacksubmittedResponse in
            if feedBacksubmittedResponse.status == 204 {
                self?.navigateToThanksForFeedback()
            }else{
                self?.viewModel.navigationDelegate?.closeTracking()
                self?.viewModel.navigationDelegate?.popToViewRestaurantDetailVC()
            }
        })
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.didTapDismiss = { [weak self] in
            guard let self else {
                return
            }
            self.viewModel.navigationDelegate?.popToViewRestaurantDetailVC()
            
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
        
        collectionView.collectionViewLayout = collectionViewDataSource.createLayout()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
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
                self.showErrorMessage(message: message)
                
            case .showToastForArrivedOrder(let isShow):
                if isShow, !self.isOrderAcceptedToastPresented {
                    self.isOrderAcceptedToastPresented = true
                    self.showToastForOrderArrived()
                }
            case .showToastForNoLiveTracking(let isLiveTracking):
                if !isLiveTracking, !self.isNoLiveTrackingToastPresented {
                    isNoLiveTrackingToastPresented = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.presentToastForNoTracking()
                    }
                }
            case .success(let model):
                self.dataSource.updateState(with: model)
                self.collectionView.reloadData()
            case .timerIsOff:
                self.timerIsOn = false
            case .presentScratchAndWin(let response):
                self.presentScratchAndWinVC(response: response)
                
            case .presentCancelFlow(orderId: let orderId):
                self.presentCancelFlow(orderId: orderId)
            case .driverLocation(lat: let lat, long: let long):
                let headerMap = self.getMapHeader()
                headerMap?.moveDriverOnMap(lat: lat, long: long)
            case .navigateToGetSupport:
                self.getSupport()
            case .showErrorAndPop(message: let message):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.showAlertWithOkayOnly(message: message) { [weak self] _ in
                        self?.dismiss()
                    }
                }
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
    
    private func showErrorMessage(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showAlertWithOkayOnly(message: message)
        }
        if !isAnimationPlay {
            processAnimation(stop: false)
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
    
    private func processAnimation(stop: Bool) {
        guard let collectionView = collectionView else {
            return
        }
        isAnimationPlay = !stop
        
        // Process the animation for progress bar
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? OrderProgressCollectionViewCell {
            if stop == false {
                collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                collectionView.reloadData()
            } else {
                cell.processAnimation()
            }
        }
        // Process the animation for header view
        let headerView = getImageHeader()
        headerView?.processAnimation(stop: stop)
        stop ? self.viewModel.pauseTimer() : self.viewModel.resumeTimer()
    }
    
    private func getImageHeader() -> ImageHeaderCollectionViewCell? {
        guard let indexPath = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: OrderConstans.headerName.rawValue).first,
              let headerView = collectionView.supplementaryView(forElementKind: OrderConstans.headerName.rawValue, at: indexPath) as? ImageHeaderCollectionViewCell else {
            return nil
        }
        return headerView
    }
    
    private func getMapHeader() -> MapHeaderCollectionViewCell? {
        guard let indexPath = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: OrderConstans.headerName.rawValue).first,
              let headerView = collectionView.supplementaryView(forElementKind: OrderConstans.headerName.rawValue, at: indexPath) as? MapHeaderCollectionViewCell else {
            return nil
        }
        return headerView
    }
    
    private func configHeaderButtons(isHidden: Bool) {
        let mapHeader = getMapHeader()
        let imageHeader = getImageHeader()
        mapHeader?.configHeader(isHidden: isHidden)
        imageHeader?.configHeader(isHidden: isHidden)
    }
    
    
    // MARK: - Floating view
    // Show and hide the view in the top when scroll collection view
    private func setupFloatingView() {
        floatingView = FloatingView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        floatingView.backgroundColor = .white
        floatingView.alpha = 0
        view.addSubview(floatingView)
        
        floatingView.didLeadingButton = { [weak self] in
            self?.dismiss()
        }
        
        floatingView.didTrailingButton = { [weak self] in
            self?.getSupport()
        }
    }
    
    private func showFloatingView() {
        configHeaderButtons(isHidden: true)
        if floatingView.alpha == 0 {
            UIView.animate(withDuration: 0.3) { self.floatingView.alpha = 1 }
            DispatchQueue.main.async {
                self.animateHeaderVisibility(show: false)
                self.topConstraint.constant = 120
            }
        }
    }
    
    private func hideFloatingView() {
        configHeaderButtons(isHidden: false)
        if floatingView.alpha == 1 {
            UIView.animate(withDuration: 0.3) { self.floatingView.alpha = 0 }
            DispatchQueue.main.async {
                self.animateHeaderVisibility(show: true)
                self.topConstraint.constant = 0
            }
            
        }
    }
    
    private func presentScratchAndWinVC(response: ScratchAndWinResponse) {
        
        let scratchVC = SmilesScratchViewController(scratchObj: response, orderId: viewModel.orderId)
        scratchVC.modalPresentationStyle = .overCurrentContext
        scratchVC.modalTransitionStyle = .crossDissolve
        scratchVC.delegate = self
        present(scratchVC)
        
    }
    
}

// MARK: - UICollectionViewDelegate
extension OrderTrackingViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrollOffset = scrollView.contentOffset.y
        
        // Adjust the threshold value based on your specific needs
        let threshold: CGFloat = 10
        
        // Check the scrolling direction
        if scrollOffset > threshold {
            showFloatingView()
        } else {
            
            hideFloatingView()
        }
    }
    
    private func animateHeaderVisibility(show: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.collectionViewDataSource.isShowHeader = show
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        collectionView.performBatchUpdates({
            animator.startAnimation()
        }, completion: { _ in })
    }
}

// MARK: - Create
extension OrderTrackingViewController {
    static public func create() -> OrderTrackingViewController {
        let viewController = OrderTrackingViewController(nibName: String(describing: OrderTrackingViewController.self), bundle: .module)
        return viewController
    }
}

// MARK: - ScratchAndWinDelegate
extension OrderTrackingViewController: ScratchAndWinDelegate {
    
    public func viewVoucherPressed(voucherCode: String) {
        viewModel.navigationDelegate?.navigateToVouchersRevamp(voucherCode: voucherCode)
    }
    
    public func proceedToOfferDetails(offerId: String, offerType: String) {
        viewModel.navigationDelegate?.navigateToOfferDetails(offerId: offerId, offerType: offerType)
    }
    
}
