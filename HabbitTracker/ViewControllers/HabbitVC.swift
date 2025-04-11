//
//  HabbitVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import UIKit

class HabbitVC: UIViewController {
    let graph: HabbitGraph
    let trackTodayButton = UIButton()
    
    var habbit: HabbitVM
    
    init(habbit: HabbitVM) {
        graph = HabbitGraph()
        graph.set(habbit: habbit)
        
        self.habbit = habbit
        
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
        
        view.addSubview(graph)
        view.addSubview(trackTodayButton)
        
        NSLayoutConstraint.activate([
            graph.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            graph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graph.heightAnchor.constraint(equalToConstant: HabbitGraphUI.totalHeight),
            
            trackTodayButton.topAnchor.constraint(equalTo: graph.bottomAnchor, constant: 20),
            trackTodayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            trackTodayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            trackTodayButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureComponents() {
        graph.setSeeMoreVisibility(to: false)
        
        let action = UIAction { [weak self] _ in
            self?.toggleToday()
        }
        trackTodayButton.addAction(action, for: .touchUpInside)
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
        navigationItem.title = habbit.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Track today"
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        
        trackTodayButton.configuration = configuration
    }
    
    private func toggleToday() {
        let vm = DayVM(date: Date())
        
        let interactor = AppContainer.habbitsInteractor
        
        interactor.toggleTrack(day: vm, forHabbit: habbit)
        
        let newHabbit = interactor.refetchHabbit(habbit: habbit)
        if let newHabbit = newHabbit {
            habbit = newHabbit
            graph.set(habbit: newHabbit)
        }
        
    }
}
