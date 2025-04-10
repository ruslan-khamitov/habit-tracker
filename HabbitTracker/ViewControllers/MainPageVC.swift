//
//  MainPageVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 07.04.2025.
//

import UIKit

class MainPageVC: UIViewController {
    
    let habbitGraph = HabbitGraph()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        stylize()
        
        let vc = AddHabbitVC()
        present(vc, animated: true)
    }

    private func configureSubviews() {
        habbitGraph.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(habbitGraph)
        
        NSLayoutConstraint.activate([
            habbitGraph.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habbitGraph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habbitGraph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habbitGraph.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
    }
}

