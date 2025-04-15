//
//  HabbitGraphMainPageCell.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 11.04.2025.
//

import UIKit

protocol HabitGraphMainPageCellDelegate: AnyObject {
    func navigateTo(habit: HabitVM) -> Void
}

class HabitGraphMainPageCell: UICollectionViewCell {
    static let reuseId = "HabbitGraph"
    
    var title = UILabel()
    var seeButton = UIButton()
    var stack = UIStackView()
    let habbitGraph = HabitGraph()
    
    var habit: HabitVM? = nil
    
    weak var delegate: HabitGraphMainPageCellDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureComponents()
        configureLayout()
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureComponents() {
        let action = UIAction { [weak self] _ in
            self?.onSeeMoreTapped()
        }
        seeButton.addAction(action, for: .touchUpInside)
    }
    
    private func configureLayout() {
        habbitGraph.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        seeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(stack)
        addSubview(habbitGraph)
        
        // Stack
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(seeButton)
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        
        let padding: CGFloat = 12
        
        let graphPartHeight = HabitGraphUI.graphPartHeight
        let titleHeight = HabitGraphUI.titleHeight
        let paddingBetweenTitle = HabitGraphUI.titlePadding
        
        NSLayoutConstraint.activate(
            [
                stack.topAnchor
                    .constraint(
                        equalTo: topAnchor,
                        constant: paddingBetweenTitle
                    ),
                stack.leadingAnchor
                    .constraint(equalTo: leadingAnchor, constant: padding),
                stack.trailingAnchor
                    .constraint(equalTo: trailingAnchor, constant: -padding),
                stack.heightAnchor.constraint(equalToConstant: titleHeight),
            
            
                habbitGraph.topAnchor
                    .constraint(
                        equalTo: stack.bottomAnchor,
                        constant: paddingBetweenTitle
                    ),
                habbitGraph.leadingAnchor.constraint(equalTo: leadingAnchor),
                habbitGraph.trailingAnchor
                    .constraint(equalTo: trailingAnchor),
                habbitGraph.heightAnchor
                    .constraint(
                        equalToConstant: graphPartHeight
                    ),
                
                seeButton.widthAnchor.constraint(equalToConstant: 85)
            ]
        )
    }
    
    private func stylize() {
        backgroundColor = .systemBackground
        title.font = UIFont.preferredFont(forTextStyle: .title1)
        
        var configuration = UIButton.Configuration.borderless()
        configuration.baseForegroundColor = .systemBlue
        configuration.title = "See"
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        
        seeButton.configuration = configuration
    }
    
    public func set(habit: HabitVM) {
        self.habit = habit
        title.text = habit.name
        habbitGraph.set(habit: habit)
    }
    
    private func onSeeMoreTapped() {
        guard let habit else { return }
        
        delegate?.navigateTo(habit: habit)
    }
}
