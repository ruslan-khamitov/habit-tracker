//
//  MainPageVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 07.04.2025.
//

import UIKit
import Combine

class MainPageVC: UIViewController {
    enum Section {
        case main
    }
    
    // Components
    let addHabbitContainer = UIView()
    let addHabbitBtn = UIButton()
    var habbitCollection: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,HabitVM>!
    
    var cancellables = Set<AnyCancellable>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureComponents()
        configureSubviews()
        stylize()
        fetchHabbits()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 20, right: 12)
        layout.itemSize = CGSize(width: view.bounds.width, height: HabitGraphUI.totalHeight)
        
        habbitCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        habbitCollection?.register(HabitGraphMainPageCell.self, forCellWithReuseIdentifier: HabitGraphMainPageCell.reuseId)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, HabitVM>(collectionView: habbitCollection, cellProvider: { (cv, indexPath, habit) in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: HabitGraphMainPageCell.reuseId, for: indexPath) as! HabitGraphMainPageCell
            cell.set(habit: habit)
            cell.delegate = self
            return cell
        })
    }
    
    private func updateData(habits: [HabitVM]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, HabitVM>()
        snapshot.appendSections([.main])
        snapshot.appendItems(habits)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func configureSubviews() {
        habbitCollection.translatesAutoresizingMaskIntoConstraints = false
        addHabbitBtn.translatesAutoresizingMaskIntoConstraints = false
        addHabbitContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(habbitCollection)
        
        // Add Habbit container + button
        view.addSubview(addHabbitContainer)
        addHabbitContainer.addSubview(addHabbitBtn)
        
        NSLayoutConstraint.activate([
            addHabbitContainer.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addHabbitContainer.leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            addHabbitContainer.trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            addHabbitContainer.heightAnchor.constraint(equalToConstant: 50),
            
            addHabbitBtn.topAnchor
                .constraint(equalTo: addHabbitContainer.topAnchor),
            addHabbitBtn.leadingAnchor
                .constraint(equalTo: addHabbitContainer.leadingAnchor),
            addHabbitBtn.widthAnchor
                .constraint(equalToConstant: 200),
            addHabbitBtn.bottomAnchor
                .constraint(equalTo: addHabbitContainer.bottomAnchor),
            
            habbitCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habbitCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habbitCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habbitCollection.bottomAnchor.constraint(equalTo: addHabbitContainer.topAnchor)
        ])
    }
    
    private func configureComponents() {
        configureCollectionView()
        configureDataSource()
        
        let action = UIAction { [weak self] _ in
            self?.addNewHabbit()
        }
        
        addHabbitBtn.addAction(action, for: .touchUpInside)
    }
    
    private func stylize() {
        navigationItem.title = "Habbits"
        
        view.backgroundColor = .systemBackground
        
        addHabbitContainer.backgroundColor = .systemGray6
        
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.image = UIImage(systemName: "plus.circle")
        buttonConfiguration.imagePadding = 8
        buttonConfiguration.title = "Add new habbit"
        buttonConfiguration.baseForegroundColor = .label
        buttonConfiguration.baseBackgroundColor = .systemGray
        
        addHabbitBtn.configuration = buttonConfiguration
    }
    
    private func fetchHabbits() {
        // TODO: separate functions
        Task {
          await AppContainer.habitsInteractor.fetchHabits()
        }
        AppContainer.habitsInteractor.$habits
            .receive(on: RunLoop.main)
            .sink { [weak self] habits in self?.updateData(habits: habits) }
            .store(in: &cancellables)
    }
    
    private func addNewHabbit() {
        let vc = AddHabbitVC()
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension MainPageVC: AddHabbitVCDelegate {
    func onAddHabbitDismiss() {
        fetchHabbits()
    }
}

extension MainPageVC: HabitGraphMainPageCellDelegate {
    func navigateTo(habit: HabitVM) {
        let vc = HabbitVC(habit: habit)
        navigationController?.pushViewController(vc, animated: true)
    }
}
