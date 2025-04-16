//
//  HabitGraphCell.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 08.04.2025.
//

import UIKit

class HabitGraphCell: UICollectionViewCell {
    static let reuseId = "habit-graph-cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stylize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func stylize() {
        backgroundColor = .systemGray
    }
    
    public func setNextColor(color: UIColor) {
        guard color != backgroundColor else {
            return
        }
        
        backgroundColor = color
    }
}
