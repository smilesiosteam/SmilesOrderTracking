//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 14/11/2023.
//

import Foundation
import SmilesUtilities

enum OrderTrackingLocalization {
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
    var text: String {
        switch self {
        case .googleMaps:
            return "GoogleMaps".localizedString
        case .appleMaps:
            return "AppleMaps".localizedString
        case .getDirectionsFrom:
            return "Get directions from"
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
            return "Sorry, the restaurant had to cancel your order. Would you like to order from another restaurant?"
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
            return "Oops, looks like you’ve run out of time to convert your order to a pick-up order! You can try placing the order again."
        case .orderCancelledLikeToPickupOrder:
            return "I’d like to pick up order"
        case .minText:
            return "MinTitle".localizedString
        case .orderAccepted:
            return "Your order has been accepted"
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
            return "Live tracking is not available"
        case .dismiss:
            return "Dismiss"
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
        }
    }
}
