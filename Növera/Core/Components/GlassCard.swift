// GlassCard.swift
// Növera — Glass Card & Surface Components

import SwiftUI

// MARK: - Glass Card
struct GlassCard<Content: View>: View {
    let content: () -> Content
    var cornerRadius: CGFloat = NoveraRadius.lg
    var padding: CGFloat = NoveraSpacing.md
    var shadowStyle: ShadowStyle = NoveraShadows.soft

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        content()
            .padding(padding)
            .glassBackground(cornerRadius: cornerRadius)
            .noveraShadow(shadowStyle)
    }
}

// MARK: - Metric Card (for Dashboard stats)
struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    var trend: TrendDirection?
    var trendValue: String?

    enum TrendDirection {
        case up, down, neutral
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }
        var color: Color {
            switch self {
            case .up: return NoveraColors.success
            case .down: return NoveraColors.error
            case .neutral: return NoveraColors.textSecondary
            }
        }
    }

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: NoveraSpacing.sm) {
            HStack {
                // Icon badge with 3D glow
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.2), color.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(color)
                        .shadow(color: color.opacity(0.5), radius: 5, x: 0, y: 2)
                }

                Spacer()

                if let trend, let trendValue {
                    HStack(spacing: 3) {
                        Image(systemName: trend.icon)
                            .font(.system(size: 11, weight: .bold))
                        Text(trendValue)
                            .font(NoveraFonts.caption(.bold))
                    }
                    .foregroundStyle(trend.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(trend.color.opacity(0.12))
                            .overlay(
                                Capsule().stroke(trend.color.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(NoveraFonts.display(34))
                    .foregroundStyle(NoveraColors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .contentTransition(.numericText())
                    .animation(NoveraAnimation.spring, value: value)

                Text(title)
                    .font(NoveraFonts.footnote(.medium))
                    .foregroundStyle(NoveraColors.textSecondary)
            }
            .padding(.top, NoveraSpacing.xs)

            if let subtitle {
                Text(subtitle)
                    .font(NoveraFonts.caption())
                    .foregroundStyle(NoveraColors.textTertiary)
            }
        }
        .padding(NoveraSpacing.md)
        .glassBackground(cornerRadius: NoveraRadius.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

// MARK: - Shift Preview Card
struct ShiftPreviewCard: View {
    let shift: Shift
    var isCompact: Bool = false
    
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            // Handle tap action externally or add navigation
        }) {
            HStack(spacing: NoveraSpacing.md) {
                // Color strip + type icon with glow
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(shift.shiftType.color)
                        .frame(width: 4)
                        .shadow(color: shift.shiftType.color.opacity(0.6), radius: 4, x: 0, y: 0)
                }
                .frame(height: isCompact ? 50 : 70)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(shift.title)
                            .font(NoveraFonts.headline(.bold))
                            .foregroundStyle(NoveraColors.textPrimary)
                        Spacer()
                        ShiftTypeBadge(type: shift.shiftType)
                    }

                    HStack(spacing: NoveraSpacing.sm) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(shift.shiftType.color)
                        Text(shift.timeRangeFormatted)
                            .font(NoveraFonts.subheadline(.medium))
                            .foregroundStyle(NoveraColors.textSecondary)
                    }

                    if !isCompact {
                        HStack(spacing: NoveraSpacing.sm) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(NoveraColors.textTertiary)
                            Text(shift.location)
                                .font(NoveraFonts.caption())
                                .foregroundStyle(NoveraColors.textTertiary)
                        }
                    }
                }
            }
            .padding(NoveraSpacing.md)
            .glassBackground(cornerRadius: NoveraRadius.lg)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .shadow(color: Color.black.opacity(isPressed ? 0.05 : 0.15), radius: isPressed ? 8 : 20, x: 0, y: isPressed ? 4 : 10)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        withAnimation(NoveraAnimation.springFast) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(NoveraAnimation.springBouncy) {
                        isPressed = false
                    }
                }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(shift.title), \(shift.timeRangeFormatted), \(shift.location)")
    }
}

// MARK: - Shift Type Badge
struct ShiftTypeBadge: View {
    let type: ShiftType

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: type.icon)
                .font(.system(size: 10, weight: .semibold))
            Text(type.displayName)
                .font(NoveraFonts.caption(.semibold))
        }
        .foregroundStyle(type.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(type.color.opacity(0.15))
        )
    }
}

// MARK: - Section Header
struct NoveraSectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var action: (() -> Void)? = nil
    var actionTitle: String = "Tümü"

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(NoveraFonts.title3(.semibold))
                    .foregroundStyle(NoveraColors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(NoveraFonts.caption())
                        .foregroundStyle(NoveraColors.textSecondary)
                }
            }
            Spacer()
            if let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(NoveraFonts.subheadline(.medium))
                        .foregroundStyle(NoveraColors.primary)
                }
                .accessibilityLabel("\(title) - \(actionTitle)")
            }
        }
    }
}

// MARK: - Empty State View
struct NoveraEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    @State private var iconScale: CGFloat = 1.0
    @State private var iconOpacity: Double = 0.7

    var body: some View {
        VStack(spacing: NoveraSpacing.lg) {
            ZStack {
                Circle()
                    .fill(NoveraColors.primary.opacity(0.08))
                    .frame(width: 100, height: 100)

                Circle()
                    .fill(NoveraColors.primary.opacity(0.05))
                    .frame(width: 130, height: 130)

                Image(systemName: icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(NoveraColors.primary.opacity(0.6))
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
            }
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
                ) {
                    iconScale = 1.05
                    iconOpacity = 1.0
                }
            }

            VStack(spacing: NoveraSpacing.xs) {
                Text(title)
                    .font(NoveraFonts.title3(.semibold))
                    .foregroundStyle(NoveraColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(NoveraFonts.callout())
                    .foregroundStyle(NoveraColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, NoveraSpacing.xl)
            }

            if let actionTitle, let action {
                NoveraPrimaryButton(actionTitle, isFullWidth: false, action: action)
            }
        }
        .padding(NoveraSpacing.xl)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            MetricCard(
                title: "Bu Hafta",
                value: "42s",
                subtitle: "Normal 40s",
                icon: "clock.fill",
                color: NoveraColors.primary,
                trend: .up,
                trendValue: "+2s"
            )

            NoveraEmptyState(
                icon: "calendar.badge.plus",
                title: "Henüz vardiya yok",
                subtitle: "İlk vardiyenizi ekleyerek başlayın",
                actionTitle: "Vardiya Ekle",
                action: {}
            )
        }
        .padding()
    }
}
