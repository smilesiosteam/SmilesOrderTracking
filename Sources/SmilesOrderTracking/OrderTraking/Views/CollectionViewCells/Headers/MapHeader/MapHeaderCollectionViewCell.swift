//
//  MapHeaderCollectionViewCell.swift
//
//
//  Created by Ahmed Naguib on 16/11/2023.
//

import UIKit
import GoogleMaps
import Combine

final class MapHeaderCollectionViewCell: UICollectionReusableView {
    
    // MARK: - Outlets
    @IBOutlet private weak var driverImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var supportButton: UIButton!
    
    // MARK: - Properties
    private weak var delegate: HeaderCollectionViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMap()
        configControllers()
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
        
        let startPoint = CLLocationCoordinate2D(latitude: viewModel.startPoint.lat, longitude: viewModel.startPoint.lang)
        let endPoint = CLLocationCoordinate2D(latitude: viewModel.endPoint.lat, longitude: viewModel.endPoint.lang)
        addBoundForMap(startPoint: startPoint, endPoint: endPoint)
        
        mapView.addMarker(model: viewModel.startPoint)
        mapView.addMarker(model: viewModel.endPoint)
        
    }
    
    private func configControllers() {
        dismissButton.layer.cornerRadius = 20
        supportButton.layer.cornerRadius = 20
        driverImage.layer.cornerRadius = 50
        driverImage.backgroundColor = .red
        driverImage.layer.borderWidth = 4
        driverImage.layer.borderColor = UIColor.white.cgColor
        supportButton.setTitle(OrderTrackingLocalization.support.text, for: .normal)
        [supportButton, dismissButton].forEach({
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
}

extension MapHeaderCollectionViewCell {
    
    struct ViewModel {
        var startPoint: MarkerModel
        var endPoint: MarkerModel
        var userImageURL: String
    }
}
