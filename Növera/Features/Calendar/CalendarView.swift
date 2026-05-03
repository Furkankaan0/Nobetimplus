// CalendarView.swift
// Növera — Premium Shift Calendar

import SwiftUI

struct CalendarView: View {
    @StateObject private var vm = CalendarViewModel()
    @State private var showAddShift = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                calendarHeader
                    .padding(.horizontal, NSpacing.base)
                    .padding(.top, NSpacing.base)

                // Mode Picker
                premiumModePicker
                    .padding(.horizontal, NSpacing.base)
                    .padding(.top, NSpacing.md)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NSpacing.base) {
                        if vm.viewMode == .monthly {
                            monthlyCalendarGrid
                                .padding(.horizontal, NSpacing.base)
                                .padding(.top, NSpacing.base)
                                .entrance(delay: 0.05)
                        }

                        selectedDaySection
                            .padding(.horizontal, NSpacing.base)
                            .entrance(delay: 0.10)

                        Spacer(minLength: 120)
                    }
                }
            }
            .screenBackground()
            .navigationBarHidden(true)
            .onAppear { vm.loadMonth() }
            .sheet(isPresented: $showAddShift, onDismiss: { vm.loadMonth() }) {
                AddShiftView(preselectedDate: vm.selectedDate)
            }
        }
    }

    // MARK: - Header
    var calendarHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Takvim")
                    .font(NFont.largeTitle(.bold))
                    .foregroundStyle(NColor.textPrimary)
                Text(vm.displayedMonthTitle)
                    .font(NFont.callout())
                    .foregroundStyle(NColor.textSecondary)
            }
            Spacer()
            HStack(spacing: NSpacing.sm) {
                PremiumIconButton(icon: "chevron.left") { vm.navigateMonth(by: -1) }
                PremiumIconButton(icon: "chevron.right") { vm.navigateMonth(by: 1) }
                PremiumIconButton(icon: "plus", color: NColor.primaryFallback) { showAddShift = true }
            }
        }
    }

    // MARK: - Glass Mode Picker
    var premiumModePicker: some View {
        HStack(spacing: 0) {
            ForEach(CalendarViewMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(NMotion.snappy) { vm.viewMode = mode }
                    HapticManager.selection()
                }) {
                    Text(mode.rawValue)
                        .font(NFont.subheadline(.medium))
                        .foregroundStyle(vm.viewMode == mode ? .white : NColor.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(
                            RoundedRectangle(cornerRadius: NRadius.small - 2, style: .continuous)
                                .fill(vm.viewMode == mode ? NColor.primaryFallback : .clear)
                        )
                }
            }
        }
        .padding(4)
        .premiumGlass(radius: NRadius.small, padding: 0)
    }

    // MARK: - Monthly Grid
    var monthlyCalendarGrid: some View {
        VStack(spacing: 4) {
            HStack {
                ForEach(["Pt", "Sa", "Ça", "Pe", "Cu", "Ct", "Pz"], id: \.self) { day in
                    Text(day)
                        .font(NFont.caption(.semibold))
                        .foregroundStyle(NColor.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 4)

            let days = vm.daysInDisplayedMonth
            let offset = vm.firstWeekdayOffset

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                ForEach(0..<offset, id: \.self) { _ in
                    Color.clear.frame(height: 52)
                }
                ForEach(days, id: \.self) { date in
                    PremiumCalendarDayCell(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: vm.selectedDate),
                        isToday: date.isToday,
                        shiftCount: vm.shiftDensity(for: date),
                        shifts: vm.shiftsForDate(date)
                    )
                    .onTapGesture {
                        HapticManager.selection()
                        vm.selectDate(date)
                    }
                }
            }
        }
        .premiumGlass(radius: NRadius.large, padding: NSpacing.base)
    }

    // MARK: - Selected Day
    var selectedDaySection: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            HStack {
                Text(vm.selectedDateTitle)
                    .font(NFont.title3(.bold))
                    .foregroundStyle(NColor.textPrimary)
                Spacer()
                PremiumIconButton(icon: "plus.circle.fill", color: NColor.primaryFallback) {
                    showAddShift = true
                }
            }

            if vm.shiftsForSelectedDate.isEmpty {
                PremiumEmptyState(
                    icon: "calendar.badge.plus",
                    title: "Bu gün serbest",
                    subtitle: "Vardiya eklemek için + butonuna basın",
                    actionTitle: "Vardiya Ekle"
                ) { showAddShift = true }
            } else {
                ForEach(vm.shiftsForSelectedDate) { shift in
                    NavigationLink(destination: ShiftDetailView(shift: shift)) {
                        PremiumShiftCard(shift: shift)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Premium Calendar Day Cell
struct PremiumCalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let shiftCount: Int
    let shifts: [Shift]

    @Environment(\.colorScheme) var colorScheme

    var dayNumber: String {
        Calendar.current.component(.day, from: date).description
    }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(NColor.primaryGradient)
                        .frame(width: 36, height: 36)
                        .shadow(color: NColor.primaryFallback.opacity(0.3), radius: 6, x: 0, y: 2)
                } else if isToday {
                    Circle()
                        .strokeBorder(NColor.primaryFallback, lineWidth: 1.5)
                        .frame(width: 36, height: 36)
                }

                Text(dayNumber)
                    .font(NFont.subheadline(isToday || isSelected ? .bold : .regular))
                    .foregroundStyle(
                        isSelected ? .white :
                        isToday ? NColor.primaryFallback :
                        NColor.textPrimary
                    )
            }

            if shiftCount > 0 {
                HStack(spacing: 2) {
                    ForEach(0..<min(shiftCount, 3), id: \.self) { idx in
                        Circle()
                            .fill(
                                idx < shifts.count
                                ? shifts[idx].shiftType.color
                                : NColor.primaryFallback
                            )
                            .frame(width: 5, height: 5)
                    }
                }
            }
        }
        .frame(height: 52)
        .accessibilityLabel("\(dayNumber), \(shiftCount) vardiya")
    }
}

#Preview {
    CalendarView()
        .environmentObject(AppState())
}
