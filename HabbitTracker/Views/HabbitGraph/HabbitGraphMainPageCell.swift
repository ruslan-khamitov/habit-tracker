//
//  HabbitGraphMainPageCell.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 11.04.2025.
//

import UIKit

protocol HabbitGraphMainPageCellDelegate: AnyObject {
    func navigateTo(habbit: HabbitVM) -> Void
}

class HabbitGraphMainPageCell: UICollectionViewCell {
    static let reuseId = "HabbitGraph"
    
    var title = UILabel()
    var seeButton = UIButton()
    var stack = UIStackView()
    let habbitGraph = HabbitGraph()
    
    var habbit: HabbitVM? = nil
    
    weak var delegate: HabbitGraphMainPageCellDelegate? = nil
    
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
        
        let graphPartHeight = HabbitGraphUI.graphPartHeight
        let titleHeight = HabbitGraphUI.titleHeight
        let paddingBetweenTitle = HabbitGraphUI.titlePadding
        
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
    
    public func set(habbit: HabbitVM) {
        self.habbit = habbit
        title.text = habbit.name
        habbitGraph.set(habbit: habbit)
    }
    
    private func onSeeMoreTapped() {
        guard let habbit else { return }
        
        delegate?.navigateTo(habbit: habbit)
    }
}
