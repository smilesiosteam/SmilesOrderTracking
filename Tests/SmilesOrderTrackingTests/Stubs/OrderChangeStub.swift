//
//  File.swift
//  
//
//  Created by Ahmed Naguib on 13/12/2023.
//

import Foundation
@testable import SmilesOrderTracking

enum OrderChangeStub {
    
    static func getChangeTypeModel(isChanged: Bool) -> OrderChangeTypeResponse {
        var model = OrderChangeTypeResponse()
        model.isChangeType = isChanged
        return model
    }
}
