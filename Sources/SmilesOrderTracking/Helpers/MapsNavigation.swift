//
//  File.swift
//
//
//  Created by Ahmed Naguib on 04/12/2023.
//

import UIKit
import MapKit

protocol MapsNavigationProtocol {
    func presentAlertForMaps(lat: Double, lang: Double, locationName: String)
}

extension MapsNavigationProtocol where Self: UIViewController {
    func presentAlertForMaps(lat: Double, lang: Double, locationName: String) {
        let alertController = UIAlertController(title: OrderTrackingLocalization.getDirectionsFrom.text, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: OrderTrackingLocalization.appleMaps.text, style: .default) { [weak self] _ in
               self?.openAppleMaps(lat: lat, lang: lang, locationName: locationName)
           })

        alertController.addAction(UIAlertAction(title: OrderTrackingLocalization.googleMaps.text, style: .default) { [weak self] _ in
                self?.openGoogleMaps(lat: lat, lang: lang, locationName: locationName)
           })

        alertController.addAction(UIAlertAction(title: OrderTrackingLocalization.cancelText.text, style: .cancel, handler: nil))

           present(alertController, animated: true, completion: nil)
       }
    
    func openGoogleMaps(lat: Double, lang: Double, locationName: String) {
        
        if let url = URL(string: "comgooglemaps://?q=\(lat),\(lang)&zoom=14&views=traffic") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Google Maps app is not installed, open in Safari
                let safariURL = URL(string: "https://www.google.com/maps?q=\(lat),\(lang)&zoom=14&views=traffic")!
                UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openAppleMaps(lat: Double, lang: Double, locationName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lang)
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        
        let launchOptions: [String : Any] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

}
