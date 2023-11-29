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
import SmilesLoader

public class SmilesOrderCancelledViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

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
    var supportAction: ()->Void = {}
    var dismissViewTranslation = CGPoint(x: 0, y: 0)
    
    private let viewModel = SmilesOrderCancelledViewModel()
    private let input: PassthroughSubject<SmilesOrderCancelledViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    var cancelResponse:OrderCancelResponse!
    var orderId:String!
    var orderNumber:String!
    
    var rejectionReasons : [String] = []
    
    @IBOutlet weak var textView: UITextView!
    // MARK: Lifecycle

    fileprivate func setupUI() {
        self.rejectionReasons = cancelResponse.rejectionReasons ?? []
        panDismissView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        panDismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        messageText.text = "Your order has been cancelled".localizedString
        descriptionMessage.text = "Please let us know why you need to cancel your order".localizedString
        messageText.fontTextStyle = .smilesHeadline2
        descriptionMessage.fontTextStyle = .smilesBody2
        
        primaryButton.setTitle("SubmitTitleSmall".localizedString, for: .normal)
        secondaryButton.setTitle("GetSupport".localizedString, for: .normal)
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
    }
    
    func bind(to viewModel: SmilesOrderCancelledViewModel) {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                SmilesLoader.dismiss()
                switch event {
                // MARK: -- Success cases
                case .cancelOrderDidSucceed(let response):
                    self?.onSubmitSuccess(response)
                case .pauseOrderDidSucceed:
                    break
                case .resumeOrderDidSucceed:
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
    
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.reasonsCollectionView.collectionViewLayout = flowLayout
        
        self.reasonsCollectionView.register(UINib(nibName: String(describing: ReasonCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: ReasonCollectionViewCell.self))
        reasonsCollectionView.allowsMultipleSelection = true
        let rows = Int(rejectionReasons.count)/2 + (rejectionReasons.count)%2
        let spacings = CGFloat(max(rows-1,0)*10)
        collectionHeight.constant = min(500,max(100,CGFloat(rows*40)-spacings))
    }
    
    func setBtnUI(enabled:Bool){
        primaryButton.isUserInteractionEnabled = enabled
        primaryButton.titleLabel?.textColor = enabled ? .white : UIColor(white: 0, alpha: 0.5)
        primaryButton.backgroundColor = enabled ? .appRevampPurpleMainColor : UIColor(white: 0, alpha: 0.1)
    }
    
    public init(orderId:String, orderNumber:String, cancelResponse:OrderCancelResponse, onSubmitSuccess: @escaping (_:OrderCancelResponse)->Void = {}, supportAction: @escaping ()->Void = {}) {
        self.onSubmitSuccess = onSubmitSuccess
        self.supportAction = supportAction
        self.cancelResponse = cancelResponse
        self.orderId = orderId
        self.orderNumber = orderNumber
        super.init(nibName: "SmilesOrderCancelledViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            dismissViewTranslation = sender.translation(in: view)
            if dismissViewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.dismissViewTranslation.y)
                })
            }
        case .ended:
            if dismissViewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            }
            else {
                dismiss(animated: true)
            }
        default:
            break
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        dismiss(animated: true)
        
        let reason = textViewContainer.isHidden ? reasonsCollectionView.indexPathsForSelectedItems?.compactMap { self.rejectionReasons[$0.item] }.joined(separator: ",") : textView.text
        SmilesLoader.show()
        self.input.send(.cancelOrder(ordeId: self.orderId, reason: reason))
    }
    
    @IBAction func secondaryAction(_ sender: Any) {
        dismiss(animated: true)
        supportAction()
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
        if ((rejectionReasons[safe: indexPath.row] ?? "").lowercased().contains("other")){
            reasonsCollectionView.isHidden = true
            textViewContainer.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            textViewContainer.becomeFirstResponder()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        setBtnUI(enabled: (collectionView.indexPathsForSelectedItems?.count ?? 0) > 0)
    }

}

extension SmilesOrderCancelledViewController {
    
//    func showCancelledPopup(vc: OrderCancelledFeedbackViewController) {
//        var items = [CustomizableActionSheetItem]()
//        let sampleViewItem = CustomizableActionSheetItem(type: .view, height: 332)
//        sampleViewItem.view = vc.view
//        items.append(sampleViewItem)
//        
//        let actionSheet = CustomizableActionSheet()
//        actionSheet.tag = cartActionSheetTag.changeToPickup.rawValue
//        actionSheet.defaultCornerRadius = 12
//        actionSheet.shouldDismiss = false
//        self.actionSheet = actionSheet
//        
//        actionSheet.showInView(view, items: items)
//    }
    
}
