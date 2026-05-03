// DashboardView.swift
// Növera — Apple Award Level Premium Dashboard

import SwiftUI

struct DashboardView: View {
    @StateObject private var vm = DashboardViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showAddShift = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Animated background
                AnimatedGradientBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NSpacing.xl) {
                        // Header
                        headerSection
                            .padding(.horizontal, NSpacing.lg)
                            .entrance(delay: 0)

                        // Hero shift card
                        if let upcoming = vm.upcomingShift {
                            NavigationLink(destination: ShiftDetailView(shift: upcoming)) {
                                HeroShiftCard(shift: upcoming)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, NSpacing.base)
                            .entrance(delay: 0.05)
                        }

                        // Metric cards grid
                        statCardsGrid
                            .padding(.horizontal, NSpacing.base)

                        // Weekly chart
                        weeklyChartSection
                            .padding(.horizontal, NSpacing.base)
                            .entrance(delay: 0.20)

                        // Earnings preview
                        earningsPreview
                            .padding(.horizontal, NSpacing.base)
                            .entrance(delay: 0.25)

                        // Today's shifts
                        if !vm.todayShifts.isEmpty {
                            todayShiftsSection
                                .padding(.horizontal, NSpacing.base)
                                .entrance(delay: 0.30)
                        }

                        // Announcements
                        if !vm.recentAnnouncements.isEmpty {
                            announcementsSection
                                .padding(.horizontal, NSpacing.base)
                                .entrance(delay: 0.35)
                        }

                        // Bottom spacer for tab bar
                        Spacer(minLength: 120)
                    }
                    .padding(.top, NSpacing.sm)
                }

                // FAB
                PremiumFAB(icon: "plus") {
                    showAddShift = true
                }
                .padding(.trailing, NSpacing.xl)
                .padding(.bottom, 100) // Above tab bar
            }
            .navigationBarHidden(true)
            .onAppear { vm.loadData() }
            .sheet(isPresented: $showAddShift, onDismiss: { vm.loadData() }) {
                AddShiftView()
            }
        }
    }

    // MARK: - Header
    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: NSpacing.xs) {
                Text(vm.greetingText)
                    .font(NFont.callout(.medium))
                    .foregroundStyle(NColor.textSecondary)

                Text(vm.userName)
                    .font(NFont.largeTitle(.bold))
                    .foregroundStyle(NColor.textPrimary)

                Text(vm.todayDateString)
                    .font(NFont.footnote())
                    .foregroundStyle(NColor.textTertiary)
            }

            Spacer()

            NavigationLink(destination: ProfileView()) {
                ZStack {
                    Circle()
                        .fill(NColor.primaryGradient)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.4), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .nShadow(.glow)

                    Text(vm.currentUser?.initials ?? "?")
                        .font(NFont.headline(.bold))
                        .foregroundStyle(.white)
                }
            }
        }
    }

    // MARK: - Stat Cards Grid
    var statCardsGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: NSpacing.md
        ) {
            PremiumMetricCard(
                title: "Haftalık Saat",
                value: vm.weeklyHoursFormatted,
                icon: "clock.fill",
                color: NColor.primaryFallback,
                subtitle: "Bu hafta",
                trend: vm.weeklyHours > 40 ? .up : .neutral,
                trendValue: vm.weeklyHours > 40 ? "+FZ" : nil
            )
            .entrance(delay: 0.08)

            PremiumMetricCard(
                title: "Aylık Nöbet",
                value: "\(vm.monthlyShiftCount)",
                icon: "calendar.badge.clock",
                color: NColor.accent,
                subtitle: "Bu ay"
            )
            .entrance(delay: 0.11)

            PremiumMetricCard(
                title: "Tahmini FZ",
                value: vm.overtimeFormatted,
                icon: "clock.badge.plus",
                color: NColor.shiftOvertime,
                subtitle: "Fazla mesai",
                trend: vm.estimatedOvertime > 0 ? .up : .neutral,
                trendValue: vm.estimatedOvertime > 0 ? "Var" : nil
            )
            .entrance(delay: 0.14)

            PremiumMetricCard(
                title: "Bugün",
                value: vm.todayShifts.isEmpty ? "Serbest" : "\(vm.todayShifts.count) Nöbet",
                icon: vm.todayShifts.isEmpty ? "sun.horizon.fill" : "stethoscope",
                color: vm.todayShifts.isEmpty ? NColor.success : NColor.shiftDay,
                subtitle: "Durum"
            )
            .entrance(delay: 0.17)
        }
    }

    // MARK: - Weekly Chart
    var weeklyChartSection: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            PremiumSectionHeader(title: "Bu Hafta", subtitle: "Çalışma saatleri dağılımı")

            PremiumGlassCard {
                PremiumBarChart(
                    data: vm.weeklyData.map { ($0.day, $0.hours) },
                    maxValue: 12,
                    color: NColor.primaryFallback,
                    height: 80
                )
            }
        }
    }

    // MARK: - Earnings Preview
    var earningsPreview: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            PremiumSectionHeader(
                title: "Tahmini Kazanç",
                action: { appState.selectedTab = .earnings },
                actionTitle: "Detay"
            )

            EarningsProgressCard(
                currentAmount: vm.estimatedMonthlyEarnings,
                targetAmount: vm.targetMonthlyEarnings
            )
        }
    }

    // MARK: - Today Shifts
    var todayShiftsSection: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            PremiumSectionHeader(
                title: "Bugünkü Nöbetler",
                subtitle: "\(vm.todayShifts.count) vardiya"
            )

            ForEach(vm.todayShifts) { shift in
                NavigationLink(destination: ShiftDetailView(shift: shift)) {
                    PremiumShiftCard(shift: shift, isCompact: true)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Announcements
    var announcementsSection: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            PremiumSectionHeader(
                title: "Ekip Duyuruları",
                action: { appState.selectedTab = .teams },
                actionTitle: "Tümü"
            )

            ForEach(vm.recentAnnouncements) { announcement in
                PremiumAnnouncementRow(announcement: announcement)
            }
        }
    }
}

// MARK: - Premium Announcement Row
struct PremiumAnnouncementRow: View {
    let announcement: Announcement

    var body: some View {
        HStack(spacing: NSpacing.md) {
            Soft3DIcon(icon: "megaphone.fill", size: .small, color: NColor.primaryFallback)

            VStack(alignment: .leading, spacing: 2) {
                Text(announcement.title)
                    .font(NFont.subheadline(.semibold))
                    .foregroundStyle(NColor.textPrimary)
                    .lineLimit(1)
                Text(announcement.message)
                    .font(NFont.caption())
                    .foregroundStyle(NColor.textSecondary)
                    .lineLimit(2)
                Text(announcement.createdByName + " • " + announcement.createdAt.dayFormatted)
                    .font(NFont.caption2())
                    .foregroundStyle(NColor.textTertiary)
            }
        }
        .premiumGlass(radius: NRadius.medium, padding: NSpacing.md)
        .pressEffect()
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
        .environmentObject(AuthService())
}
