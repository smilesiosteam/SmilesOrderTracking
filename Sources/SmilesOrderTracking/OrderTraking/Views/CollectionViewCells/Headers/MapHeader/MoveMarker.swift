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
    private var pulseAnimation: CAAnimation?
    
    init(markerCar: GMSMarker?, mapView: GMSMapView) {
        self.markerCar = markerCar
        self.mapView = mapView
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        resumeAnimation()
    }
    
    deinit {
        pauseAnimation()
    }
    
    @objc private func didEnterBackground() {
        pauseAnimation()
    }
    
    @objc private func didEnterForeground() {
        resumeAnimation()
    }
    
    func rotateMarker(nextCoordinate: CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D?) {
        guard setCarMarker(currentCoor: nextCoordinate) else { return }
        
        moveRiderMarker(nextCoordinate: nextCoordinate, destinationCoordinates: destinationCoordinates)
    }
    
    func setCarMarker(currentCoor: CLLocationCoordinate2D) -> Bool {
        let currentLat = markerCar?.position.latitude
        let currentLng = markerCar?.position.longitude
        if let _ = currentLat, let _ = currentLng {
            return true
        } else {
            if let image = UIImage(named: "DriverPin", in: .module, with: nil) {
                markerCar = mapView.markerView(lat: currentCoor.latitude, lng: currentCoor.longitude, image: image)
            }
            
            return false
        }
    }
    
    private func moveRiderMarker(nextCoordinate: CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            self.markerCar?.position.latitude  = nextCoordinate.latitude
            self.markerCar?.position.longitude = nextCoordinate.longitude
            self.markerCar?.map = self.mapView
            self.markerCar?.zIndex = 1
            
            self.markerCar?.appearAnimation = .pop
            
            if let destinationCoordinates {
                let riderLocation = CLLocation(latitude: nextCoordinate.latitude, longitude: nextCoordinate.longitude)
                let destinationLocation = CLLocation(latitude: destinationCoordinates.latitude, longitude: destinationCoordinates.longitude)
                if riderLocation.distance(from: destinationLocation) < 20.0 {
                    self.pulseAnimation(on: self.markerCar?.iconView ?? UIView(), fromSize: 1.0, toSize: 0.1, duration: 1.2)
                }
            }
            
            CATransaction.commit()
        }
    }
    
    private func pulseAnimation(on view: UIView, fromSize: CGFloat, toSize: CGFloat, duration: Double) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = fromSize
        pulseAnimation.toValue = toSize
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        
        view.layer.add(pulseAnimation, forKey: "riderAnimation")
    }
    
    private func pauseAnimation() {
        pulseAnimation = markerCar?.iconView?.layer.animation(forKey: "riderAnimation")
        markerCar?.iconView?.layer.pauseLayer()
    }
    
    private func resumeAnimation() {
        if let pulseAnimation {
            markerCar?.iconView?.layer.add(pulseAnimation, forKey: "riderAnimation")
            markerCar?.iconView?.layer.resumeLayer()
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(point1: CLLocation, point2: CLLocation) -> Double {
        
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
