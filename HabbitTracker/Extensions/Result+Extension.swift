//
//  Result+Extension.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 15.04.2025.
//

import Foundation

extension Result {
    func onSuccess(_ action: (Success) -> Void) {
        if case .success(let value) = self {
            action(value)
        }
    }
}
