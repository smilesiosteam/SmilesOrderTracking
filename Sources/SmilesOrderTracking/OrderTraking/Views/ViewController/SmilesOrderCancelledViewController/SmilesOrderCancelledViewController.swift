//
//  SmilesOrderCancelledViewController.swift
//  
//
//  Created by Shmeel Ahmed on 20/11/2023.
//

import UIKit
import SmilesUtilities
import LottieAnimationManager
import Combine
import SmilesLanguageManager

public class SmilesOrderCancelledViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            let imageName = SmilesLanguageManager.shared.isRightToLeft ? "RightbackArrow" : "leftbackArrow"
            let image = UIImage(named: imageName, in: .module, with: nil)
            backButton.setImage(image, for: .normal)
        }
    }
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var reasonsCollectionView: UICollectionView!
    @IBOutlet weak var animationView: UIImageView!
    @IBOutlet weak var popupTitleContainer: UIView!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet var panDismissView: UIView!
    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var descriptionMessage: UILabel!
    var onSubmitSuccess: (_:OrderCancelResponse)->Void = {resonse in}
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    
    private let viewModel = SmilesOrderCancelledViewModel()
    private let input: PassthroughSubject<SmilesOrderCancelledViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    var navigationDelegate: OrderTrackingNavigationProtocol?
    var cancelResponse:OrderCancelResponse!
    var orderId:String!
    var orderNumber:String!
    
    var rejectionReasons : [String] = []
    
    @IBOutlet weak var textView: UITextView!
    // MARK: Lifecycle
    
    @Published var isVisibleTextView = false
    
    var didTapDismiss: (()-> Void)?
    fileprivate func setupUI() {
        self.rejectionReasons = cancelResponse.rejectionReasons ?? []
        messageText.text = OrderTrackingLocalization.yourOrderCancelled.text
        descriptionMessage.text = OrderTrackingLocalization.whyCancel.text
        messageText.fontTextStyle = .smilesHeadline2
        descriptionMessage.fontTextStyle = .smilesBody2
        
        primaryButton.setTitle(OrderTrackingLocalization.submit.text, for: .normal)
        secondaryButton.setTitle(OrderTrackingLocalization.getSupport.text, for: .normal)
        primaryButton.fontTextStyle = .smilesHeadline4
        secondaryButton.fontTextStyle = .smilesHeadline4
        secondaryButton.layer.borderWidth = 2
        secondaryButton.layer.borderColor = UIColor.appRevampPurpleMainColor.withAlphaComponent(0.4).cgColor
        roundedView.layer.cornerRadius = 12
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalPresentationStyle = .overFullScreen
        setupCollectionView()
        textViewContainer.layer.borderWidth = 1
        textViewContainer.layer.borderColor = UIColor.appRevampPurpleMainColor.cgColor
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(to: viewModel)
        backButton.isHidden = true
        bindShowBackButton()
        setBtnUI(enabled: false)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        primaryButton.fontTextStyle = .smilesHeadline4
        secondaryButton.fontTextStyle = .smilesHeadline4
        
        primaryButton.titleLabel?.textColor = .white
        primaryButton.backgroundColor = .appRevampPurpleMainColor
        secondaryButton.titleLabel?.textColor = .appRevampPurpleMainColor
    }
    
    private func bindShowBackButton() {
        $isVisibleTextView.sink { [weak self] show in
            if show {
                self?.reasonsCollectionView.isHidden = true
                self?.showTextView()
            } else {
                self?.textViewContainer.isHidden = true
                self?.showCollectionView()
            }
        }.store(in: &cancellables)
    }
    func bind(to viewModel: SmilesOrderCancelledViewModel) {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                // MARK: -- Success cases
                case .cancelOrderDidSucceed(let response):
                    self?.onSubmitSuccess(response)
                case .pauseOrderDidSucceed:
                    break
                case .resumeOrderDidSucceed:
                    break
                //MARK: -- Failure cases
                case .cancelOrderDidFail(_):
                    self?.didTapDismiss?()
                    self?.dismiss(animated: true)
                case .pauseOrderDidFail(let error):
                    debugPrint(error)
                case .resumeOrderDidFail(let error):
                    debugPrint(error)
                }
            }.store(in: &cancellables)
        
        viewModel.$liveChatUrl.sink {value in
            guard let value else { return }
            self.dismiss {
                self.navigationDelegate?.navigateToLiveChatWebview(url: value)
            }
        }.store(in: &cancellables)
    }
    
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.reasonsCollectionView.collectionViewLayout = flowLayout
        
        self.reasonsCollectionView.register(UINib(nibName: String(describing: ReasonCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: ReasonCollectionViewCell.self))
        reasonsCollectionView.allowsMultipleSelection = true
        let rows = (rejectionReasons.count / 2) + (rejectionReasons.count % 2)
        let spacings =  CGFloat((rows - 1) * 10)
        collectionHeight.constant =  CGFloat((rows * 40)) + spacings
    }
    
    func setBtnUI(enabled:Bool){
        primaryButton.isUserInteractionEnabled = enabled
        primaryButton.titleLabel?.textColor = enabled ? .white : UIColor(white: 0, alpha: 0.5)
        primaryButton.backgroundColor = enabled ? .appRevampPurpleMainColor : UIColor(white: 0, alpha: 0.1)
    }
    
    public init(orderId:String, 
                orderNumber:String,
                chatbotType:String,
                cancelResponse: OrderCancelResponse,
                delegate:OrderTrackingNavigationProtocol?,
                onSubmitSuccess: @escaping (_:OrderCancelResponse)->Void = {_ in }) {
        self.onSubmitSuccess = onSubmitSuccess
        self.cancelResponse = cancelResponse
        self.orderId = orderId
        self.orderNumber = orderNumber
        self.viewModel.orderId = orderId
        self.viewModel.orderNumber = orderNumber
        self.viewModel.chatbotType = chatbotType
        self.navigationDelegate = delegate
        super.init(nibName: "SmilesOrderCancelledViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }


    @IBAction func closePressed(_ sender: Any) {
        didTapDismiss?()
        dismiss(animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        isVisibleTextView = false
    }
    @IBAction func primaryAction(_ sender: Any) {
        dismiss(animated: true)
        
        let reason = textViewContainer.isHidden ? reasonsCollectionView.indexPathsForSelectedItems?.compactMap { self.rejectionReasons[$0.item] }.joined(separator: ",") : textView.text
        self.input.send(.cancelOrder(ordeId: self.orderId, reason: reason))
    }
    
    @IBAction func secondaryAction(_ sender: Any) {
        self.viewModel.getLiveChatUrl()
    }
}

extension SmilesOrderCancelledViewController: UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rejectionReasons.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReasonCollectionViewCell", for: indexPath) as? ReasonCollectionViewCell {
            cell.titleLabel.text = rejectionReasons[indexPath.item]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        label.text = rejectionReasons[indexPath.row]
        label.sizeToFit()
        
        return CGSize(width: (collectionView.frame.width - 10)/2.0, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setBtnUI(enabled: (collectionView.indexPathsForSelectedItems?.count ?? 0) > 0)
        if ((rejectionReasons[safe: indexPath.row] ?? "").lowercased().contains("other")
            || (rejectionReasons[safe: indexPath.row] ?? "").lowercased().contains("أخرى")){
            isVisibleTextView = true
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    private func showCollectionView() {
        reasonsCollectionView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        backButton.isHidden = true
    }
    
    private func showTextView() {
        textViewContainer.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        textViewContainer.becomeFirstResponder()
        backButton.isHidden = false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        setBtnUI(enabled: (collectionView.indexPathsForSelectedItems?.count ?? 0) > 0)
    }

}
