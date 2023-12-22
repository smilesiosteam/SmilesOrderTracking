//
//  GetSupportViewController.swift
//
//
//  Created by Shmeel on 4/11/2023.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager
import Combine
import GoogleMaps
import SmilesLoader

protocol GetSupportViewDelegate: AnyObject {
    func performAction(_:GetSupportCollectionViewCell.ViewModel)
}


public final class GetSupportViewController: UIViewController, Toastable, GetSupportViewDelegate {
    func performAction(_ model: GetSupportCollectionViewCell.ViewModel) {
        switch model.type {
        case .callRestaurant:
            makePhoneCall(phoneNumber: model.order?.restaurentNumber ?? "")
        case .callChampion:
            makePhoneCall(phoneNumber: model.order?.partnerNumber ?? "")
        case .openFAQ:
            viewModel.navigationDelegate?.navigateToFAQs()
        case .liveChat:
            viewModel?.getLiveChatUrl()
        }
    }
    
    @IBAction func back(_ sender:Any) {
        self.navigationController?.popViewController()
    }
    
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = OrderTrackingLocalization.getSupport.text
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    var viewModel: GetSupportViewModel!
    private lazy var dataSource = GetSupportDataSource(viewModel: viewModel)
    
    private lazy var collectionViewDataSource = OrderTrackingLayout()
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        bindStatus()
        viewModel.fetchStatus()
        dataSource.delegate = self
    }
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK: - Functions
    private func configCollectionView() {
        [
         TextCollectionViewCell.self,
         OrderProgressCollectionViewCell.self,
         GetSupportCollectionViewCell.self
        ].forEach({
            collectionView.register(
                UINib(nibName: String(describing: $0.self), bundle: .module),
                forCellWithReuseIdentifier: String(describing: $0.self))
        })
        
        [GetSupportImageHeaderCollectionViewCell.self].forEach({
            collectionView.register(
                UINib(nibName: String(describing: "\($0.self)"), bundle: .module),
                forSupplementaryViewOfKind: OrderConstans.headerName.rawValue,
                withReuseIdentifier: String(describing: $0.self))
        })
        
        collectionView.collectionViewLayout = collectionViewDataSource.createLayout()
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
            case .success(let model):
                self.dataSource.updateState(with: model)
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel?.$liveChatUrl.sink { [weak self] value in
            guard let self, let value else { return }
            viewModel.navigationDelegate?.navigateToLiveChatWebview(url: value)
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
extension GetSupportViewController {
    static public func create() -> GetSupportViewController {
        let viewController = GetSupportViewController(nibName: String(describing: GetSupportViewController.self), bundle: .module)
        return viewController
    }
}
