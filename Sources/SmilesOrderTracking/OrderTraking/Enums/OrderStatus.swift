//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation

public enum OrderStatus: Int {
    case orderReceived = 0
    case orderSubmitted = 1
    case restaurantAccepted = 2
    case preparingFood = 3
    case foodReady = 4
    case orderPickedUpForPickup = 5
    case outForDelivery = 6
    case delivered = 7
    case orderRejected = 8
    case changedToPickup = 9
    case pendingDeliveryConfirmation = 10
    case orderedCancel = 11
    case processingYourOrder = 12
    case orderPickedUpForDelivery = 13
    case orderNearYourLocation = 14
    case orderHasArrivedEarly = 15
}
