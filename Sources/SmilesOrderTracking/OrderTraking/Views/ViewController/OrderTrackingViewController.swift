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
public final class OrderTrackingViewController: UIViewController {
    
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
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        dataSource.updateState(with: viewModel.orderStatusModel)
//        collectionView.reloadData()
    }
    
    private func bindData() {
        viewModel.$isShowToast.sink { [weak self] value in
            if value  {
                let icon = UIImage(resource: .sucess)
                self?.showToast(message: OrderTrackingLocalization.orderAccepted.text, icon: icon)
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


final class ToastView: UIView {
    private let iconImageView = UIImageView()
    private let messageLabel = UILabel()

    init(message: String, icon: UIImage? = nil) {
        super.init(frame: CGRect.zero)

        configureView()
        configureIconImageView(icon: icon)
        configureMessageLabel(message: message)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 10
        clipsToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureIconImageView(icon: UIImage?) {
        iconImageView.image = icon
        iconImageView.contentMode = .scaleAspectFit

        addSubview(iconImageView)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func configureMessageLabel(message: String) {
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.fontTextStyle = .smilesHeadline5
        addSubview(messageLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 2),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

extension UIViewController {
    func showToast(message: String, icon: UIImage? = nil) {
        let toastView = ToastView(message: message, icon: icon)

        view.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastView.heightAnchor.constraint(equalToConstant: 50)
        ])

        UIView.animate(withDuration: 0.3, delay: 10.0, options: .curveEaseOut, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
}

