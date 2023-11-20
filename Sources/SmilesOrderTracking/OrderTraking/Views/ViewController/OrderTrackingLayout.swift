//
//  File.swift
//
//
//  Created by Ahmed Naguib on 15/11/2023.
//

import UIKit

final class OrderTrackingLayout {
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            return createMountainSection(layoutEnvironment)
        }
    }
    
    private static func createMountainSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // Item
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 17
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), 
                                                heightDimension: .estimated(380))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: OrderConstans.headerName.rawValue,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
