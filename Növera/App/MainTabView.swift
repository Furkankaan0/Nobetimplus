// MainTabView.swift
// Növera — Premium Floating Tab Navigation

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            // Active screen
            Group {
                switch appState.selectedTab {
                case .dashboard:
                    DashboardView()
                case .calendar:
                    CalendarView()
                case .teams:
                    TeamsView()
                case .earnings:
                    EarningsView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Floating Tab Bar
            FloatingTabBar(selectedTab: $appState.selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(AuthService())
}
