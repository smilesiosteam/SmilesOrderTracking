////
////  File.swift
////  
////
////  Created by Muhammad Shayan Zahid on 20/11/2023.
////
//
//import Foundation
//import Firebase
//
//protocol FirebaseDatabaseManagerDelegate {
//    func orderStatusDidChange(with orderId: String, orderNumber: String, orderStatus: OrderTrackingType, comingFromFirebase: Bool)
//    func liveLocationDidUpdate(with latitude: Double, longitude: Double)
//}
//
//struct FirebaseDatabaseManager {
//    private var liveOrderDatabaseReference: DatabaseReference?
//    private var driverLocationDatabaseReference: DatabaseReference?
//    
//    var delegate: FirebaseDatabaseManagerDelegate?
//    
//    mutating func fetchLiveOrderUpdates(for orderNumber: String) {
//        // Retrieve a previous created named app.
//        guard let secondary = FirebaseApp.app(name: "secondary") else {
//            assert(false, "Could not retrieve secondary app")
//            return
//        }
//        
//        // Retrieve a Real Time Database client configured against a specific app.
//        let secondaryDb = Database.database(app: secondary)
//        liveOrderDatabaseReference = secondaryDb.reference(fromURL:  "https://delivery-app-api.firebaseio.com/order_status/\(orderNumber)")
//        
//        liveOrderDatabaseReference?.observe(.value) { [self] snapshot in
//            if snapshot.exists() {
//                if let order = snapshot.value as? [String: Any] {
//                    if let orderNumber = order["order_number"] as? String, let orderId = order["id"] as? Int, let orderStatus = order["order_status"] as? Int {
//                        delegate?.orderStatusDidChange(with: "\(orderId)", orderNumber: orderNumber, orderStatus: OrderTrackingType(rawValue: orderStatus) ?? .orderProcessing, comingFromFirebase: true)
//                    }
//                }
//            }
//        }
//    }
//    
//    mutating func fetchLiveLocationUpdates(for liveTrackingId: String) {
//        // Retrieve a previous created named app.
//        guard let secondary = FirebaseApp.app(name: "secondary") else {
//            assert(false, "Could not retrieve secondary app")
//            return
//        }
//        
//        // Retrieve a Real Time Database client configured against a specific app.
//        let secondaryDb = Database.database(app: secondary)
//        driverLocationDatabaseReference = secondaryDb.reference(fromURL: "https://delivery-app-api.firebaseio.com/driver_loc/\(liveTrackingId)")
//        
//        var placeDict = [String : Any]()
//        driverLocationDatabaseReference?.observe(.value) { [self] snapshot in
//            if snapshot.exists() {
//                for child in snapshot.children {
//                    if let snap = child as? DataSnapshot {
//                        if snap.exists() {
//                            placeDict[snap.key] = snap.value
//                        }
//                    }
//                }
//                
//                if let latitude =  placeDict["latitude"] as? Double, let longitude = placeDict["longitude"] as? Double {
//                    delegate?.liveLocationDidUpdate(with: latitude, longitude: longitude)
//                }
//            }
//        }
//    }
//    
//    func removeLiveOrderUpdates() {
//        liveOrderDatabaseReference?.removeAllObservers()
//        driverLocationDatabaseReference?.removeAllObservers()
//    }
//}
