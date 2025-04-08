//
//  HabbitGraph.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 07.04.2025.
//

import UIKit

class HabbitGraph: UIView {
    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    
    let spacing: CGFloat = 4
    let size = 16
    
    
    init() {
        super.init(frame: .zero)
        
        configureCollectionView()
        configureCollectionViewDataSource()
        configureSubviews()
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.itemSize = CGSize(width: size, height: size)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing * 3, bottom: 0, right: spacing * 3)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabbitGraphCell.self, forCellWithReuseIdentifier: HabbitGraphCell.reuseId)
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(
            collectionView: collectionView,
            cellProvider: { cv, indexPath, number in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: HabbitGraphCell.reuseId, for: indexPath) as! HabbitGraphCell
                cell.backgroundColor = Bool.random() ? UIColor.systemGreen : UIColor.systemGray
                
                return cell
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        
        
        let data: [Int] = Array(0..<364)
        snapshot.appendItems(data)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(size * 7) + CGFloat(spacing * 6)),
        ])
    }
    
    private func stylize() {
        backgroundColor = .systemPink
    }
}
