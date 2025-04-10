//
//  HabbitColorPicker.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 08.04.2025.
//

import UIKit
import Combine

class HabbitColorPicker: UIView {
    let colors: [HabbitColors] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
    
    var colorViews: [HabbitColorPickerColor] = []
    let label = UILabel()
    
    let stack = UIStackView()
    let leftPart = UIStackView()
    let rightPart = UIStackView()
    
    init(selectedColor: CurrentValueSubject<HabbitColors, Never>) {
        super.init(frame: .zero)
        
        for color in colors {
            colorViews.append(HabbitColorPickerColor(color: color, selectedColor: selectedColor))
        }
        
        configureSubviews()
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        leftPart.translatesAutoresizingMaskIntoConstraints = false
        rightPart.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .fillProportionally
        
        stack.addArrangedSubview(leftPart)
        stack.addArrangedSubview(rightPart)
        
        leftPart.axis = .horizontal
        leftPart.spacing = 0
        leftPart.alignment = .leading
        leftPart.distribution = .fill

        let size: CGFloat = 30

        
        label.translatesAutoresizingMaskIntoConstraints = false
        leftPart.addArrangedSubview(label)
        for colorView in colorViews {
            colorView.translatesAutoresizingMaskIntoConstraints = false
            rightPart.addArrangedSubview(colorView)
            
            NSLayoutConstraint.activate([
                colorView.widthAnchor.constraint(equalToConstant: size),
                colorView.heightAnchor.constraint(equalToConstant: size)
            ])
        }
        
        
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    private func stylize() {
        label.text = "Select color:"
    }
    
    
}
