//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 20/11/2023.
//

import Foundation
import SmilesUtilities

struct OrderDetail: Codable {
    var showCancelButtonTimeout: Bool?
    var isCancelationAllowed: Bool?
    var isLiveChatEnable: Bool?
    var orderDescription: String?
    var orderDescriptionRange: String?
    var subTitle: String?
    var orderNumber: String?
    var orderStatus: Int?
    var restaurantAddress: String?
    var restaurantName: String?
    var title: String?
    var deliveryTime: String?
    var deliveryTimeRange: String?
    var deliveryTimeRangeText: String?
    var restaurentNumber: String?
    var partnerNumber: String?
    var deliveryAdrress: String?
    var orderTimeOut: Int?
    var deliveryRegion: String?
    var recipient: String?
    var paymentReference: String?
    var totalAmount: String?
    var deliveryCharges: String?
    var discount: String?
    var promoCodeDiscount: Double?
    var grandTotal: Double?
    var vatPrice: Double?
    var totalSaving: Double?
    var orderTime: String?
    var driverName: String?
    var instruction: String?
    var promoCode: String?
    var creditCard: String?
    var latitude: String?
    var longitude: String?
    var determineStatus: Bool?
    var orderType: String?
    var imageUrl: String?
    var iconUrl: String?
    var liveTracking: Bool?
    var liveTrackingUrl: String?
    var reOrder: Bool?
    var reOrderText: String?
    var cookingInstruction: String?
    var addressTitle: String?
    var earnPoints: Int?
    var paymentType: String?
    var paidAedAmount: String?
    var paidAedPoints: String?
    var trackingType: String?
    var isFirstOrder: Bool?
    var orderId: Int?
    var restaurantId: String?
    var refundType: String?
    var refundAmount: String?
    var refundTitle: String?
    var refundDescription: String?
    var refundIcon: String?
    var changeTypeTimer: Int?
    var paidCashVoucher: String?
    var deliveryLatitude: String?
    var deliveryLongitude: String?
    
    var virtualRestaurantIncluded: Bool?

    var inlineItemTotal: Double?

    var virtualOrderTitle: String?
    var isVatable: Bool?
    var vatDescription: String?
    var inlineItemTotalDesc: String?
    
    var inlineItemIncluded: Bool?
    var virtualEventIcon: String?
    var virtualEventTitle: String?
    var virtualEventDescription: String?
    var isDeliveryFree: Bool?
    var subscriptionBanner: SubscriptionsBanner?
    var phone: String?
    var liveTrackingId: String?
    var orderRatings: [OrderRatings]?
    var ratingStatus: Bool?
    var deliveryTip: Int = 0
    var subStatusText: String?
    var delayAlert: DelayAlert?
    var deliveryBy: String?
    var deliveryTimeRangeV2: String?
    var orderDescriptionRangeV2: String?
    var subscriptionBannerV2: SubscriptionsBannerV2?
    var driverStatusText: String?
    
    var driverImageIconUrl: String?
    var driverPhoneImageUrl: String?
    var mapImageIconUrl: String?
    var subTitleImageIconUrl: String?
    var bannerImageUrl: String?
    
    var smallImageAnimationUrl: String?
    var largeImageAnimationUrl: String?
    var trackingColorCode: String?
    var earnPointsText: String?
    var delayStatusText: String?
    enum CodingKeys: String, CodingKey {
        case delayStatusText
        case smallImageAnimationUrl
        case largeImageAnimationUrl
        case trackingColorCode
        case earnPointsText
        case virtualRestaurantIncluded
        case inlineItemTotal
        case virtualOrderTitle
        case vatDescription
        case isVatable
        case isCancelationAllowed
        case isLiveChatEnable
        case orderDescription
        case orderDescriptionRange
        case subTitle
        case orderNumber
        case orderStatus
        case restaurantAddress
        case restaurantName
        case title
        case deliveryTime
        case deliveryTimeRange
        case deliveryTimeRangeText
        case restaurentNumber
        case partnerNumber
        case deliveryAdrress
        case orderTimeOut
        case deliveryRegion
        case recipient
        case paymentReference
        case totalAmount
        case deliveryCharges
        case discount
        case promoCodeDiscount
        case grandTotal
        case vatPrice
        case totalSaving
        case orderTime
        case driverName
        case instruction
        case promoCode
        case creditCard
        case latitude
        case longitude
        case determineStatus
        case orderType
        case imageUrl
        case iconUrl
        case liveTracking
        case liveTrackingUrl
        case reOrder
        case reOrderText
        case cookingInstruction
        case addressTitle
        case earnPoints
        case paymentType
        case paidAedAmount
        case paidAedPoints
        case trackingType
        case isFirstOrder
        case orderId
        case restaurantId
        case refundType
        case refundAmount
        case refundTitle
        case refundDescription
        case refundIcon
        case changeTypeTimer
        case paidCashVoucher
        case deliveryLongitude
        case deliveryLatitude
        case inlineItemIncluded
        case virtualEventIcon
        case virtualEventTitle
        case virtualEventDescription
        case inlineItemTotalDesc
        case isDeliveryFree
        case subscriptionBanner
        case phone
        case liveTrackingId
        case orderRatings
        case ratingStatus
        case deliveryTip
        case subStatusText
        case delayAlert
        case deliveryBy
        case deliveryTimeRangeV2
        case orderDescriptionRangeV2
        case subscriptionBannerV2
        case driverStatusText
        case driverImageIconUrl
        case driverPhoneImageUrl
        case mapImageIconUrl
        case subTitleImageIconUrl
        case bannerImageUrl
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        virtualRestaurantIncluded = try values.decodeIfPresent(Bool.self, forKey: .virtualRestaurantIncluded)
        isVatable = try values.decodeIfPresent(Bool.self, forKey: .isVatable)
        vatDescription = try values.decodeIfPresent(String.self, forKey: .vatDescription)
        virtualOrderTitle = try values.decodeIfPresent(String.self, forKey: .virtualOrderTitle)
        inlineItemTotal = try values.decodeIfPresent(Double.self, forKey: .inlineItemTotal)
        inlineItemTotalDesc = try values.decodeIfPresent(String.self, forKey: .inlineItemTotalDesc)
        isCancelationAllowed = try values.decodeIfPresent(Bool.self, forKey: .isCancelationAllowed)
        isLiveChatEnable = try values.decodeIfPresent(Bool.self, forKey: .isLiveChatEnable)
        orderDescription = try values.decodeIfPresent(String.self, forKey: .orderDescription)
        orderDescriptionRange = try values.decodeIfPresent(String.self, forKey: .orderDescriptionRange)
        subTitle = try values.decodeIfPresent(String.self, forKey: .subTitle)
        orderNumber = try values.decodeIfPresent(String.self, forKey: .orderNumber)
        orderStatus = try values.decodeIfPresent(Int.self, forKey: .orderStatus)
        restaurantAddress = try values.decodeIfPresent(String.self, forKey: .restaurantAddress)
        restaurantName = try values.decodeIfPresent(String.self, forKey: .restaurantName)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        deliveryTime = try values.decodeIfPresent(String.self, forKey: .deliveryTime)
        deliveryTimeRange = try values.decodeIfPresent(String.self, forKey: .deliveryTimeRange)
        deliveryTimeRangeText = try values.decodeIfPresent(String.self, forKey: .deliveryTimeRangeText)
        restaurentNumber = try values.decodeIfPresent(String.self, forKey: .restaurentNumber)
        partnerNumber = try values.decodeIfPresent(String.self, forKey: .partnerNumber)
        deliveryAdrress = try values.decodeIfPresent(String.self, forKey: .deliveryAdrress)
        orderTimeOut = try values.decodeIfPresent(Int.self, forKey: .orderTimeOut)
        deliveryRegion = try values.decodeIfPresent(String.self, forKey: .deliveryRegion)
        recipient = try values.decodeIfPresent(String.self, forKey: .recipient)
        paymentReference = try values.decodeIfPresent(String.self, forKey: .paymentReference)
        totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount)
        deliveryCharges = try values.decodeIfPresent(String.self, forKey: .deliveryCharges)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        promoCodeDiscount = try values.decodeIfPresent(Double.self, forKey: .promoCodeDiscount)
        grandTotal = try values.decodeIfPresent(Double.self, forKey: .grandTotal)
        vatPrice = try values.decodeIfPresent(Double.self, forKey: .vatPrice)
        totalSaving = try values.decodeIfPresent(Double.self, forKey: .totalSaving)
        orderTime = try values.decodeIfPresent(String.self, forKey: .orderTime)
        driverName = try values.decodeIfPresent(String.self, forKey: .driverName)
        instruction = try values.decodeIfPresent(String.self, forKey: .instruction)
        promoCode = try values.decodeIfPresent(String.self, forKey: .promoCode)
        creditCard = try values.decodeIfPresent(String.self, forKey: .creditCard)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        determineStatus = try values.decodeIfPresent(Bool.self, forKey: .determineStatus)
        orderType = try values.decodeIfPresent(String.self, forKey: .orderType)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        iconUrl = try values.decodeIfPresent(String.self, forKey: .iconUrl)
        liveTracking = try values.decodeIfPresent(Bool.self, forKey: .liveTracking)
        liveTrackingUrl = try values.decodeIfPresent(String.self, forKey: .liveTrackingUrl)
        reOrder = try values.decodeIfPresent(Bool.self, forKey: .reOrder)
        reOrderText = try values.decodeIfPresent(String.self, forKey: .reOrderText)
        cookingInstruction = try values.decodeIfPresent(String.self, forKey: .cookingInstruction)
        addressTitle = try values.decodeIfPresent(String.self, forKey: .addressTitle)
        earnPoints = try values.decodeIfPresent(Int.self, forKey: .earnPoints)
        paymentType = try values.decodeIfPresent(String.self, forKey: .paymentType)
        paidAedAmount = try values.decodeIfPresent(String.self, forKey: .paidAedAmount)
        paidAedPoints = try values.decodeIfPresent(String.self, forKey: .paidAedPoints)
        trackingType = try values.decodeIfPresent(String.self, forKey: .trackingType)
        isFirstOrder = try values.decodeIfPresent(Bool.self, forKey: .isFirstOrder)
        restaurantId = try values.decodeIfPresent(String.self, forKey: .restaurantId)
        refundType = try values.decodeIfPresent(String.self, forKey: .refundType)
        refundAmount = try values.decodeIfPresent(String.self, forKey: .refundAmount)
        refundTitle = try values.decodeIfPresent(String.self, forKey: .refundTitle)
        refundDescription = try values.decodeIfPresent(String.self, forKey: .refundDescription)
        refundIcon = try values.decodeIfPresent(String.self, forKey: .refundIcon)
        changeTypeTimer = try values.decodeIfPresent(Int.self, forKey: .changeTypeTimer)
        
        orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
        paidCashVoucher = try values.decodeIfPresent(String.self, forKey: .paidCashVoucher)
        
        deliveryLatitude = try values.decodeIfPresent(String.self, forKey: .deliveryLatitude)
        deliveryLongitude = try values.decodeIfPresent(String.self, forKey: .deliveryLongitude)
        
        inlineItemIncluded = try values.decodeIfPresent(Bool.self, forKey: .inlineItemIncluded)
        virtualEventIcon = try values.decodeIfPresent(String.self, forKey: .virtualEventIcon)
        virtualEventTitle = try values.decodeIfPresent(String.self, forKey: .virtualEventTitle)
        virtualEventDescription = try values.decodeIfPresent(String.self, forKey: .virtualEventDescription)
        isDeliveryFree = try values.decodeIfPresent(Bool.self, forKey: .isDeliveryFree)
        subscriptionBanner = try values.decodeIfPresent(SubscriptionsBanner.self, forKey: .subscriptionBanner)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        liveTrackingId = try values.decodeIfPresent(String.self, forKey: .liveTrackingId)
        orderRatings = try values.decodeIfPresent([OrderRatings].self, forKey: .orderRatings)
        ratingStatus = try values.decodeIfPresent(Bool.self, forKey: .ratingStatus)
        deliveryTip = try values.decodeIfPresent(Int.self, forKey: .deliveryTip) ?? 0
        subStatusText = try values.decodeIfPresent(String.self, forKey: .subStatusText)
        delayAlert = try values.decodeIfPresent(DelayAlert.self, forKey: .delayAlert)
        deliveryBy = try values.decodeIfPresent(String.self, forKey: .deliveryBy)
        deliveryTimeRangeV2 = try values.decodeIfPresent(String.self, forKey: .deliveryTimeRangeV2)
        orderDescriptionRangeV2 = try values.decodeIfPresent(String.self, forKey: .orderDescriptionRangeV2)
        subscriptionBannerV2 = try values.decodeIfPresent(SubscriptionsBannerV2.self, forKey: .subscriptionBannerV2)
        driverStatusText = try values.decodeIfPresent(String.self, forKey: .driverStatusText)
        driverImageIconUrl = try values.decodeIfPresent(String.self, forKey: .driverImageIconUrl)
        driverPhoneImageUrl = try values.decodeIfPresent(String.self, forKey: .driverPhoneImageUrl)
        mapImageIconUrl = try values.decodeIfPresent(String.self, forKey: .mapImageIconUrl)
        subTitleImageIconUrl = try values.decodeIfPresent(String.self, forKey: .subTitleImageIconUrl)
        bannerImageUrl = try values.decodeIfPresent(String.self, forKey: .bannerImageUrl)
        
        smallImageAnimationUrl = try values.decodeIfPresent(String.self, forKey: .smallImageAnimationUrl)
        largeImageAnimationUrl = try values.decodeIfPresent(String.self, forKey: .largeImageAnimationUrl)
        trackingColorCode = try values.decodeIfPresent(String.self, forKey: .trackingColorCode)
        earnPointsText = try values.decodeIfPresent(String.self, forKey: .earnPointsText)
        delayStatusText = try values.decodeIfPresent(String.self, forKey: .delayStatusText)
        
    }
    
    func getIconForStatus(withOrderType orderType: String?) -> String {
        let orderStatus = OrderTrackingType(rawValue: self.orderStatus ?? 0)
        switch orderStatus {
        case .orderIsOnTheWay:
            return  "refreshIconSmall"
        case .orderIsReadyForPickup:
            return "refreshIconSmall"
        case .orderCancelled, .someItemsAreUnavailable:
            return "cancelOrderIcon"
        case .orderHasBeenPickedUpPickup:
            if let orderType = orderType {
                if orderType.lowercased() == RestaurantMenuType.DELIVERY.rawValue.lowercased() {
                    return "greenTick"
                } else {
                    return "greenBag"
                }
            }
            return "greenBag"
        default:
            return "refreshIconSmall"
        }
    }
}
