//
//  File.swift
//
//
//  Created by Ahmed Naguib on 15/11/2023.
//

import UIKit

final class OrderTrackingLayout {
    var isShowHeader = true
     func createLayout() -> UICollectionViewCompositionalLayout {
         UICollectionViewCompositionalLayout { _, layoutEnvironment in
            return self.createMountainSection(layoutEnvironment)
        }
    }
    
    private  func createMountainSection(_ layoutEnvironment: NSCollectionLayoutEnvironment, showHeader: Bool = true) -> NSCollectionLayoutSection {
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
        
        let showHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(380))
        
        let hideHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(0))
        
        let headerSize = isShowHeader ? showHeaderSize : hideHeaderSize
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: OrderConstans.headerName.rawValue,
                                                                 alignment: .top)
        
        header.zIndex = 1
        section.boundarySupplementaryItems = [header]
     
        return section
    }
    
    
//    func createSectionLayout() -> NSCollectionLayoutSection {
//        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0)), subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
//        
//        // Use visibleItemsInvalidationHandler to adjust the header visibility
//        //           section.visibleItemsInvalidationHandler = { items, offset, environment in
//        //               self.handleHeaderVisibility(for: items)
//        //           }
//        
//        
//        return section
//    }
    
}




class StretchyHeaderLayout: UICollectionViewCompositionalLayout {

    // we want to modify the attributes of our header component somehow
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        
        guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
            return layoutAttributes
        }
        if offset.y < 0 {
            
            for attributes in stLayoutAttributes {
                
                if let elmKind = attributes.representedElementKind, elmKind == OrderConstans.headerName.rawValue {
                    
                    let diffValue = abs(offset.y)
                    var frame = attributes.frame
                    frame.size.height = max(0, 500 + diffValue)
                    frame.origin.y = frame.minY - diffValue
                    attributes.frame = frame
                }
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

//   private func handleHeaderVisibility(for items: [NSCollectionLayoutVisibleItem]) {
//           guard let headerAttributes = items.first(where: { $0.representedElementKind == OrderConstans.headerName.rawValue }) else {
//               return
//           }
//
//           let currentOffset = collectionView.contentOffset.y
//           let headerHeight = isShowHeader ? headerAttributes.bounds.height : 0
//
//       print("currentOffset \(currentOffset)")
//       print(collectionView.contentSize.height)
//       print(collectionView.bounds.height)
//           if currentOffset < 0 && isShowHeader {
//               // Scrolling up, hide the header
//               isShowHeader = false
//               animateHeader(withHeight: headerHeight)
//              
//
//           } else if  currentOffset < 0 && !isShowHeader && currentOffset + collectionView.bounds.height >= collectionView.contentSize.height  {
//               // Scrolling down, show the header
//               isShowHeader = true
//               animateHeader(withHeight: headerHeight)
//           }
//       
//       //&& currentOffset + collectionView.bounds.height > collectionView.contentSize.height
//       }
//    private func animateHeader(withHeight height: CGFloat) {
//        self.collectionView.collectionViewLayout.invalidateLayout()
////            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
////               
////            }, completion: nil)
//        }
//    
//    
//}
