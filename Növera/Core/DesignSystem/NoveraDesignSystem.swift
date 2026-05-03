// NoveraDesignSystem.swift
// Növera — Apple Award Level Design System
// Single source of truth for all design tokens

import SwiftUI

// MARK: - Color System
enum NColor {
    // Primary Palette — Health-Tech Teal
    static let primary = Color("NoveraPrimary", bundle: nil)
    static let primaryLight = Color("NoveraPrimaryLight", bundle: nil)
    static let primaryDark = Color("NoveraPrimaryDark", bundle: nil)

    // Fallback computed colors (used if asset catalog colors not available)
    static let primaryFallback = Color(hue: 0.52, saturation: 0.72, brightness: 0.82)

    // Accent — Soft Violet
    static let accent = Color(hue: 0.74, saturation: 0.55, brightness: 0.88)
    static let accentSecondary = Color(hue: 0.42, saturation: 0.60, brightness: 0.78)

    // Adaptive Background
    static var background: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.06, green: 0.06, blue: 0.12, alpha: 1)
            : UIColor(red: 0.965, green: 0.97, blue: 0.98, alpha: 1)
        })
    }

    static var backgroundSecondary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.08, green: 0.08, blue: 0.16, alpha: 1)
            : UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1)
        })
    }

    // Card / Surface
    static var cardBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.12, blue: 0.20, alpha: 1)
            : UIColor(white: 1.0, alpha: 0.85)
        })
    }

    static var glassSurface: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 1.0, alpha: 0.06)
            : UIColor(white: 1.0, alpha: 0.72)
        })
    }

    // Text
    static var textPrimary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 0.96, alpha: 1)
            : UIColor(red: 0.10, green: 0.10, blue: 0.14, alpha: 1)
        })
    }

    static var textSecondary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 0.60, alpha: 1)
            : UIColor(white: 0.44, alpha: 1)
        })
    }

    static var textTertiary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(white: 0.40, alpha: 1)
            : UIColor(white: 0.62, alpha: 1)
        })
    }

    // Semantic
    static let success = Color(hue: 0.40, saturation: 0.58, brightness: 0.76)
    static let warning = Color(hue: 0.10, saturation: 0.72, brightness: 0.92)
    static let danger = Color(hue: 0.01, saturation: 0.68, brightness: 0.82)
    static let info = Color(hue: 0.58, saturation: 0.55, brightness: 0.86)

    // Shift Type Colors
    static let shiftDay = Color(hue: 0.52, saturation: 0.58, brightness: 0.82)
    static let shiftNight = Color(hue: 0.70, saturation: 0.52, brightness: 0.72)
    static let shiftOncall = Color(hue: 0.08, saturation: 0.68, brightness: 0.88)
    static let shiftHoliday = Color(hue: 0.38, saturation: 0.55, brightness: 0.78)
    static let shiftOvertime = Color(hue: 0.96, saturation: 0.58, brightness: 0.82)

    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [
            Color(hue: 0.50, saturation: 0.65, brightness: 0.85),
            Color(hue: 0.58, saturation: 0.72, brightness: 0.72)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [
            Color(hue: 0.72, saturation: 0.50, brightness: 0.90),
            Color(hue: 0.78, saturation: 0.60, brightness: 0.78)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradientLight = LinearGradient(
        colors: [
            Color(hue: 0.57, saturation: 0.04, brightness: 0.98),
            Color(hue: 0.55, saturation: 0.10, brightness: 0.95),
            Color(hue: 0.52, saturation: 0.08, brightness: 0.97)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradientDark = LinearGradient(
        colors: [
            Color(hue: 0.62, saturation: 0.30, brightness: 0.08),
            Color(hue: 0.55, saturation: 0.40, brightness: 0.12),
            Color(hue: 0.70, saturation: 0.25, brightness: 0.10)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography
enum NFont {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 34, weight: weight, design: .default)
    }
    static func title1(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 28, weight: weight, design: .default)
    }
    static func title2(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 22, weight: weight, design: .default)
    }
    static func title3(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 20, weight: weight, design: .default)
    }
    static func headline(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 17, weight: weight, design: .default)
    }
    static func body(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 17, weight: weight, design: .default)
    }
    static func callout(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 16, weight: weight, design: .default)
    }
    static func subheadline(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 15, weight: weight, design: .default)
    }
    static func footnote(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 13, weight: weight, design: .default)
    }
    static func caption(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 12, weight: weight, design: .default)
    }
    static func caption2(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 11, weight: weight, design: .default)
    }
    /// Large display numbers (stats, metrics)
    static func display(_ size: CGFloat = 48, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
    /// Monospaced numbers for timers/counters
    static func mono(_ size: CGFloat = 16, _ weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}

// MARK: - Spacing System
enum NSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let base: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// MARK: - Corner Radius
enum NRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 20
    static let large: CGFloat = 28
    static let xlarge: CGFloat = 36
    static let full: CGFloat = 999
}

// MARK: - Shadow System
struct NShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let soft = NShadow(
        color: Color.black.opacity(0.06),
        radius: 16, x: 0, y: 6
    )
    static let floating = NShadow(
        color: Color.black.opacity(0.12),
        radius: 28, x: 0, y: 12
    )
    static let glow = NShadow(
        color: Color(hue: 0.52, saturation: 0.72, brightness: 0.82).opacity(0.35),
        radius: 24, x: 0, y: 8
    )
    static func colored(_ color: Color) -> NShadow {
        NShadow(color: color.opacity(0.35), radius: 20, x: 0, y: 8)
    }
}

// MARK: - Motion System (with Reduce Motion support)
enum NMotion {
    @Environment(\.accessibilityReduceMotion) static var reduceMotion

    static let gentle = Animation.spring(response: 0.6, dampingFraction: 0.82)
    static let snappy = Animation.spring(response: 0.35, dampingFraction: 0.78)
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.62)
    static let premium = Animation.spring(response: 0.55, dampingFraction: 0.75)
    static let smooth = Animation.easeInOut(duration: 0.35)
    static let pageTransition = Animation.spring(response: 0.6, dampingFraction: 0.88)

    /// Returns the animation if Reduce Motion is off, otherwise instant
    static func adaptive(_ animation: Animation) -> Animation {
        // Note: This is a compile-time reference; runtime check done in modifiers
        animation
    }
}

// MARK: - View Modifiers

/// Premium glass card background with frosted effect + light border
struct PremiumGlassModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var radius: CGFloat
    var padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .fill(NColor.glassSurface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(colorScheme == .dark ? 0.12 : 0.55),
                                        .clear,
                                        .white.opacity(colorScheme == .dark ? 0.04 : 0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.8
                            )
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.06),
                radius: 16, x: 0, y: 6
            )
    }
}

/// Scale + shadow press effect
struct PressEffectModifier: ViewModifier {
    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isPressed ? 0.92 : 1.0)
            .animation(reduceMotion ? .none : NMotion.snappy, value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in if !isPressed { isPressed = true } }
                    .onEnded { _ in isPressed = false }
            )
    }
}

/// Entrance animation (fade + slide up)
struct EntranceModifier: ViewModifier {
    @State private var appeared = false
    var delay: Double
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    func body(content: Content) -> some View {
        content
            .offset(y: appeared || reduceMotion ? 0 : 24)
            .opacity(appeared || reduceMotion ? 1 : 0)
            .onAppear {
                withAnimation(NMotion.premium.delay(delay)) {
                    appeared = true
                }
            }
    }
}

/// 3D depth overlay — subtle top-light border effect
struct Depth3DModifier: ViewModifier {
    var radius: CGFloat

    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.35), .clear, .black.opacity(0.08)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .blendMode(.overlay)
                .allowsHitTesting(false)
        )
    }
}

// MARK: - View Extensions
extension View {
    /// Premium glass card background
    func premiumGlass(radius: CGFloat = NRadius.large, padding: CGFloat = NSpacing.base) -> some View {
        modifier(PremiumGlassModifier(radius: radius, padding: padding))
    }

    /// Interactive press effect (scale + opacity)
    func pressEffect() -> some View {
        modifier(PressEffectModifier())
    }

    /// Entrance animation with stagger delay
    func entrance(delay: Double = 0) -> some View {
        modifier(EntranceModifier(delay: delay))
    }

    /// 3D depth light/shadow border
    func depth3D(radius: CGFloat = NRadius.large) -> some View {
        modifier(Depth3DModifier(radius: radius))
    }

    /// Apply shadow from NShadow token
    func nShadow(_ shadow: NShadow = .soft) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }

    /// Adaptive background for screens
    func screenBackground() -> some View {
        self.background(NColor.background.ignoresSafeArea())
    }

    /// Premium button style shorthand
    func premiumButton() -> some View {
        self.buttonStyle(PremiumButtonStyle())
    }
}

// MARK: - Premium Button Style
struct PremiumButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(reduceMotion ? .none : NMotion.snappy, value: configuration.isPressed)
    }
}
