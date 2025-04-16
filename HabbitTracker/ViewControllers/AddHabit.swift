//
//  AddHabit.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 12.04.2025.
//

import SwiftUI
import Combine

struct AddHabit: View {
    @Environment(\.dismiss) var dismiss
    @State var habitName = ""
    @State var habitColor = HabbitColors.red
    
    var habbitVM: HabitEntity? = nil
    var afterSave: (() -> Void)? = nil
    
    init(afterSave: (() -> Void)? = nil) {
        self.afterSave = afterSave
    }
    
    init(habitToEdit habit: HabitEntity, afterSave: (() -> Void)? = nil) {
        self.habbitVM = habit
        self.afterSave = afterSave
    }
    
    var isEditing: Bool {
        habbitVM != nil
    }
    
    var isDisabled: Bool {
        habitName.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            HStack {
                Text(isEditing ? "Edit habit" : "Add new habit")
                    .font(.largeTitle)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.gray)
                }
            }
            
            TextField("Enter habbit name", text: $habitName)
            
            HabitColorPicker(selectedColor: $habitColor)
            
            Button(action: isEditing ? editHabit : addHabit) {
                Text(isEditing ? "Update" : "Add").foregroundStyle(Color.white).padding()
                    .frame(maxWidth: .infinity)
            }
            .background(isDisabled ? Color.gray : Color.green)
            .cornerRadius(10)
            .disabled(isDisabled)
            .animation(.easeInOut, value: isDisabled)
        }
        .frame(maxHeight: .infinity, alignment: .top) // Pushes content to the top
        .padding()
        .navigationTitle(isEditing ? "Edit habbit" : "Add new habbit")
        .onAppear {
            if let vm = habbitVM {
                habitName = vm.name
                habitColor = vm.color
            }
        }
    }
    
    private func editHabit() {
        guard let habit = habbitVM else {
            return
        }
        Task {
            let updatedHabit = HabitEntity(id: habit.id, name: habitName, color: habitColor.rawValue)

            await AppContainer.habitsInteractor.updateHabit(habit: updatedHabit)
            
            handleDismiss()
        }
    }
    
    @MainActor
    private func handleDismiss() {
        if let afterSave {
            afterSave()
        }
        dismiss()
    }
    
    private func addHabit() {
        Task {
            await AppContainer.habitsInteractor.createHabit(withName: habitName, andColor: habitColor)
            await AppContainer.habitsInteractor.fetchHabits()
            handleDismiss()
        }
    }
}

#Preview {
    AddHabit()
}
