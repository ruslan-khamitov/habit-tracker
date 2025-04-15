//
//  HabitGraph.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 07.04.2025.
//

import UIKit

class HabitGraph: UIView {
    enum Section {
        case main
    }

    // Components
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, DayVM>!
    
    // State
    var habit: HabitVM? = nil
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
            width: HabitGraphUI.tileSize,
            height: HabitGraphUI.tileSize
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
                HabitGraphCell.self,
                forCellWithReuseIdentifier: HabitGraphCell.reuseId
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
                    withReuseIdentifier: HabitGraphCell.reuseId,
                    for: indexPath
                ) as! HabitGraphCell
                
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
                        equalToConstant: HabitGraphUI.graphPartHeight
                    ),
            ]
        )
    }
    
    public func set(habit: HabitVM) {
        trackedColor = habit.color
        self.habit = habit
        
        let calendar = Calendar.current
        let today = Date()
        
        var dates: [DayVM] = []
        
        var numberOfColumns = bounds.width / (HabitGraphUI.tileSize + HabitGraphUI.tileSpacing)
        var numberOfDays = numberOfColumns * 7
        
        var dateOffset = -363
        while dateOffset <= 0 {
            if let dateFromPastYear = calendar.date(
                byAdding: .day,
                value:-dateOffset,
                to: today
            ) {
                let untrackedDate = calendar.startOfDay(for: dateFromPastYear)
                let trackedDate = habit.trackedDays.first {
                    calendar.startOfDay(for: $0.date) == untrackedDate
                }
                    
                if let trackedDate = trackedDate {
                    dates.append(trackedDate)
                } else {
                    dates.append(DayVM(date: untrackedDate, id: UUID(), trackedDay: nil))
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
