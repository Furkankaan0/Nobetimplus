// FloatingTabBar.swift
// Növera — Premium Floating Tab Bar

import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab: AppState.TabItem
    @Namespace private var tabAnimation
    @Environment(\.colorScheme) var colorScheme

    private let tabs: [(AppState.TabItem, String, String)] = [
        (.dashboard, "house.fill", "Ana Sayfa"),
        (.calendar, "calendar", "Takvim"),
        (.teams, "person.2.fill", "Ekip"),
        (.earnings, "chart.bar.fill", "Gelir"),
        (.profile, "person.crop.circle.fill", "Profil")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.0) { tab, icon, label in
                tabButton(tab: tab, icon: icon, label: label)
            }
        }
        .padding(.horizontal, NSpacing.sm)
        .padding(.vertical, NSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: NRadius.xlarge, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: NRadius.xlarge, style: .continuous)
                        .fill(
                            colorScheme == .dark
                            ? Color.white.opacity(0.06)
                            : Color.white.opacity(0.72)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: NRadius.xlarge, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(colorScheme == .dark ? 0.15 : 0.50),
                                    .clear,
                                    .white.opacity(colorScheme == .dark ? 0.05 : 0.20)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )
                .shadow(
                    color: Color.black.opacity(colorScheme == .dark ? 0.40 : 0.10),
                    radius: 24, x: 0, y: 8
                )
        )
        .padding(.horizontal, NSpacing.lg)
        .padding(.bottom, NSpacing.sm)
    }

    @ViewBuilder
    private func tabButton(tab: AppState.TabItem, icon: String, label: String) -> some View {
        let isActive = selectedTab == tab

        Button(action: {
            guard selectedTab != tab else { return }
            HapticManager.selection()
            withAnimation(NMotion.snappy) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isActive {
                        Capsule()
                            .fill(NColor.primaryGradient)
                            .frame(width: 48, height: 32)
                            .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                            .shadow(color: NColor.primaryFallback.opacity(0.35), radius: 10, x: 0, y: 4)
                    }

                    Image(systemName: icon)
                        .font(.system(size: isActive ? 16 : 18, weight: isActive ? .bold : .medium))
                        .foregroundStyle(
                            isActive
                            ? .white
                            : NColor.textTertiary
                        )
                }
                .frame(height: 32)

                // Pill indicator
                if isActive {
                    Text(label)
                        .font(NFont.caption2(.bold))
                        .foregroundStyle(NColor.primaryFallback)
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        NColor.background
            .ignoresSafeArea()

        FloatingTabBar(selectedTab: .constant(.dashboard))
    }
}
