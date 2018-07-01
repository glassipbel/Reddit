
//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

class GenericCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    init(
        dataSource: GenericCollectionViewDataSource,
        insetsForSection: [Int: UIEdgeInsets]? = nil,
        minimumLineSpacingForSection: [Int: CGFloat]? = nil,
        minimumItemSpacingForSection: [Int: CGFloat]? = nil,
        actions: GenericCollectionActions? = nil) {
        self.actions = actions
        self.dataSource = dataSource
        self.insetsForSection = insetsForSection
        self.minimumLineSpacingForSection = minimumLineSpacingForSection
        self.minimumItemSpacingForSection = minimumItemSpacingForSection
        super.init()
        self.dataSource.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return
            self.minimumLineSpacingForSection?[section] ?? (self.dataSource.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return
            self.minimumItemSpacingForSection?[section] ?? (self.dataSource.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let configFile = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }[indexPath.item]
        
        switch configFile.sizingType {
        case .cell(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath, with: configFile.item)
        case .specificSize(let size):
            return size
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .header }).first else { return .zero }
        
        switch configFile.sizingType {
        case .header(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section, with: configFile.item)
        case .specificSize(let size):
            return size
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let configFile = (dataSource.configFiles.filter { $0.section == section && $0.typeCell == .footer }).first else { return .zero }
        
        switch configFile.sizingType {
        case .footer(let instance):
            return instance.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section, with: configFile.item)
        case .specificSize(let size):
            return size
        case .specificHeight(let height):
            return CGSize(width: collectionView.bounds.width, height: height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionCellProtocol else { return }
        cell.collectionView?(collectionView: collectionView, didDeselectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.configFiles.count == 0 { return }
        
        if checkIfReachLastCellInCollection(indexPath: indexPath) {
            actions?.reachLastCellInCollection?()
        }
        
        guard let genericCell = cell as? GenericCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath, with: configFile.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let genericCell = cell as? GenericCollectionCellProtocol else { return }
        
        let configFiles = dataSource.configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell }
        
        if configFiles.count < indexPath.item + 1 { return }
        
        let configFile = configFiles[indexPath.item]
        
        genericCell.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath, with: configFile.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let insets = insetsForSection else {
            return (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        }
        return insets[section] ?? (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }
    
    private func checkIfReachLastCellInCollection(indexPath: IndexPath) -> Bool {
        //Returning false because the user doesn't want to know if reached last cell in collection.
        if actions?.reachLastCellInCollection == nil { return false }
        
        let maxSection = dataSource.configFiles.map { $0.section }.sorted { $0 > $1 }.first
        let numberOfRowsInLastSection = dataSource.configFiles.filter { $0.section == maxSection && $0.typeCell == .cell }.count
        
        if maxSection != indexPath.section { return false }
        if numberOfRowsInLastSection == 0 { return false }
        
        return lastRowComparation(indexPath: indexPath, numberOfRows: numberOfRowsInLastSection)
    }
    
    private func lastRowComparation(indexPath: IndexPath, numberOfRows: Int) -> Bool {
        if numberOfRows >= 3 {
            return indexPath.item == numberOfRows - 3
        } else if numberOfRows == 2 {
            return indexPath.item == numberOfRows - 2
        }
        return indexPath.item == numberOfRows - 1
    }

    weak var dataSource: GenericCollectionViewDataSource!
    weak var actions: GenericCollectionActions?
    private var insetsForSection: [Int: UIEdgeInsets]?
    private var minimumLineSpacingForSection: [Int: CGFloat]?
    private var minimumItemSpacingForSection: [Int: CGFloat]?
}
