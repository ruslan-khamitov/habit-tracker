//
//  MainPageVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 07.04.2025.
//

import UIKit

class MainPageVC: UIViewController {
    // Components
    let habbitGraph = HabbitGraph()
    let addHabbitContainer = UIView()
    let addHabbitBtn = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureComponents()
        stylize()
    }

    private func configureSubviews() {
        habbitGraph.translatesAutoresizingMaskIntoConstraints = false
        addHabbitBtn.translatesAutoresizingMaskIntoConstraints = false
        addHabbitContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(habbitGraph)
        
        // Add Habbit container + button
        view.addSubview(addHabbitContainer)
        addHabbitContainer.addSubview(addHabbitBtn)
        
        NSLayoutConstraint.activate([
            habbitGraph.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habbitGraph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habbitGraph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habbitGraph.heightAnchor.constraint(equalToConstant: 136),
            
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
                .constraint(equalTo: addHabbitContainer.bottomAnchor)
        ])
    }
    
    private func configureComponents() {
        let action = UIAction { [weak self] _ in
            self?.addNewHabbit()
        }
        
        addHabbitBtn.addAction(action, for: .touchUpInside)
    }
    
    private func addNewHabbit() {
        let vc = AddHabbitVC()
        present(vc, animated: true)
    }
    
    private func stylize() {
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
}

