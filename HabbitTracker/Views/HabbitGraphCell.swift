//
//  HabbitGraphCell.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 08.04.2025.
//

import UIKit

class HabbitGraphCell: UICollectionViewCell {
    static let reuseId = "habbit-graph-cell"
    
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
}
