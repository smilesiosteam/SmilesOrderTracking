//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation

final class OrderTrackingUseCase {
    
    func load() {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let orderResponse = try JSONDecoder().decode(OrderTrackingResponseModel.self, from: jsonData)
                print(orderResponse)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    
    
    
    
    
}

let jsonString = """
{
  "extTransactionId": "3530191483630",
  "orderDetails": {
    "orderStatus": 0,
    "title": "Waiting for the restaurant",
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
    "earnPoints": 0,
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
    "deliveryBy": "Delivered By Restaurant"
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
    }
  ]
}
"""
