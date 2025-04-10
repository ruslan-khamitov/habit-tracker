//
//  DayVM.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 10.04.2025.
//

import Foundation

struct DayVM: Identifiable, Hashable {
    let date: Date
    let id = UUID()
    
    let tracked: Bool
}
