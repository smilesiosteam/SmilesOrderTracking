//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 22/11/2023.
//

import Foundation
import GoogleMaps

extension GMSMapView {
    func addMarker(model: MarkerModel) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: model.lat, longitude: model.lang)
        marker.title = model.title
        marker.snippet = model.title
        marker.icon = UIImage(named: model.image, in: .module, with: nil)
        marker.map = self
    }
    
    func setCamera(model: MarkerModel, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: model.lat, longitude: model.lang, zoom: zoom)
        self.camera = camera
    }
}

struct MarkerModel: Equatable {
    let lat: Double
    let lang: Double
    var title: String? = nil
    var image: String = ""
}
