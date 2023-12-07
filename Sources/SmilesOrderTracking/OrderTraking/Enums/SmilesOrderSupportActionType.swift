//
// SmilesSupportActionType
//
//
//  Created by Shmeel Ahmed on 06/12/2023.
//

enum SmilesSupportActionType{
    case callRestaurant,callChampion,openFAQ,liveChat
    func title()->String{
        switch(self){
            
        case .callRestaurant:
            return "Call restaurant".localizedString
        case .callChampion:
            return "CallChamp".localizedString
        case .openFAQ:
            return "FAQs".localizedString
        case .liveChat:
            return "Live chat".localizedString
        }
    }
    
    func subtitle()->String{
        switch(self){
            
        case .callRestaurant:
            return "CheckRestInfo".localizedString
        case .callChampion:
            return "CheckChampInfo".localizedString
        case .openFAQ:
            return "Other queries".localizedString
        case .liveChat:
            return "HelpFromLiveChat".localizedString
        }
    }
    
    func iconName()->String{
        switch(self){
            
        case .callRestaurant:
            return "callIcon"
        case .callChampion:
            return "delliveryChampionIcon"
        case .openFAQ:
            return "faqIcon"
        case .liveChat:
            return "liveChatIcon"
        }
    }
}
