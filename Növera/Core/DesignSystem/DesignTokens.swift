// DesignTokens.swift
// Növera — Legacy Design Tokens (Backward Compatibility Layer)
// New code should use NoveraDesignSystem.swift (NColor, NFont, NSpacing, etc.)

import SwiftUI

// MARK: - Legacy Color Aliases
enum NoveraColors {
    static let primary = NColor.primaryFallback
    static let accent = NColor.accent
    static let accentGreen = NColor.success
    static let textPrimary = NColor.textPrimary
    static let textSecondary = NColor.textSecondary
    static let textTertiary = NColor.textTertiary
    static let success = NColor.success
    static let warning = NColor.warning
    static let error = NColor.danger
    static let info = NColor.info

    static let shiftDay = NColor.shiftDay
    static let shiftNight = NColor.shiftNight
    static let shiftOncall = NColor.shiftOncall
    static let shiftHoliday = NColor.shiftHoliday
    static let shiftOvertime = NColor.shiftOvertime

    static let primaryGradient = NColor.primaryGradient
    static let accentGradient = NColor.accentGradient
}

// MARK: - Legacy Font Aliases
enum NoveraFonts {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font { NFont.largeTitle(weight) }
    static func title1(_ weight: Font.Weight = .bold) -> Font { NFont.title1(weight) }
    static func title2(_ weight: Font.Weight = .semibold) -> Font { NFont.title2(weight) }
    static func title3(_ weight: Font.Weight = .semibold) -> Font { NFont.title3(weight) }
    static func headline(_ weight: Font.Weight = .semibold) -> Font { NFont.headline(weight) }
    static func body(_ weight: Font.Weight = .regular) -> Font { NFont.body(weight) }
    static func callout(_ weight: Font.Weight = .regular) -> Font { NFont.callout(weight) }
    static func subheadline(_ weight: Font.Weight = .regular) -> Font { NFont.subheadline(weight) }
    static func footnote(_ weight: Font.Weight = .regular) -> Font { NFont.footnote(weight) }
    static func caption(_ weight: Font.Weight = .regular) -> Font { NFont.caption(weight) }
    static func display(_ size: CGFloat = 48, _ weight: Font.Weight = .bold) -> Font { NFont.display(size, weight) }
}

// MARK: - Legacy Spacing Aliases
enum NoveraSpacing {
    static let xs: CGFloat = NSpacing.xs
    static let sm: CGFloat = NSpacing.sm
    static let md: CGFloat = NSpacing.md
    static let lg: CGFloat = NSpacing.lg
    static let xl: CGFloat = NSpacing.xl
    static let xxl: CGFloat = NSpacing.xxl
}

// MARK: - Legacy Radius Aliases
enum NoveraRadius {
    static let sm: CGFloat = NRadius.small
    static let md: CGFloat = NRadius.medium
    static let lg: CGFloat = NRadius.large
    static let xl: CGFloat = NRadius.xlarge
}

// MARK: - Legacy Shadow Token
struct NoveraShadows {
    static let soft = NShadow.soft
    static let primary = NShadow.glow
}

// MARK: - Legacy Animation Aliases
enum NoveraAnimation {
    static let spring = NMotion.premium
    static let springFast = NMotion.snappy
    static let springBouncy = NMotion.bouncy
    static let smooth = NMotion.smooth
    static let pageTransition = NMotion.pageTransition
}

// MARK: - Legacy View Extensions (backward compat)
extension View {
    func glassBackground(cornerRadius: CGFloat = NRadius.large) -> some View {
        premiumGlass(radius: cornerRadius, padding: 0)
    }

    func noveraShadow(_ shadow: NShadow) -> some View {
        nShadow(shadow)
    }

    func scaleOnPress() -> some View {
        pressEffect()
    }
}

// MARK: - Legacy Components (forwarding to new ones)
typealias NoveraPrimaryButton = PremiumPrimaryButton
typealias NoveraSecondaryButton = PremiumSecondaryButton
typealias NoveraGhostButton = PremiumGhostButton
typealias NoveraIconButton = PremiumIconButton
typealias NoveraFAB = PremiumFAB
typealias NoveraSectionHeader = PremiumSectionHeader
typealias NoveraEmptyState = PremiumEmptyState
typealias NoveraFormField = PremiumFormField

// MARK: - Legacy GlassCard wrapper
struct GlassCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        PremiumGlassCard(content: content)
    }
}
