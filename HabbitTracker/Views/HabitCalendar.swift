//
//  HabitCalendar.swift
//  HabbitTracker
//
//  Created by Ruslan Khamitov on 16.04.2025.
//

import SwiftUI
import Foundation

enum DayState {
    case lastMonth
    case nextMonth
    case currentMonth
}

struct Day: Identifiable {
    let dayNumber: String
    let state: DayState
    let date: Date
    let isFuture: Bool
    let id = UUID()
    
    init(date: Date, dayState: DayState, isFuture: Bool) {
        self.date = date
        self.state = dayState
        self.dayNumber = date.formatted(.dateTime.day())
        self.isFuture = isFuture
    }
    
    var isEnabled: Bool {
        state == .currentMonth
    }
}

func getFirstDayOfMonth(month: Int, year: Int) -> Date? {
    let calendar = Calendar.current
    
    var dateComponents = DateComponents()
    dateComponents.day = 1
    dateComponents.month = month
    dateComponents.year = year
    
    let date = calendar.date(from: dateComponents)
    
    guard let date else {
        return nil
    }
    
    return calendar.startOfDay(for: date)
}

func getMonthDayAmount(month: Int, year: Int) -> Int {
    var calendar = Calendar.current
    let components = DateComponents(year: year, month: month)
    let date = calendar.date(from: components)!
    return calendar.range(of: .day, in: .month, for: date)!.count
}

func getLastDayOfMonth(month: Int, year: Int) -> Date? {
    let calendar = Calendar.current
    
    var dateComponents = DateComponents()
    let lastDayOfMonth = getMonthDayAmount(month: month, year: year)
    dateComponents.day = lastDayOfMonth + 1
    dateComponents.month = month
    dateComponents.year = year
    
    let result = calendar.date(from: dateComponents)
    
    return result
}

func generateMonth(month: Int, year: Int) -> [Day] {
    var calendar = Calendar.current
    calendar.firstWeekday = 2 // monday is 2, because by default sunday is 1
    
    let firstDayOfMonth = getFirstDayOfMonth(month: month, year: year)
    let lastDayOfMonth = getLastDayOfMonth(month: month, year: year)
    guard let firstDayOfMonth, let lastDayOfMonth else {
        return []
    }
    
    let firstWeek = calendar.dateInterval(of: .weekOfYear, for: firstDayOfMonth)
    let lastWeek = calendar.dateInterval(of: .weekOfYear, for: lastDayOfMonth)
    
    guard let firstWeek, let lastWeek else {
        return []
    }
    
    let startDate = calendar.startOfDay(for: firstWeek.start)
    let endDate = calendar.date(byAdding: .day, value: -1, to: lastWeek.end)
    guard let endDate else {
        return []
    }
    
    var dates: [Date] = []
    var currentDate = startDate
    while (currentDate <= endDate) {
        dates.append(currentDate)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            break
        }
        currentDate = nextDate
    }
    
    let now = Date.now
    return dates.map { day in
        var state = DayState.currentMonth
        if (day < firstDayOfMonth) {
            state = .lastMonth
        }
        if (day >= lastDayOfMonth) {
            state = .nextMonth
        }
        return Day(date: day, dayState: state, isFuture: day > now)
    }
}

struct HabitCalendar: View {
    @State var daysInMonth: [Day] = []
    @State var month = 4
    @State var year = 2025
    @State var selectedDates = Set<Date>()
    
    var previousDates = [Date]()
    
    init(previousDates: [Date]) {
        self.previousDates = previousDates
    }
    
    var monthStr: String {
        switch month {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return "October"
        }
    }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    func decreaseMonth() {
        if (month == 1) {
            year -= 1
            month = 12
        } else {
            month -= 1
        }
        
        updateDaysInMonth()
    }
    
    func increaseMonth() {
        if (month == 12) {
            month = 1
            year += 1
        } else {
            month += 1
        }
        
        updateDaysInMonth()
    }
    
    func updateDaysInMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            daysInMonth = generateMonth(month: month, year: year)
        }
        
    }
    
    var body: some View {
        Group {
            HStack {
                
            }.frame(height: 50, alignment: .trailing)
            HStack {
                Button(action: {
                    decreaseMonth()
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text("\(monthStr) \(String(year))")
                
                Spacer()
                
                Button(action: {
                    increaseMonth()
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            HStack {
                ForEach(
                    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                    id: \.self
                ) { dayOfWeek in
                    Text(dayOfWeek)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    
                }
            }
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysInMonth) { day in
                    DayView(
                        selectedDates: $selectedDates,
                        day: day,
                        onNextMonthClick: { increaseMonth() },
                        onPrevMonthClick: { decreaseMonth() }
                    )
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 10)
        .onAppear {
            let today = Date.now
            var components = Calendar.current.dateComponents(
                [.month, .year],
                from: today
            )
            guard let month = components.month, let year = components.year else {
                return
            }
            
            daysInMonth = generateMonth(month: month, year: year)
            
            previousDates.forEach { date in
                selectedDates.insert(date)
            }
        }
    }
}

#Preview {
    HabitCalendar(previousDates: [])
}

struct DayView: View {
    @Binding var selectedDates: Set<Date>
    var day: Day
    var onNextMonthClick: () -> Void
    var onPrevMonthClick: () -> Void
    
    var isSelected: Bool {
        selectedDates.contains(day.date)
    }
    
    var body: some View {
        Text("\(day.dayNumber)")
            .font(.caption)
            .lineLimit(1)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(day.isEnabled ? Color.primary : Color.secondary)
            .background(isSelected ? Color.blue : Color.clear)
            .clipShape(Circle())
            .onTapGesture {
                guard !day.isFuture else {
                    return
                }
                
                guard day.state == .currentMonth else {
                    if (day.state == .lastMonth) {
                        onPrevMonthClick()
                    } else {
                        onNextMonthClick()
                    }
                    
                    return
                }
                
                if isSelected {
                    selectedDates.remove(day.date)
                } else {
                    selectedDates.insert(day.date)
                }
            }
    }
}
