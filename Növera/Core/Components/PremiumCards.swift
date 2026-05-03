// PremiumCards.swift
// Növera — Premium Glass Card System

import SwiftUI

// MARK: - Premium Glass Card (Reusable Container)
struct PremiumGlassCard<Content: View>: View {
    var radius: CGFloat = NRadius.large
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .premiumGlass(radius: radius, padding: NSpacing.base)
            .pressEffect()
    }
}

// MARK: - Dashboard Hero Card (Next Shift)
struct HeroShiftCard: View {
    let shift: Shift
    @State private var pulseGlow = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            // Top row: badge + countdown
            HStack {
                HStack(spacing: NSpacing.xs) {
                    Circle()
                        .fill(NColor.success)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .fill(NColor.success.opacity(0.4))
                                .frame(width: 16, height: 16)
                                .opacity(pulseGlow ? 0 : 1)
                                .scaleEffect(pulseGlow ? 2 : 1)
                        )
                    Text("Sıradaki Nöbet")
                        .font(NFont.caption(.semibold))
                        .foregroundStyle(NColor.textSecondary)
                }

                Spacer()

                Text(shift.startDate.dayFormatted)
                    .font(NFont.caption(.bold))
                    .foregroundStyle(NColor.primaryFallback)
                    .padding(.horizontal, NSpacing.sm)
                    .padding(.vertical, NSpacing.xs)
                    .background(
                        Capsule()
                            .fill(NColor.primaryFallback.opacity(0.12))
                    )
            }

            // Main content
            HStack(spacing: NSpacing.base) {
                // Shift info
                VStack(alignment: .leading, spacing: NSpacing.sm) {
                    Text(shift.title)
                        .font(NFont.title2(.bold))
                        .foregroundStyle(NColor.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: NSpacing.sm) {
                        Label(shift.timeRangeFormatted, systemImage: "clock.fill")
                            .font(NFont.subheadline(.medium))
                            .foregroundStyle(shift.shiftType.color)

                        Text("•")
                            .foregroundStyle(NColor.textTertiary)

                        Label(shift.durationInHours.hoursFormatted, systemImage: "hourglass")
                            .font(NFont.subheadline())
                            .foregroundStyle(NColor.textSecondary)
                    }

                    Label(shift.location, systemImage: "mappin.circle.fill")
                        .font(NFont.footnote(.medium))
                        .foregroundStyle(NColor.textTertiary)
                }

                Spacer()

                // 3D shift type icon
                Soft3DIcon(
                    icon: shift.shiftType.icon,
                    size: .large,
                    color: shift.shiftType.color
                )
            }

            // Type badge
            HStack(spacing: NSpacing.sm) {
                ShiftTypeBadge(type: shift.shiftType)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(NColor.textTertiary)
            }
        }
        .premiumGlass(radius: NRadius.large, padding: NSpacing.lg)
        .depth3D(radius: NRadius.large)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
            ) {
                pulseGlow = true
            }
        }
    }
}

// MARK: - Premium Metric Card
struct PremiumMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var subtitle: String? = nil
    var trend: TrendDirection? = nil
    var trendValue: String? = nil

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
            case .up: return NColor.success
            case .down: return NColor.danger
            case .neutral: return NColor.textSecondary
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: NSpacing.md) {
            HStack {
                Soft3DIcon(icon: icon, size: .small, color: color)
                Spacer()
                if let trend, let trendValue {
                    HStack(spacing: 3) {
                        Image(systemName: trend.icon)
                            .font(.system(size: 10, weight: .bold))
                        Text(trendValue)
                            .font(NFont.caption2(.bold))
                    }
                    .foregroundStyle(trend.color)
                    .padding(.horizontal, NSpacing.sm)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(trend.color.opacity(0.12))
                            .overlay(Capsule().stroke(trend.color.opacity(0.2), lineWidth: 0.5))
                    )
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(NFont.display(28, .bold))
                    .foregroundStyle(NColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .contentTransition(.numericText())

                Text(title)
                    .font(NFont.caption(.medium))
                    .foregroundStyle(NColor.textSecondary)
            }

            if let subtitle {
                Text(subtitle)
                    .font(NFont.caption2())
                    .foregroundStyle(NColor.textTertiary)
            }
        }
        .premiumGlass(radius: NRadius.medium, padding: NSpacing.base)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

// MARK: - Premium Shift Preview Card
struct PremiumShiftCard: View {
    let shift: Shift
    var isCompact: Bool = false

    var body: some View {
        HStack(spacing: NSpacing.md) {
            // Color accent strip
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(shift.shiftType.color)
                .frame(width: 4)
                .frame(height: isCompact ? 48 : 64)
                .shadow(color: shift.shiftType.color.opacity(0.5), radius: 4)

            VStack(alignment: .leading, spacing: NSpacing.xs) {
                HStack {
                    Text(shift.title)
                        .font(NFont.headline(.semibold))
                        .foregroundStyle(NColor.textPrimary)
                    Spacer()
                    ShiftTypeBadge(type: shift.shiftType)
                }

                HStack(spacing: NSpacing.sm) {
                    Label(shift.timeRangeFormatted, systemImage: "clock.fill")
                        .font(NFont.caption(.medium))
                        .foregroundStyle(shift.shiftType.color)
                }

                if !isCompact {
                    Label(shift.location, systemImage: "mappin.circle.fill")
                        .font(NFont.caption())
                        .foregroundStyle(NColor.textTertiary)
                }
            }
        }
        .premiumGlass(radius: NRadius.medium, padding: NSpacing.md)
        .pressEffect()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(shift.title), \(shift.timeRangeFormatted)")
    }
}

// MARK: - Mini Bar Chart
struct PremiumBarChart: View {
    let data: [(String, Double)]
    var maxValue: Double
    var color: Color = NColor.primaryFallback
    var height: CGFloat = 80

    @State private var animated = false

    var body: some View {
        HStack(alignment: .bottom, spacing: NSpacing.sm) {
            ForEach(data, id: \.0) { label, value in
                VStack(spacing: NSpacing.xs) {
                    let ratio = maxValue > 0 ? value / maxValue : 0
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.5), color],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: animated ? max(4, height * CGFloat(ratio)) : 4)
                        .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)

                    Text(label)
                        .font(NFont.caption2(.medium))
                        .foregroundStyle(NColor.textTertiary)
                }
            }
        }
        .frame(height: height + 20)
        .onAppear {
            withAnimation(NMotion.bouncy.delay(0.2)) {
                animated = true
            }
        }
    }
}

// MARK: - Ring Progress
struct PremiumRingProgress: View {
    let progress: Double
    var color: Color = NColor.success
    var lineWidth: CGFloat = 8
    var size: CGFloat = 54

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [color.opacity(0.5), color],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)

            Text("\(Int(progress * 100))%")
                .font(NFont.caption2(.bold))
                .foregroundStyle(color)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(NMotion.bouncy.delay(0.3)) {
                animatedProgress = progress
            }
        }
    }
}

#Preview("Hero Card") {
    HeroShiftCard(shift: .preview)
        .padding()
        .background(NColor.background)
}

#Preview("Metric Cards") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        PremiumMetricCard(title: "Haftalık Saat", value: "42s", icon: "clock.fill", color: NColor.primaryFallback, trend: .up, trendValue: "+2")
        PremiumMetricCard(title: "Aylık Nöbet", value: "12", icon: "calendar.badge.clock", color: NColor.accent)
    }
    .padding()
    .background(NColor.background)
}
