// PremiumButtons.swift
// Növera — Apple Award Level Button Components

import SwiftUI

// MARK: - Premium Primary Button
struct PremiumPrimaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        Button(action: {
            HapticManager.impact(.medium)
            action()
        }) {
            HStack(spacing: NSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(NFont.headline(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: NRadius.medium, style: .continuous)
                    .fill(NColor.primaryGradient)
            )
            .depth3D(radius: NRadius.medium)
            .nShadow(.glow)
        }
        .buttonStyle(PremiumButtonStyle())
        .accessibilityLabel(title)
    }
}

// MARK: - Premium Secondary Button
struct PremiumSecondaryButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            HStack(spacing: NSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                }
                Text(title)
                    .font(NFont.headline(.medium))
            }
            .foregroundStyle(NColor.primaryFallback)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: NRadius.medium, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: NRadius.medium, style: .continuous)
                            .strokeBorder(
                                NColor.primaryFallback.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
            .nShadow(.soft)
        }
        .buttonStyle(PremiumButtonStyle())
        .accessibilityLabel(title)
    }
}

// MARK: - Premium Ghost Button
struct PremiumGhostButton: View {
    let title: String
    var icon: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            HStack(spacing: NSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(NFont.subheadline(.medium))
            }
            .foregroundStyle(NColor.primaryFallback)
            .padding(.horizontal, NSpacing.base)
            .padding(.vertical, NSpacing.sm)
        }
        .buttonStyle(PremiumButtonStyle())
    }
}

// MARK: - Premium FAB
struct PremiumFAB: View {
    let icon: String
    let action: () -> Void

    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.impact(.medium)
            action()
        }) {
            ZStack {
                // Glow
                Circle()
                    .fill(NColor.primaryFallback.opacity(0.25))
                    .frame(width: 64, height: 64)
                    .blur(radius: 12)

                Circle()
                    .fill(NColor.primaryGradient)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.4), .clear, .black.opacity(0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                            .blendMode(.overlay)
                    )
                    .shadow(color: NColor.primaryFallback.opacity(0.4), radius: 16, x: 0, y: 8)

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(PremiumButtonStyle())
        .accessibilityLabel("Ekle")
    }
}

// MARK: - Premium Icon Button
struct PremiumIconButton: View {
    let icon: String
    var color: Color = NColor.textSecondary
    var size: CGFloat = 36
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .fill(color.opacity(colorScheme == .dark ? 0.12 : 0.08))
                    .frame(width: size, height: size)
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                            .strokeBorder(color.opacity(0.15), lineWidth: 0.5)
                    )

                Image(systemName: icon)
                    .font(.system(size: size * 0.38, weight: .semibold))
                    .foregroundStyle(color)
            }
        }
        .buttonStyle(PremiumButtonStyle())
    }
}

// MARK: - Section Header
struct PremiumSectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var action: (() -> Void)? = nil
    var actionTitle: String = "Tümü"

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(NFont.title3(.bold))
                    .foregroundStyle(NColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(NFont.footnote())
                        .foregroundStyle(NColor.textTertiary)
                }
            }
            Spacer()
            if let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(NFont.subheadline(.medium))
                        .foregroundStyle(NColor.primaryFallback)
                }
            }
        }
    }
}

// MARK: - Premium Empty State
struct PremiumEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    @State private var floatAnimation = false

    var body: some View {
        VStack(spacing: NSpacing.lg) {
            Soft3DIcon(icon: icon, size: .hero, color: NColor.primaryFallback)
                .offset(y: floatAnimation ? -6 : 6)
                .animation(
                    Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                    value: floatAnimation
                )

            VStack(spacing: NSpacing.sm) {
                Text(title)
                    .font(NFont.title3(.bold))
                    .foregroundStyle(NColor.textPrimary)
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .font(NFont.callout())
                    .foregroundStyle(NColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            if let actionTitle, let action {
                PremiumPrimaryButton(title: actionTitle, action: action)
                    .frame(maxWidth: 220)
            }
        }
        .padding(NSpacing.xxl)
        .onAppear { floatAnimation = true }
    }
}

// MARK: - Form Field Wrapper
struct PremiumFormField<Content: View>: View {
    let label: String
    var isRequired: Bool = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: NSpacing.sm) {
            HStack(spacing: NSpacing.xs) {
                Text(label)
                    .font(NFont.footnote(.semibold))
                    .foregroundStyle(NColor.textSecondary)
                if isRequired {
                    Text("*")
                        .font(NFont.footnote(.bold))
                        .foregroundStyle(NColor.danger)
                }
            }
            content()
        }
    }
}

#Preview("Buttons") {
    VStack(spacing: 20) {
        PremiumPrimaryButton(title: "Devam Et", icon: "arrow.right") {}
        PremiumSecondaryButton(title: "Pro'yu Keşfet", icon: "star.fill") {}
        PremiumGhostButton(title: "Atla") {}
    }
    .padding(24)
    .background(NColor.background)
}
