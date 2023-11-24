//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation

enum OrderTrackingType: Int {
    case orderProcessing = 0
    case waitingForTheRestaurant = 1
    case orderAccepted = 2
    case inTheKitchen = 3
    case orderIsReadyForPickup = 4
    case orderHasBeenPickedUp = 5
    case orderIsOnTheWay = 6
    case orderHasBeenDelivered = 7
    case orderCancelled = 8
    case changedToPickup = 9 // Delivery unavailable
    case determineStatus = 10
    case someItemsAreUnavailable = 11
    case orderNearYourLocation = 14
    case delivered = 15
}
