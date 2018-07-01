//
//  Created by Kevin Belter on 1/5/17.
//  Copyright © 2017 KevinBelter. All rights reserved.
//

import UIKit

class GenericCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    init(collectionView: UICollectionView, configFiles: [GenericCollectionCellConfigurator]) {
        self.collectionView = collectionView
        self.configFiles = configFiles
        super.init()
        registerCells()
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let configFile = (configFiles.filter { $0.section == indexPath.section && $0.typeCell == .cell })[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: configFile.className, for: indexPath)
        (cell as! GenericCollectionCellProtocol).collectionView(collectionView: collectionView, cellForItemAt: indexPath, with: configFile.item)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let maxSectionNumber = (configFiles.map { $0.section }.sorted { $0 > $1 }).first else { return 1 }
        return maxSectionNumber + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let typeCell = CollectionCellType.getCollectionCellTypeBySupplementaryKind(kind: kind)
            else { return UICollectionReusableView() }
        
        guard let configFile = (configFiles.filter { $0.typeCell == typeCell && $0.section == indexPath.section }).first
            else { return UICollectionReusableView() }
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: configFile.className,
            for: indexPath) as! GenericCollectionReusableProtocol
        
        reusableView.collectionView(
            collectionView: collectionView,
            viewForSupplementaryElementOfKind: kind,
            at: indexPath,
            with: configFile.item)
        
        return reusableView as! UICollectionReusableView
    }
    
    private func registerCells() {
        let classesToRegister = Set(configFiles)
        for classToRegister in classesToRegister {
            switch classToRegister.typeCell {
            case .cell:
                collectionView.register(
                    classToRegister.classType,
                    forCellWithReuseIdentifier: classToRegister.className)
            case .header:
                collectionView.register(
                    classToRegister.classType,
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    withReuseIdentifier: classToRegister.className)
            case .footer:
                collectionView.register(
                    classToRegister.classType,
                    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                    withReuseIdentifier: classToRegister.className)
            }
        }
    }
    
    weak var collectionView: UICollectionView!
    
    var configFiles: [GenericCollectionCellConfigurator] {
        didSet {
            registerCells()
        }
    }
}

extension GenericCollectionViewDataSource {
    func reloadAt(indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func reloadAt(indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func insertRows(configFiles partialConfigFiles: [GenericCollectionCellConfigurator], maxSectionInsertedOpt: Int? = nil, completion: (()->())? = nil) {
        collectionView.performBatchUpdates({ 
            self.insertRowsRaw(configFiles: partialConfigFiles, maxSectionInsertedOpt: maxSectionInsertedOpt)
        }) { completed in
            if !completed { return }
            completion?()
        }
    }

    func insertRow(configFile: GenericCollectionCellConfigurator, completion: (()->())? = nil) {
        insertRows(configFiles: [configFile], completion: completion)
    }
    
    func getIndexPath(by filter: (GenericCollectionCellConfigurator)->Bool) -> IndexPath? {
        guard let configFile = configFiles.filter(filter).first else { return nil }
        
        let allRowsForSection = configFiles.filter { $0.section == configFile.section && $0.typeCell == .cell }
        
        guard let indexInSection = allRowsForSection.index(where: filter) else { return nil }
        
        return IndexPath(item: indexInSection, section: configFile.section)
    }
    
    func deleteRow(by filter: @escaping (GenericCollectionCellConfigurator)->Bool, completion: (()->())? = nil) {
        self.collectionView.performBatchUpdates({
            guard let indexPath = self.getIndexPath(by: filter) else { return }
            
            let numberOfSections = self.collectionView.numberOfSections
            self.configFiles = self.configFiles.filter { !filter($0) }
            let rowsWithHeaders = self.configFiles.filter { $0.section == indexPath.section }
            self.collectionView.deleteItems(at: [indexPath])
            
            if numberOfSections - 1 == indexPath.section && rowsWithHeaders.count == 0 && numberOfSections > 1 {
                self.collectionView.deleteSections(self.getIndexSetToDelete(forSection: indexPath.section))
            }
        }) { finish in
            if !finish { return }
            completion?()
        }
    }
    
    func deleteAllRowsAt(section: Int, completion: (()->())? = nil) {
        let configFilesToDelete = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }
        
        if configFilesToDelete.count == 0 { completion?(); return }
        
        var indexPaths = [IndexPath]()
        for (index, _) in configFilesToDelete.enumerated() {
            indexPaths.append(IndexPath(item: index, section: section))
        }
        
        collectionView.performBatchUpdates({
            
            self.collectionView.deleteItems(at: indexPaths)
            self.configFiles = self.configFiles.filter { !($0.section == section && $0.typeCell == .cell) }
            
            // Delete section if needed.
            let headersOrFootersInSection = self.configFiles.filter { $0.section == section && $0.typeCell != .cell }
            if section == self.collectionView.numberOfSections - 1 &&
                self.collectionView.numberOfSections > 1 &&
                headersOrFootersInSection.count == 0 {
                self.collectionView.deleteSections(self.getIndexSetToDelete(forSection: section))
            }
            // ---
        }) { completed in
            if !completed { return }
            completion?()
        }
    }
    
    private func getIndexPaths(section: Int, configFiles: [GenericCollectionCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        let numberOfCellsInSection = self.configFiles.filter { $0.section == section && $0.typeCell == .cell }.count
        
        for (index, _) in configFiles.enumerated() {
            indexPaths.append(IndexPath(item: index + numberOfCellsInSection, section: section))
        }
        return indexPaths
    }
    
    private func getStandaloneIndexPaths(configFiles: [GenericCollectionCellConfigurator]) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let allSections = Set(configFiles.map { $0.section }).sorted(by: >)
        for section in allSections {
            let rowsInSection = configFiles.filter { $0.section == section }
            
            for (index, _) in rowsInSection.enumerated() {
                indexPaths.append(IndexPath(item: index, section: section))
            }
        }
        return indexPaths
    }
    
    private func getConfigFilesWithoutDuplication(configFiles partialConfigFiles: [GenericCollectionCellConfigurator]) -> [GenericCollectionCellConfigurator] {
        var uniqueIdentifiers = [String]()
        var partialCopyConfigFiles = [GenericCollectionCellConfigurator]()
        
        for configFile in partialConfigFiles {
            guard let identifier = configFile.diffableIdentifier else {
                partialCopyConfigFiles.append(configFile)
                continue
            }
            
            if uniqueIdentifiers.contains(identifier) { continue }
            uniqueIdentifiers.append(identifier)
            partialCopyConfigFiles.append(configFile)
        }
        
        return partialCopyConfigFiles.filter { configFile in
            guard let diffableIdentifier = configFile.diffableIdentifier else { return true }
            return (self.configFiles.first { $0.diffableIdentifier == diffableIdentifier }) == nil
        }
    }
    
    private func insertRowsRaw(configFiles partialConfigFiles: [GenericCollectionCellConfigurator], maxSectionInsertedOpt: Int? = nil) {
        let configFiles = getConfigFilesWithoutDuplication(configFiles: partialConfigFiles)
        
        let sections = Set(configFiles.map { $0.section }).sorted { $0 < $1 }
        var maxSectionInserted = maxSectionInsertedOpt ?? self.collectionView.numberOfSections
        
        for section in sections {
            if maxSectionInserted <= section {
                self.collectionView.insertSections(
                    IndexSet(integersIn: (maxSectionInserted...section))
                )
                maxSectionInserted = section + 1
            }
            let configFilesRowsForSection = configFiles.filter { $0.section == section && $0.typeCell == .cell }
            let configFilesForSection = configFiles.filter { $0.section == section }
            let indexPaths = self.getIndexPaths(section: section, configFiles: configFilesRowsForSection)
            
            self.configFiles += configFilesForSection
            self.collectionView.insertItems(at: indexPaths)
        }
    }
    
    private func getIndexSetToDelete(forSection section: Int) -> IndexSet {
        let sectionToDeleteFrom: Int
        if let sec = ((self.configFiles.filter { $0.section < section }).sorted { $0.section > $1.section }).first?.section {
            sectionToDeleteFrom = sec + 1
        } else {
            sectionToDeleteFrom = 1
        }
        
        return IndexSet(integersIn: sectionToDeleteFrom ... section)
    }
    
    private func getConfigFileWithoutDuplication(configFile partialConfigFile: GenericCollectionCellConfigurator) -> GenericCollectionCellConfigurator? {
        return getConfigFilesWithoutDuplication(configFiles: [partialConfigFile]).first
    }
}
