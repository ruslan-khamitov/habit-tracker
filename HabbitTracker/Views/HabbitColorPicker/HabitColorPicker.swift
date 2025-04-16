//
//  HabitColorPicker.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 12.04.2025.
//

import SwiftUI
import Combine

struct HabitColorPicker: View {
    let colors: [HabbitColors] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .indigo,
        .purple
    ]
    
    @Binding var selectedColor: HabbitColors
    
    var body: some View {
        HStack {
            Text("Select color:")
            
            Spacer()
            
            HStack {
                ForEach(colors, id: \.rawValue) { color in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(color.toUIColor()))
                        .stroke(Color.black, lineWidth: selectedColor == color ? 1 : 0)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var color = HabbitColors.red
    
    HabitColorPicker(selectedColor: $color)
}
