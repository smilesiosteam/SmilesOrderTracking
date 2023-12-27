//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation
import SmilesUtilities

enum OrderTrackingLocalization: CaseIterable {
    case support
    case callRestaurant
    case orderDetails
    case cancelOrder
    case pickUpYourOrderFrom
    case restaurantCancelledOrder
    case viewAvailableRestaurants
    case pendingDeliveryConfirmation
    case yesTitle
    case noTitle
    case haveYouReceivedOrderFrom
    case orderCancelledTimeFinished
    case orderCancelledLikeToPickupOrder
    case minText
    case orderAccepted
    case submit
    case facedTroubleWithYourOrder
    case getSupport
    case done
    case okay
    case didReceivedOrder
    case didPickedOrder
    case restaurantCanceledButtonTitle
    case pickUpOrderFrom
    case liveTrackingAvailable
    case dismiss
    case unavailableItemsButtonTitle
    case yourOrderCancelled
    case whyCancel
    case thankyouForFeedback
    case alwaysWrokingToImprove
    case backToHome
    case wantCancelOrder
    case cancelOrderDescription
    case dontCancel
    case yesCancel
    case describeYourExperience
    // Pickup Confirmation
    case confirmOrderPickup
    case refundInfo
    case continueText
    case cancelText
    case googleMaps
    case appleMaps
    case getDirectionsFrom
    case yourExperience
    var text: String {
        switch self {
        case .googleMaps:
            return "GoogleMaps".localizedString
        case .appleMaps:
            return "AppleMaps".localizedString
        case .getDirectionsFrom:
            return "GetDirectionsFrom".localizedString
        case .support:
            return "Support".localizedString
        case .callRestaurant:
            return "Call restaurant".localizedString
        case .orderDetails:
            return "Order details".localizedString
        case .cancelOrder:
            return "CancelOrder".localizedString
        case .pickUpYourOrderFrom:
            return "PickUpOrder".localizedString
        case .restaurantCancelledOrder:
            return "RestaurantCancelledOrder".localizedString
        case .viewAvailableRestaurants:
            return "ViewAvailableRestaurant".localizedString
        case .pendingDeliveryConfirmation:
            return "Pending delivery confirmation".localizedString
        case .yesTitle:
            return "Yes".localizedString
        case .noTitle:
            return "No".localizedString
        case .haveYouReceivedOrderFrom:
            return "Have you received".localizedString

        case .orderCancelledTimeFinished:
            return "OrderCancelledTimeFinished".localizedString
        case .orderCancelledLikeToPickupOrder:
            return "OrderCancelledLikeToPickupOrder".localizedString
        case .minText:
            return "MinTitle".localizedString
        case .orderAccepted:
            return "OrderAccepted".localizedString
        case .submit:
            return "SubmitTitleSmall".localizedString
        case .facedTroubleWithYourOrder:
            return "Faced trouble with your order?".localizedString
        case .getSupport:
            return "GetSupport".localizedString
        case .done:
            return "Done".localizedString
        case .okay:
            return "Okay".localizedString
        case .didPickedOrder:
            return "DidPicked".localizedString
        case .didReceivedOrder:
            return "DidReceived".localizedString
        case .restaurantCanceledButtonTitle:
            return "ViewAvailableRestaurant".localizedString
        case .pickUpOrderFrom:
            return "Pick up your order from".localizedString
        case .unavailableItemsButtonTitle:
            return "ContinueNewOrder".localizedString
        case .liveTrackingAvailable:
            return "LiveTrackingAvailable".localizedString
        case .dismiss:
            return "Dismiss".localizedString
        case .yourOrderCancelled:
            return "Your order has been cancelled".localizedString
        case .whyCancel:
            return "Please let us know why you need to cancel your order".localizedString
        case .thankyouForFeedback:
            return "Thank you for sending your feedback".localizedString
        case .alwaysWrokingToImprove:
            return "always_working_to_improve".localizedString
        case .backToHome:
            return "Back to home".localizedString.capitalizingFirstLetter()
        case .wantCancelOrder:
            return "Cancel order?".localizedString
        case .cancelOrderDescription:
            return "CancelOrderDescription".localizedString
        case .dontCancel:
            return "Don't cancel".localizedString
        case .yesCancel:
            return "Yes cancel".localizedString
        case .describeYourExperience:
            return "Describe your experience (optional)".localizedString
        case .confirmOrderPickup:
            return "ConfirmOrderPickup".localizedString
        case .refundInfo:
            return "RefundInfo".localizedString
        case .continueText:
            return "ContinueText".localizedString
        case .cancelText:
            return "CancelText".localizedString
        case .yourExperience:
            return "yourExperience".localizedString
        }
    }
}
