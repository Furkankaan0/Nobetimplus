// Soft3DIcon.swift
// Növera — Premium 3D Icon Component

import SwiftUI

// MARK: - Soft 3D Icon
struct Soft3DIcon: View {
    let icon: String
    var size: IconSize = .medium
    var color: Color = NColor.primaryFallback
    var secondaryColor: Color? = nil

    enum IconSize: CGFloat {
        case small = 32
        case medium = 48
        case large = 72
        case hero = 100

        var iconScale: CGFloat {
            switch self {
            case .small: return 0.44
            case .medium: return 0.42
            case .large: return 0.40
            case .hero: return 0.38
            }
        }

        var glowRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 14
            case .large: return 22
            case .hero: return 35
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 14
            case .large: return 20
            case .hero: return 28
            }
        }
    }

    @Environment(\.colorScheme) var colorScheme

    var computedSecondary: Color {
        secondaryColor ?? color.opacity(0.7)
    }

    var body: some View {
        ZStack {
            // Glow layer
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .fill(color.opacity(0.15))
                .frame(width: size.rawValue, height: size.rawValue)
                .blur(radius: size.glowRadius)

            // Glass container
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(colorScheme == .dark ? 0.18 : 0.12),
                            color.opacity(colorScheme == .dark ? 0.06 : 0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size.rawValue, height: size.rawValue)
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    color.opacity(colorScheme == .dark ? 0.30 : 0.40),
                                    color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )

            // Icon
            Image(systemName: icon)
                .font(.system(size: size.rawValue * size.iconScale, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, computedSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            // Base gradient
            Group {
                if colorScheme == .dark {
                    NColor.heroGradientDark
                } else {
                    NColor.heroGradientLight
                }
            }
            .ignoresSafeArea()

            // Floating blobs (only when reduce motion is off)
            if !reduceMotion {
                // Blob 1 — top left
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                NColor.primaryFallback.opacity(colorScheme == .dark ? 0.08 : 0.06),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 160
                        )
                    )
                    .frame(width: 320, height: 320)
                    .offset(
                        x: animate ? -90 : -70,
                        y: animate ? -180 : -200
                    )

                // Blob 2 — bottom right
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                NColor.accent.opacity(colorScheme == .dark ? 0.06 : 0.04),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .offset(
                        x: animate ? 110 : 90,
                        y: animate ? 280 : 310
                    )

                // Blob 3 — top right accent
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                NColor.accentSecondary.opacity(colorScheme == .dark ? 0.05 : 0.03),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .offset(
                        x: animate ? 120 : 100,
                        y: animate ? -320 : -300
                    )
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(
                Animation.easeInOut(duration: 10).repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
}

// MARK: - Premium Toast
struct PremiumToast: View {
    enum ToastType {
        case success, error, warning, info

        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .success: return NColor.success
            case .error: return NColor.danger
            case .warning: return NColor.warning
            case .info: return NColor.info
            }
        }
    }

    let message: String
    let type: ToastType
    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            HStack(spacing: NSpacing.sm) {
                Image(systemName: type.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(type.color)

                Text(message)
                    .font(NFont.subheadline(.medium))
                    .foregroundStyle(NColor.textPrimary)
                    .lineLimit(2)

                Spacer()

                Button(action: {
                    withAnimation(NMotion.snappy) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(NColor.textTertiary)
                }
            }
            .padding(NSpacing.base)
            .premiumGlass(radius: NRadius.medium, padding: 0)
            .padding(.horizontal, NSpacing.base)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(NMotion.snappy) {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview("Soft3DIcon Sizes") {
    HStack(spacing: 20) {
        Soft3DIcon(icon: "stethoscope", size: .small, color: NColor.shiftDay)
        Soft3DIcon(icon: "moon.stars.fill", size: .medium, color: NColor.shiftNight)
        Soft3DIcon(icon: "clock.fill", size: .large, color: NColor.primaryFallback)
        Soft3DIcon(icon: "heart.fill", size: .hero, color: NColor.danger)
    }
    .padding(40)
    .background(NColor.background)
}

#Preview("Animated Background") {
    AnimatedGradientBackground()
}
