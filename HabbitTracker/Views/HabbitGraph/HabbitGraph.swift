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

    // Components
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, DayVM>!
    
    // State
    var habbit: HabbitVM? = nil
    var trackedColor = HabbitColors.defaultColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureComponents()
        configureSubviews()
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureComponents() {
        configureCollectionView()
        configureCollectionViewDataSource()
    }
    
    private func configureCollectionView() {
        let spacing: CGFloat = 4
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.itemSize = CGSize(
            width: HabbitGraphUI.tileSize,
            height: HabbitGraphUI.tileSize
        )
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: spacing * 3,
            bottom: 0,
            right: spacing * 3
        )
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView
            .register(
                HabbitGraphCell.self,
                forCellWithReuseIdentifier: HabbitGraphCell.reuseId
            )
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DayVM>(
            collectionView: collectionView,
            cellProvider: { [weak self]
                cv,
                indexPath,
                day in
                let cell = cv.dequeueReusableCell(
                    withReuseIdentifier: HabbitGraphCell.reuseId,
                    for: indexPath
                ) as! HabbitGraphCell
                
                let color = self?.trackedColor.toUIColor() ?? HabbitColors.defaultColor.toUIColor()
                cell.backgroundColor = day.tracked ? color : UIColor.systemGray
                
                return cell
            }
        )
        
    }
    
    private func updateData(data: [DayVM]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DayVM>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor
                    .constraint(
                        equalTo: topAnchor,
                    ),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor
                    .constraint(equalTo: trailingAnchor),
                collectionView.heightAnchor
                    .constraint(
                        equalToConstant: HabbitGraphUI.graphPartHeight
                    ),
            ]
        )
    }
    
    public func set(habbit: HabbitVM) {
        trackedColor = habbit.color
        self.habbit = habbit
        
        let calendar = Calendar.current
        let today = Date()
        
        var dates: [DayVM] = []
        
        var numberOfColumns = bounds.width / (HabbitGraphUI.tileSize + HabbitGraphUI.tileSpacing)
        var numberOfDays = numberOfColumns * 7
        
        print(bounds.width)
        print(frame.width)
        print("numberOfColumns is \(numberOfColumns), numberOfDays = \(numberOfDays)")
        
        var dateOffset = -363
        while dateOffset <= 0 {
            if let dateFromPastYear = calendar.date(
                byAdding: .day,
                value:-dateOffset,
                to: today
            ) {
                let untrackedDate = calendar.startOfDay(for: dateFromPastYear)
                let trackedDate = habbit.trackedDays.first {
                    calendar.startOfDay(for: $0.date) == untrackedDate
                }
                    
                if let trackedDate = trackedDate {
                    dates.append(trackedDate)
                } else {
                    dates.append(DayVM(date: untrackedDate, trackedDay: nil))
                }
                
                dateOffset += 1
            }
        }
        
        updateData(data: dates)
    }
    
    private func stylize() {
        backgroundColor = .systemBackground
    }

}
