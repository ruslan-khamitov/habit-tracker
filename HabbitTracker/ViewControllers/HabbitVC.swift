//
//  HabbitVC.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import UIKit

class HabbitVC: UIViewController {
    let graph: HabbitGraph
    let habbit: HabbitVM
    
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
        
        view.addSubview(graph)
        
        NSLayoutConstraint.activate([
            graph.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            graph.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graph.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graph.heightAnchor.constraint(equalToConstant: HabbitGraphUI.totalHeight),
        ])
    }
    
    private func configureComponents() {
        graph.setSeeMoreVisibility(to: false)
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
        navigationItem.title = habbit.name
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
