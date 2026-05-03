// GlassCard.swift
// Növera — Legacy Glass Card Components
// Metric, Shift Preview, and Earnings cards are now in PremiumCards.swift
// This file provides backward compatibility aliases.

import SwiftUI

// Legacy MetricCard → PremiumMetricCard
typealias MetricCard = PremiumMetricCard

// Legacy ShiftPreviewCard → PremiumShiftCard
struct ShiftPreviewCard: View {
    let shift: Shift
    var isCompact: Bool = false

    var body: some View {
        PremiumShiftCard(shift: shift, isCompact: isCompact)
    }
}

// Legacy EarningsProgressCard (still used in Dashboard)
struct EarningsProgressCard: View {
    let currentAmount: Double
    let targetAmount: Double
    let currency: String = "₺"

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: NSpacing.xs) {
                Text("Tahmini Aylık Kazanç")
                    .font(NFont.footnote(.medium))
                    .foregroundStyle(NColor.textSecondary)
                Text("\(currency)\(Int(currentAmount).formatted())")
                    .font(NFont.display(30, .bold))
                    .foregroundStyle(NColor.textPrimary)
                    .contentTransition(.numericText())
            }
            Spacer()
            PremiumRingProgress(progress: progress, color: NColor.success)
        }
        .premiumGlass(radius: NRadius.large, padding: NSpacing.base)
    }
}

// Legacy ShiftTypeBadge (still used across multiple files)
struct ShiftTypeBadge: View {
    let type: ShiftType

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: type.icon)
                .font(.system(size: 10, weight: .bold))
            Text(type.displayName)
                .font(NFont.caption2(.bold))
        }
        .foregroundStyle(type.color)
        .padding(.horizontal, NSpacing.sm)
        .padding(.vertical, 3)
        .background(
            Capsule()
                .fill(type.color.opacity(0.12))
                .overlay(Capsule().stroke(type.color.opacity(0.2), lineWidth: 0.5))
        )
    }
}

// Legacy WeeklyHoursBar (used in old dashboard chart section)
struct WeeklyHoursBar: View {
    let days: [(day: String, hours: Double)]
    var maxHours: Double = 12
    var color: Color = NColor.primaryFallback

    var body: some View {
        PremiumBarChart(
            data: days.map { ($0.day, $0.hours) },
            maxValue: maxHours,
            color: color,
            height: 80
        )
    }
}

// Legacy RingProgress
struct RingProgress: View {
    let progress: Double
    var color: Color = NColor.success
    var lineWidth: CGFloat = 8
    var size: CGFloat = 54

    var body: some View {
        PremiumRingProgress(progress: progress, color: color, lineWidth: lineWidth, size: size)
    }
}
