// NoveraButton.swift
// Növera — Premium Button Components

import SwiftUI

// MARK: - Primary Button
struct NoveraPrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    var isFullWidth: Bool = true

    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.action = action
    }

    var body: some View {
        Button(action: {
            HapticManager.impact(.medium)
            action()
        }) {
            HStack(spacing: NoveraSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(NoveraFonts.headline(.semibold))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: 54)
            .padding(.horizontal, isFullWidth ? 0 : NoveraSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: NoveraRadius.md, style: .continuous)
                    .fill(NoveraColors.primaryGradient)
            )
            .premium3DDepth(cornerRadius: NoveraRadius.md)
            .noveraShadow(NoveraShadows.primary)
        }
        .scaleOnPress()
        .disabled(isLoading)
        .accessibilityLabel(title)
        .accessibilityHint("Butona basarak devam edin")
    }
}

// MARK: - Secondary Button
struct NoveraSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isFullWidth: Bool = true

    init(
        _ title: String,
        icon: String? = nil,
        isFullWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isFullWidth = isFullWidth
        self.action = action
    }

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            HStack(spacing: NoveraSpacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(NoveraFonts.headline(.semibold))
            }
            .foregroundStyle(NoveraColors.primary)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: 54)
            .padding(.horizontal, isFullWidth ? 0 : NoveraSpacing.lg)
            .glassBackground(cornerRadius: NoveraRadius.md, opacity: 0.15)
        }
        .scaleOnPress()
        .accessibilityLabel(title)
    }
}

// MARK: - Ghost Button
struct NoveraGhostButton: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            Text(title)
                .font(NoveraFonts.callout(.medium))
                .foregroundStyle(NoveraColors.textSecondary)
                .frame(height: 44)
                .padding(.horizontal, NoveraSpacing.md)
        }
        .scaleOnPress()
        .accessibilityLabel(title)
    }
}

// MARK: - Icon Button
struct NoveraIconButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let action: () -> Void

    init(
        icon: String,
        size: CGFloat = 44,
        color: Color = NoveraColors.primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: size, height: size)
                .glassBackground(cornerRadius: size / 2, opacity: 0.1)
        }
        .scaleOnPress()
        .accessibilityLabel(icon)
    }
}

// MARK: - FAB (Floating Action Button)
struct NoveraFAB: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.impact(.heavy)
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(NoveraColors.primaryGradient)
                )
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .noveraShadow(NoveraShadows.primary)
                // Extra glow effect
                .shadow(color: NoveraColors.primary.opacity(0.4), radius: 30, x: 0, y: 15)
        }
        .scaleOnPress()
        .accessibilityLabel("Yeni ekle")
    }
}

#Preview {
    VStack(spacing: 20) {
        NoveraPrimaryButton("Başla", icon: "arrow.right") {}
        NoveraSecondaryButton("Pro'yu Keşfet", icon: "star.fill") {}
        NoveraGhostButton("Atla") {}
        NoveraFAB(icon: "plus") {}
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
