//
//  HabbitColorPickerColor.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 08.04.2025.
//

import UIKit
import Combine

class HabbitColorPickerColor: UIView {
    var selectedColor: CurrentValueSubject<HabbitColors, Never>
    let color: HabbitColors
    var cancellables = Set<AnyCancellable>()

    init(color: HabbitColors, selectedColor: CurrentValueSubject<HabbitColors, Never>) {
        self.selectedColor = selectedColor
        self.color = color
        super.init(frame: .zero)
        
        configure()
        stylize(color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func onTap() {
        selectedColor.send(color)
    }
    
    private func stylize(color: HabbitColors) {
        backgroundColor = color.toUIColor()
        self.layer.cornerRadius = 8
        
        selectedColor
            .receive(on: RunLoop.main)
            .map { return $0 == color }
            .sink { [weak self] isCurrentColorSelected in
                guard let self else {return}
                if (isCurrentColorSelected) {
                    self.layer.borderColor = UIColor.label.cgColor
                    self.layer.borderWidth = 2
                } else {
                    self.layer.borderWidth = 0
                }
            }
            .store(in: &cancellables)
    }
}
