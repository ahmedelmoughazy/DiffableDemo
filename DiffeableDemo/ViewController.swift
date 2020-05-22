//
//  ViewController.swift
//  DiffeableDemo
//
//  Created by Ahmed Refaat on 4/11/20.
//  Copyright © 2020 Ibtikar. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section<AnyHashable, [AnyHashable]>, AnyHashable>?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        getData()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func getData() {
        
        var sections: [Section<AnyHashable, [AnyHashable]>] = []
        
        sections.append(Section(headerItem: MovieSection(media: getEpisodes()),
                                sectionItems: getEpisodes()))
        
        sections.append(Section(headerItem: CategoreySection(categories: getCategories()),
                                sectionItems: getCategories()))
        add(items: sections)
    }

    func getEpisodes() -> [Movie] {
        if let path = Bundle.main.path(forResource: "Movies.Success", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                guard let data = try? String(contentsOfFile: path).data(using: .utf8) else { return [Movie]() }
                let dataStored = try decoder.decode(APIResponse<ResponseData>.self, from: data)
                guard let media = dataStored.data?.movies else { return [Movie]() }
                return media
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return [Movie]()
    }
    
    func getCategories() -> [Categorey] {
        if let path = Bundle.main.path(forResource: "Category.Success", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                guard let data = try? String(contentsOfFile: path).data(using: .utf8) else { return [Categorey]() }
                let dataStored = try decoder.decode(APIResponse<ResponseData>.self, from: data)
                guard let categories = dataStored.data?.categories else { return [Categorey]() }
                return categories
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        return [Categorey]()
    }
    
    func configure() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.collectionViewLayout = configureLayout()
        collectionView.delegate = self

        collectionView.register(CategoryCollectionViewCell.nib,
                                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(SmallCollectionViewCell.nib,
                                forCellWithReuseIdentifier: SmallCollectionViewCell.identifier)
        collectionView.register(HeaderView.nibName,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.register(FooterView.nibName,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
        configureDataSource()
        configureSupplementaryView()
    }
    
    func add(items: [Section<AnyHashable, [AnyHashable]>]) {
            
        let payloadDatasource = DataSource(sections: items)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section<AnyHashable, [AnyHashable]>, AnyHashable>()
        payloadDatasource.sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.sectionItems)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: UICollectionViewDataSource

extension ViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section<AnyHashable, [AnyHashable]>, AnyHashable>(collectionView:
        collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            if let media = item as? Movie {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallCollectionViewCell.identifier,
                    for: indexPath) as? SmallCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: media)
                return cell
            }
            
            if let categorey = item as? Categorey {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCollectionViewCell.identifier,
                    for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: categorey)
                return cell
            }
            
            return nil
        }
    }
    
    func configureSupplementaryView() {
        dataSource?.supplementaryViewProvider = { (collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HeaderView.reuseIdentifier,
                    for: indexPath) as? HeaderView else { return UICollectionReusableView() }
                headerView.configureHeader(sectionType: (self.dataSource?.snapshot().sectionIdentifiers[indexPath.section].headerItem)!)
                return headerView
            default:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: FooterView.reuseIdentifier,
                    for: indexPath) as? FooterView else { return UICollectionReusableView() }
                
                return footerView
            }
        }
    }
}

// MARK: UICollectionViewLayout

extension ViewController {
    
    func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            let sectionType = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex].headerItem

            if sectionType is MovieSection {
                return self.getTightCellSectionLayout()
            }
            
            if sectionType is CategoreySection {
                return self.getCategoriesSectionLayout()
            }
            
            return nil
        }
        
        return layout
    }
        
    func getTightCellSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(190),
            heightDimension: .absolute(320))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let sectionLayout = NSCollectionLayoutSection(group: group)
        sectionLayout.orthogonalScrollingBehavior = .continuous
        sectionLayout.interGroupSpacing = 20
        sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 40)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(78))
        
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(9))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        sectionLayout.boundarySupplementaryItems = [headerSupplementary, sectionFooter]
        return sectionLayout
    }
    
    func getCategoriesSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(75))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(20)
        
        let sectionLayout = NSCollectionLayoutSection(group: group)
        sectionLayout.interGroupSpacing = 20
        sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(78))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionLayout.boundarySupplementaryItems = [headerSupplementary]
        
        return sectionLayout
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource?.snapshot().sectionIdentifiers[indexPath.section].sectionItems[indexPath.row] as? Movie {
            print(item.title ?? "no title")
        }
        
        if let item = dataSource?.snapshot().sectionIdentifiers[indexPath.section].sectionItems[indexPath.row] as? Categorey {
            print(item.name ?? "no title")
        }
    }
}
