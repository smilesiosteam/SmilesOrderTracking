//
//  MapHeaderCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 16/11/2023.
//

import UIKit
import GoogleMaps
import Combine
import LottieAnimationManager
import Lottie
import SmilesUtilities
final class MapHeaderCollectionViewCell: UICollectionReusableView {
    
    // MARK: - Outlets
    @IBOutlet private weak var driverImage: UIImageView!
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var animationView: UIView!
    @IBOutlet private weak var supportButton: UIButton!
    @IBOutlet private weak var headerStack: UIStackView!
    
    // MARK: - Properties
    private weak var delegate: HeaderCollectionViewProtocol?
    private var isFirstTimeSetCamera = false
    private var moveMarker: MoveMarker?
    private var driverMarker :GMSMarker?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMap()
        configControllers()
        moveMarker = MoveMarker(markerCar: driverMarker, mapView: mapView)
    }
    
    // MARK: - Buttons Actions
    @IBAction private func dismissButtonTapped(_ sender: Any) {
        delegate?.didTappDismiss()
    }
    
    @IBAction private func supportButtonTapped(_ sender: Any) {
        delegate?.didTappSupport()
    }
    
    // MARK: - Functions
    func updateCell(with viewModel: ViewModel, delegate: HeaderCollectionViewProtocol) {
        self.delegate = delegate
        configCellType(type: viewModel.type)
        let startPoint = CLLocationCoordinate2D(latitude: viewModel.startPoint.lat, longitude: viewModel.startPoint.lang)
        let endPoint = CLLocationCoordinate2D(latitude: viewModel.endPoint.lat, longitude: viewModel.endPoint.lang)
        addBoundForMap(startPoint: startPoint, endPoint: endPoint)
        
        mapView.addMarker(model: viewModel.startPoint)
        mapView.addMarker(model: viewModel.endPoint)
    }
    
    func configHeader(isHidden: Bool) {
        headerStack.isHidden = isHidden
    }
    
    private func configCellType(type: CellType) {
        animationLottieView?.removeFromSuperview()
        switch type {
        case .image(let imageName):
            animationView.backgroundColor = .clear
            driverImage.image = UIImage(named: imageName, in: .module, with: nil)
            driverImage.isHidden = false
        case .animation(let url):
            driverImage.isHidden = true
            animationView.isHidden = false
            if let url {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: url, animationBackgroundView: animationView, removeFromSuper: false, loopMode: .loop,contentMode: .scaleAspectFill) { _ in }
            }
        }
    }
    
    private var animationLottieView: LottieAnimationView? {
        animationView.subviews.first(where: { $0 is LottieAnimationView }) as?  LottieAnimationView
    }
    
    private func configControllers() {
        driverImage.layer.cornerRadius = 50
        animationView.layer.cornerRadius = 50
        animationView.layer.borderWidth = 5
        animationView.layer.borderColor = UIColor.white.cgColor
        supportButton.layer.cornerRadius = 20
        supportButton.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        supportButton.addShadowToSelf(
            offset: CGSize(width: 0, height: 2),
            color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.12),
            radius: 8.0,
            opacity: 1)
        [supportButton].forEach({
            $0.fontTextStyle = .smilesTitle1
            $0.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        })
    }
    
    private func setupMap() {
        mapView.isUserInteractionEnabled = false
        if let styleURL = Bundle.main.url(forResource: "MapsStyling", withExtension: "json"),
           let mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL) {
            mapView.mapStyle = mapStyle
        }
    }
    
    private func addBoundForMap(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) {
        let path = GMSMutablePath()
        path.add(startPoint)
        path.add(endPoint)
        
        let bounds = GMSCoordinateBounds(path: path)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.3))) {
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
        }
    }
    
    func moveDriverOnMap(lat: Double, long: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14)
        if !isFirstTimeSetCamera {
//            mapView?.animate(to: camera)
            isFirstTimeSetCamera = true
        }
        moveMarker?.rotateMarker(nextCoordinate: coordinate)
    }
}

extension MapHeaderCollectionViewCell {
    
    struct ViewModel: Equatable {
        var startPoint: MarkerModel
        var endPoint: MarkerModel
        var type: CellType
    }
    
    enum CellType: Equatable {
        case image(imageName: String)
        case animation(url: URL?)
    }
}
