//
//  HabbitVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import UIKit

class HabbitVC: UIViewController {
    let graph: HabitGraph
    let trackTodayButton = UIButton()
    let deleteHabbitButton = UIButton()
    
    var habit: HabitVM
    
    init(habit: HabitVM) {
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
        deleteHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(graph)
        view.addSubview(trackTodayButton)
        view.addSubview(deleteHabbitButton)
        
        NSLayoutConstraint.activate(
[
            graph.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
            graph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graph.heightAnchor
                .constraint(equalToConstant: HabitGraphUI.graphPartHeight),
            
            trackTodayButton.topAnchor
                .constraint(equalTo: graph.bottomAnchor, constant: 20),
            trackTodayButton.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 12),
            trackTodayButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -12),
            trackTodayButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteHabbitButton.topAnchor
                .constraint(
                    equalTo: trackTodayButton.bottomAnchor,
                    constant: 20
                ),
            deleteHabbitButton.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 12),
            deleteHabbitButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -12),
            deleteHabbitButton.heightAnchor.constraint(equalToConstant: 50),
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
        deleteHabbitButton.addAction(deleteAction, for: .touchUpInside)
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
        
        var deleteBtnConfiguration = UIButton.Configuration.borderless()
        deleteBtnConfiguration.title = "Delete habbit"
        deleteBtnConfiguration.baseForegroundColor = .systemRed
        deleteHabbitButton.configuration = deleteBtnConfiguration
    }
    
    private func toggleToday() {
        let vm = DayVM(date: Date(),id: UUID())
        
        let interactor = AppContainer.habitsInteractor
        
        Task {
            await interactor.toggleTrack(day: vm, forHabit: habit)
            
            let newHabit = await interactor.refetchHabit(habit: habit)
            if let newHabit = newHabit {
                await MainActor.run {
                    habit = newHabit
                    graph.set(habit: newHabit)
                }
            }
        }
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
