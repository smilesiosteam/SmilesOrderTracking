//
//  File.swift
//
//
//  Created by Ahmed Naguib on 20/11/2023.
//

import Foundation
import Combine

protocol OrderTrackingUseCaseProtocol {
    func fetchOrderStates(with statues: Int?)
    var statePublisher: AnyPublisher<OrderTrackingUseCase.State, Never> { get }
}

final class OrderTrackingUseCase: OrderTrackingUseCaseProtocol {
    
//    var orderStatus = PassthroughSubject<OrderTrackingModel, Never>()
//    @Published private(set) var isOrderArrived = false
//    @Published private(set) var isLiveTracking = false
    
    private var cancellables = Set<AnyCancellable>()
    private let orderId: String
    private let orderNumber: String
    private var stateSubject = PassthroughSubject<State, Never>()
    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(orderId: String, orderNumber: String) {
        self.orderId = orderId
        self.orderNumber = orderNumber
    }
    
    // we passed the status as parameter to navigate to the OrderHasBeenDeliveredConfig status
    func fetchOrderStates(with statues: Int?) {
        
//        loadOrderStatus()
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                var orderResponse = try JSONDecoder().decode(OrderTrackingStatusResponse.self, from: jsonData)
                let orderStatus = orderResponse.orderDetails?.orderStatus
                orderResponse.orderDetails?.orderStatus = statues ?? orderStatus
                
                let status = self.configOrderStatus(response: orderResponse)
                self.orderStatus.send(status)
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
        case .orderProcessing, .pickupChanged:
        return getProcessingOrderModel(response: response)
        case .waitingForTheRestaurant:
            return WaitingOrderConfig(response: response).build()
        case .orderAccepted:
            stateSubject.send(.showToastForArrivedOrder(isShow: true))
            return AcceptedOrderConfig(response: response).build()
        case .inTheKitchen, .orderHasBeenPickedUpDelivery:
            return InTheKitchenOrderConfig(response: response).build()
        case .orderIsReadyForPickup:
            return ReadyForPickupOrderConfig(response: response).build()
        case .orderHasBeenPickedUpPickup:
            return OrderHasBeenDeliveredConfig(response: response).build()
        case .orderIsOnTheWay:
            let status = OnTheWayOrderConfig(response: response)
            stateSubject.send(.showToastForNoLiveTracking(isShow: status.isLiveTracking))
            return status.build()
        case .orderCancelled:
            return CanceledOrderConfig(response: response).build()
        case .changedToPickup:
            return ChangedToPickupOrderConfig(response: response).build()
        case .confirmation:
            return ConfirmationOrderConfig(response: response).build()
        case .someItemsAreUnavailable:
            return SomeItemsUnavailableConfig(response: response).build()
        case .orderNearYourLocation:
            return NearOfLocationConfig(response: response).build()
        case .delivered:
            return DeliveredOrderConfig(response: response).build()
        }
        
    }
    
    private func getProcessingOrderModel(response: OrderTrackingStatusResponse) -> OrderTrackingModel {
        var processOrder = ProcessingOrderConfig(response: response)
//        processOrder.hideCancelButton = { [weak self] in
////            guard let self else {
////                return
////            }
////            var orderResponse = response
////            orderResponse.orderDetails?.showCancelButtonTimeout = true
////            orderResponse.orderDetails?.isCancelationAllowed = false
////            let status = self.configOrderStatus(response: orderResponse)
////            self.orderStatus.send(status)
//        }
        return processOrder.build()
    }
    
    private func loadOrderStatus() {
        let handler = OrderTrackingServiceHandler()
        handler.getOrderTrackingStatus(orderId: orderId,
                                       orderStatus: .confirmation,
                                       orderNumber: orderNumber)
        .sink { [weak self] completion in
            switch completion {
                
            case .finished:
                print("finished")
            case .failure(let error):
                self?.stateSubject.send(.showError(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] response in
            guard let self else {
                return
            }
//            var x = response
//            x.orderDetails?.orderStatus = 3
            let status = self.configOrderStatus(response: response)
            self.stateSubject.send(.success(model: status))
            let orderId = response.orderDetails?.orderId ?? 0
            self.stateSubject.send(.orderId(id: "\(orderId)"))
            
        }.store(in: &cancellables)
        
    }

}

extension OrderTrackingUseCase {
    enum State {
        case showError(message: String)
        case showToastForArrivedOrder(isShow: Bool)
        case showToastForNoLiveTracking(isShow: Bool)
        case success(model: OrderTrackingModel)
        case orderId(id: String)
    }
}



let jsonString = """
{
  "extTransactionId": "3530191483630",
  "orderDetails": {
    "orderStatus": 7,
     "smallImageAnimationUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/ENGLISH/SMALL/Delivering.json",
     "largeImageAnimationUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/ENGLISH/LARGE/Waiting.json",
     "trackingColorCode": "#a5deef",
     "earnPointsText": "smiles points earned and will be credited soon.",

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
    "isCancelationAllowed": true,
    "orderType": "PICK_UP",
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
    "driverImageIconUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/driverimageIcon.png",
    "driverPhoneImageUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/driverphoneIcon.png",
    "mapImageIconUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/mapIcon.png",
    "subTitleImageIconUrl": "https://www.smilesuae.ae/images/APP/ORDER_TRACKING/IMAGES/SubTitleimageIcon.png",
    "bannerImageUrl": "https://www.smilesuae.ae/images/APP/BANNERS/ENGLISH/BOTTOM/OrderTrackingULFD_V2.png",

  },
"orderRatings": [
            {
                "ratingType": "food",
                "userRating": 0.0,
                "title": "how was the food from Hardee's?",
                "image": "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg"
            },
            {
                "ratingType": "delivery",
                "userRating": 0.0,
                "title": "Rate delivery",
                "image": "https://cdn.eateasily.com/restaurants/9d237d8a2148c1c2354ff1a2b769f3e2/17338_small.jpg"
            }
        ],
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
