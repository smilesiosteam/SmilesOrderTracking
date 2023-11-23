//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import Combine

final class OrderTrackingUseCase {
    
    var orderModel: OrderTrackingModel = .init()
    @Published private(set) var isShowToast = false
    func load() {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let orderResponse = try JSONDecoder().decode(OrderTrackingStatusResponse.self, from: jsonData)
                print(orderResponse)
                orderModel =  self.configOrderStatus(response: orderResponse)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    func configOrderStatus(response: OrderTrackingStatusResponse) -> OrderTrackingModel {
        guard let status = response.orderDetails?.orderStatus,
                let value = OrderTrackingType(rawValue: status) else {
            return .init()
        }
        
        
        switch value {
        case .orderProcessing:
            return ProcessingOrderConfig(response: response).build()
        case .waitingForTheRestaurant:
            return WaitingOrderConfig(response: response).build()
        case .orderAccepted:
            isShowToast = true
            return AcceptedOrderConfig(response: response).build()
        case .inTheKitchen:
            return InTheKitchenOrderConfig(response: response).build()
        case .orderIsReadyForPickup, .orderHasBeenPickedUp:
            return InTheKitchenOrderConfig(response: response).build()
        case .orderIsOnTheWay:
            return OnTheWayOrderConfig(response: response).build()
        case .orderHasBeenDelivered:
            return .init()
        case .orderCancelled:
            return .init()
        case .changedToPickup:
            return .init()
        case .determineStatus:
            return .init()
        case .someItemsAreUnavailable:
            return .init()
        case .orderNearYourLocation:
            return NearOfLocationConfig(response: response).build()
        case .delivered:
            return DeliveredOrderConfig(response: response).build()
        }
        
    }

}

let jsonString = """
{
  "extTransactionId": "3530191483630",
  "orderDetails": {
    "orderStatus": 15,
    "title": "Wow, your order has arrived X min early. Enjoy! Ya Naguib",
    "orderDescription": "Hardee's should accept your order soon.",
    "orderNumber": "SMHD112020230000467215",
    "restaurantName": "Hardee's",
    "deliveryRegion": "Al Kifaf",
    "recipient": "SYMEON STEFANIDIS",
    "totalAmount": "56",
    "deliveryCharges": "9",
    "discount": "0",
    "promoCodeDiscount": 0.0,
    "grandTotal": 65.0,
    "vatPrice": 3.1,
    "totalSaving": 0,
    "orderTime": "20-11-2023 03:46 PM",
    "deliveryTime": "40",
    "deliveryTimeRange": "30-40",
    "deliveryTimeRangeText": "04:16PM - 04:26PM",
    "deliveryTimeRangeV2": "Your order will be delivered between 04:16PM - 04:26PM to: Home",
    "pickupTime": "20",
    "restaurantAddress": "Sheikh Essa Tower  Beside Financial Centre Metro Station- Dubai - UAE",
    "phone": "0543936216",
    "latitude": "25.211333693767923",
    "longitude": "55.274305138728316",
    "restaurentNumber": "065092434",
    "estimateTime": "20 Nov 2023 04:26 PM",
    "deliveryAdrress": "maama, Annan, Alan, amann, Sheikh Zayed Rd - Za'abeel - Dubai - United Arab Emirates, Al Kifaf",
    "orderTimeOut": 2,
    "isCancelationAllowed": false,
    "orderType": "DELIVERY",
    "determineStatus": false,
    "earnPoints": 120,
    "addressTitle": "Home",
    "reOrder": true,
    "liveTracking": false,
    "orderId": 466715,
    "imageUrl": "https://cdn.eateasily.com/restaurants/profile/app/400X300/17316.jpg",
    "iconUrl": "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg",
    "deliveryLatitude": "25.230654",
    "subscriptionBanner": {
            "subscriptionTitle": "Subscribe for Unlimited free delivery!",
            "subscriptionIcon": "https://cdn.eateasily.com/mamba/food_bogo.png",
            "redirectionUrl": "smiles://smilessubscription"
        },
    "deliveryLongitude": "55.291472",
    "trackingType": "no",
    "paymentType": "cashOnDelivery",
    "paidAedAmount": "65",
    "isFirstOrder": false,
    "statusText": "Order Received",
    "inlineItemIncluded": false,
    "virtualRestaurantIncluded": false,
    "inlineItemTotal": 0.0,
    "restaurantId": "17338",
    "isDeliveryFree": false,
    "deliveryTip": 0,
    "isLiveChatEnable": true,
    "deliveryBy": "Delivered By Restaurant",
    "driverStatusText": "has picked up your order",
    "driverName": "Osama Tester Driver",
  },
  "orderItems": [
    {
      "quantity": 1,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Quattro Box",
      "price": 56.0,
      "inlineItemIncluded": false
    },
    {
      "quantity": 4,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Dummy Box",
      "price": 56.0,
      "inlineItemIncluded": false
    },
    {
      "quantity": 10,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Beef",
      "price": 56.0,
      "inlineItemIncluded": false
    },
    {
      "quantity": 18,
      "choicesName": [
        " Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Wraptor sandwich ,  Mayonnaise ,  Family Curly fries ,   7 Up "
      ],
      "discountPrice": 56.0,
      "actualChoicePoints": 6223,
      "isVeg": false,
      "isEggIncluded": false,
      "itemName": "Burger",
      "price": 56.0,
      "inlineItemIncluded": false
    }
  ]
}
"""
