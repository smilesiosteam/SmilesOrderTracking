//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 07/12/2023.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

final class MoveMarker {
    
    var markerCar: GMSMarker?
    var mapView: GMSMapView!
    
    init(markerCar:GMSMarker?, mapView:GMSMapView) {
        self.markerCar = markerCar
        self.mapView = mapView
    }
    
    func rotateMarker(nextCoordinate :CLLocationCoordinate2D ){
        guard setCarMarker(currentCoor: nextCoordinate) else{return}
        guard let currentLat = markerCar?.position.latitude else{return}
        guard let currentLng = markerCar?.position.longitude else{return}
        
        let currentLocation = CLLocation(latitude:currentLat , longitude: currentLng)
        let nextLocation = CLLocation(latitude: nextCoordinate.latitude, longitude: nextCoordinate.longitude)
        
        let  angle = getBearingBetweenTwoPoints(point1: currentLocation, point2: nextLocation)
        
        let rotation = CGFloat(angle / 180 * Double.pi)
        
        UIView.animate(withDuration: 0.7) {
            self.markerCar!.iconView?.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
            self.mapView.animate(toViewingAngle: Double(rotation))
        }
        moveMrkerCar(nextCoordinate: nextCoordinate)
    }
    func setCarMarker(currentCoor:CLLocationCoordinate2D)->Bool{
        let currentLat = markerCar?.position.latitude
        let currentLng = markerCar?.position.longitude
        if let _ =  currentLat, let _ = currentLng{
            return true
        }else{
            let image = UIImage(named: "DriverPin", in: .module, with: nil)
            markerCar = mapView.markerView(lat: currentCoor.latitude  , lng: currentCoor.longitude, image: image!)
            return false
        }
    }
    
    private func moveMrkerCar(nextCoordinate :CLLocationCoordinate2D){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            self.markerCar?.position.latitude  = nextCoordinate.latitude
            self.markerCar?.position.longitude = nextCoordinate.longitude
            self.markerCar?.map = self.mapView
            
            self.markerCar?.appearAnimation = .pop
            CATransaction.commit()
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
}

extension GMSMapView {
    @discardableResult
    func markerView(lat: Double, lng: Double, image: UIImage, title: String = "") -> GMSMarker {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.iconView = UIImageView(image: image)
        marker.map = self
        return marker
    }
}
