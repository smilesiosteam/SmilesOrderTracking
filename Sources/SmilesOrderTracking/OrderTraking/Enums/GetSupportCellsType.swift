//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 01/12/2023.
//

import Foundation

enum GetSupportCellType {
    case progressBar(model: OrderProgressCollectionViewCell.ViewModel)
    case text(model: TextCollectionViewCell.ViewModel)
    case support(model: GetSupportCollectionViewCell.ViewModel)
}

enum GetSupportHeaderType {
    case supportImageHeader(model: GetSupportImageHeaderCollectionViewCell.ViewModel)
}

struct GetSupportModel {
    var header: GetSupportHeaderType = .supportImageHeader(model: .init(type: .image(imageName: "")))
    var cells: [GetSupportCellType] = []
}
