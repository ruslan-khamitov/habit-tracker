//
//  HabbitVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import UIKit
import SwiftUI

class HabbitVC: UIViewController {
    let graph: HabitGraph
    let trackTodayButton = UIButton()
    
    let deleteHabitButton = UIButton()
    let editButton = UIButton()
    let habitActionsStack = UIStackView()
    
    var habit: HabitEntity
    
    init(habit: HabitEntity) {
        graph = HabitGraph()
        graph.set(habit: habit)
        
        self.habit = habit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureComponents()
        stylize()
    }

    private func configureLayout() {
        graph.translatesAutoresizingMaskIntoConstraints = false
        trackTodayButton.translatesAutoresizingMaskIntoConstraints = false
        deleteHabitButton.translatesAutoresizingMaskIntoConstraints = false
        habitActionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(graph)
        view.addSubview(trackTodayButton)

        // Habit Actions Stack
        view.addSubview(habitActionsStack)
        habitActionsStack.addArrangedSubview(editButton)
        habitActionsStack.addArrangedSubview(deleteHabitButton)
        habitActionsStack.axis = .horizontal
        
        let habitActionsSpacing: CGFloat = 8
        
        habitActionsStack.spacing = 8
        habitActionsStack.distribution = .fillEqually
        
        let habitActionsButtonSize: CGFloat = 50
        
        
        let horizontalPadding: CGFloat = 12
        
        NSLayoutConstraint.activate(
[
            habitActionsStack.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
            habitActionsStack.leadingAnchor
                .constraint(
                    equalTo: view.leadingAnchor,
                    constant: horizontalPadding
                ),
            habitActionsStack.widthAnchor
                .constraint(
                    equalToConstant: habitActionsButtonSize * 2 + habitActionsSpacing
                ),
            habitActionsStack.heightAnchor
                .constraint(equalToConstant: habitActionsButtonSize),
            
            graph.topAnchor
                .constraint(
                    equalTo: habitActionsStack.bottomAnchor,
                    constant: 20
                ),
            graph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graph.heightAnchor
                .constraint(equalToConstant: HabitGraphUI.graphPartHeight),
            
            trackTodayButton.topAnchor
                .constraint(equalTo: graph.bottomAnchor, constant: 20),
            trackTodayButton.leadingAnchor
                .constraint(
                    equalTo: view.leadingAnchor,
                    constant: horizontalPadding
                ),
            trackTodayButton.trailingAnchor
                .constraint(
                    equalTo: view.trailingAnchor,
                    constant: -horizontalPadding
                ),
            trackTodayButton.heightAnchor.constraint(equalToConstant: 50),
            
            editButton.widthAnchor
                .constraint(equalToConstant: habitActionsButtonSize),
            deleteHabitButton.widthAnchor
                .constraint(equalToConstant: habitActionsButtonSize)
]
        )
    }
    
    private func configureComponents() {
        let toggleAction = UIAction { [weak self] _ in
            self?.toggleToday()
        }
        trackTodayButton.addAction(toggleAction, for: .touchUpInside)
        
        let deleteAction = UIAction { [weak self] _ in
            self?.deleteHabbit()
        }
        deleteHabitButton.addAction(deleteAction, for: .touchUpInside)
        
        let editAction = UIAction { [weak self] _ in
            self?.editHabit()
        }
        editButton.addAction(editAction, for: .touchUpInside)
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
        navigationItem.title = habit.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        var trackBtnConfiguration = UIButton.Configuration.bordered()
        trackBtnConfiguration.title = "Track today"
        trackBtnConfiguration.baseBackgroundColor = .systemBlue
        trackBtnConfiguration.baseForegroundColor = .white
        trackTodayButton.configuration = trackBtnConfiguration
        
        var deleteBtnConfiguration = UIButton.Configuration.bordered()
        deleteBtnConfiguration.baseForegroundColor = .systemRed
        deleteBtnConfiguration.baseBackgroundColor = .systemGray4
        deleteBtnConfiguration.image = UIImage(systemName: "trash")
        deleteHabitButton.configuration = deleteBtnConfiguration
        
        var editBtnConfiguration = UIButton.Configuration.bordered()
        editBtnConfiguration.baseForegroundColor = .label
        editBtnConfiguration.baseBackgroundColor = .systemGray4
        editBtnConfiguration.image = UIImage(systemName: "pencil")
        editButton.configuration = editBtnConfiguration
    }
    
    private func toggleToday() {
        let vm = HabitDay(id: UUID(), date: Date(), isTracked: true)
        
        let interactor = AppContainer.habitsInteractor
        
        Task {
            await interactor.toggleTrack(day: vm, forHabit: habit)
            
            let newHabit = await interactor.refetchHabit(habit: habit)
            if let newHabit = newHabit {
                onHabitUpdate(newHabit: newHabit)
            }
        }
    }
    
    @MainActor
    private func onHabitUpdate(newHabit: HabitEntity) {
       habit = newHabit
       graph.set(habit: newHabit)
       graph.collectionView.reloadData()
       navigationItem.title = newHabit.name
    }
    
    private func refetchHabit() {
        Task {
            let updatedHabit = await AppContainer.habitsInteractor.refetchHabit(
                habit: habit
            )
            guard let updatedHabit else {
                _ = await MainActor.run {
                    // TODO: handle this situation
                    navigationController?.popViewController(animated: true)
                }
                return
            }
            
            onHabitUpdate(newHabit: updatedHabit)
        }
    }
    
    private func editHabit() {
        let addHabit = AddHabit(habitToEdit: habit) {
            self.refetchHabit()
        }
        let vc = UIHostingController(rootView: addHabit)
        
        present(vc, animated: true)
    }
    
    private func deleteHabbit() {
        let alert = UIAlertController(
            title: "Delete habit?",
            message: "Are you sure you want to delete this habit?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert
            .addAction(
                UIAlertAction(
                    title: "Delete",
                    style: .destructive,
                    handler: { [weak self] _ in
                        self?.submitDeleteHabbit()
                    })
            )
        
        present(alert, animated: true)
    }
    
    private func submitDeleteHabbit() {
        navigationController?.popViewController(animated: true)

        Task {
            await AppContainer.habitsInteractor.remove(habit: habit)
        }    
    }
}
