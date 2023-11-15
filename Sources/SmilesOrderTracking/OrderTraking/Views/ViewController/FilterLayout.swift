//
//  File.swift
//
//
//  Created by Ahmed Naguib on 15/11/2023.
//

import UIKit

final class FilterLayout {
    
    func createLayout(sections: [String]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout{ [weak self] (index, _) -> NSCollectionLayoutSection? in
            return self?.createSections(index: index, sections: sections)
        }
        return layout
    }
    
    private func createSections(index: Int, sections: [String]) -> NSCollectionLayoutSection? {
        //        let isFistSection = sections[index].isFirstSection
        return configLayoutSection()
    }
    
    private func configLayoutSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        //        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        //      section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0) // 8 8
        //        section.interGroupSpacing = 14
        
        //        let headerHeight: CGFloat = isFirstSection ? 40 : 90
        //        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight))
        //        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        //        section.boundarySupplementaryItems = [header]
        return section
    }
}

final class MountainLayout {
    
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
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 13
        return section
    }
}
