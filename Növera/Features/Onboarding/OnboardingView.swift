// OnboardingView.swift
// Növera — Premium 5-Screen Onboarding

import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authService: AuthService

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Animated gradient background per page
                LinearGradient(
                    colors: vm.pages[vm.currentPage].gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(NMotion.pageTransition, value: vm.currentPage)

                // Animated blobs
                PremiumOrbsBackground()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Skip button
                    HStack {
                        Spacer()
                        if !vm.isLastPage {
                            Button(action: completeOnboarding) {
                                Text("Atla")
                                    .font(NFont.callout(.medium))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .padding(.horizontal, NSpacing.base)
                                    .padding(.vertical, NSpacing.sm)
                                    .background(
                                        Capsule()
                                            .fill(.white.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(.top, NSpacing.sm)
                    .padding(.trailing, NSpacing.lg)

                    Spacer()

                    // Pages
                    TabView(selection: $vm.currentPage) {
                        ForEach(vm.pages) { page in
                            PremiumOnboardingPage(page: page, animate: vm.animateHero)
                                .tag(page.id)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: geo.size.height * 0.60)
                    .animation(NMotion.pageTransition, value: vm.currentPage)
                    .onChange(of: vm.currentPage) { _, _ in
                        HapticManager.selection()
                    }

                    Spacer()

                    // Bottom controls
                    VStack(spacing: NSpacing.xl) {
                        // Progress indicator
                        PremiumPageIndicator(
                            count: vm.pages.count,
                            currentIndex: vm.currentPage,
                            accentColor: vm.pages[vm.currentPage].accentColor
                        )

                        // Action buttons
                        if vm.isLastPage {
                            VStack(spacing: NSpacing.md) {
                                PremiumPrimaryButton(title: "Başla", icon: "arrow.right") {
                                    completeOnboarding()
                                }
                                .opacity(vm.showGetStarted ? 1 : 0)
                                .offset(y: vm.showGetStarted ? 0 : 20)
                                .animation(NMotion.premium.delay(0.2), value: vm.showGetStarted)

                                PremiumSecondaryButton(title: "Pro'yu Keşfet", icon: "star.fill") {
                                    completeOnboarding()
                                }
                                .opacity(vm.showGetStarted ? 1 : 0)
                                .offset(y: vm.showGetStarted ? 0 : 20)
                                .animation(NMotion.premium.delay(0.35), value: vm.showGetStarted)
                            }
                        } else {
                            PremiumPrimaryButton(title: "Devam", icon: "arrow.right") {
                                vm.goNext()
                            }
                        }
                    }
                    .padding(.horizontal, NSpacing.xl)
                    .padding(.bottom, NSpacing.xxl)
                }
            }
        }
        .onAppear { vm.onAppear() }
    }

    private func completeOnboarding() {
        HapticManager.notification(.success)
        withAnimation(NMotion.pageTransition) {
            appState.hasCompletedOnboarding = true
        }
    }
}

// MARK: - Single Page View
struct PremiumOnboardingPage: View {
    let page: OnboardingPage
    let animate: Bool

    @State private var iconFloat: CGFloat = 0
    @State private var iconRotation: Double = -4

    var body: some View {
        VStack(spacing: NSpacing.xxl) {
            // 3D Icon with floating animation
            ZStack {
                // Outer glow
                Circle()
                    .fill(page.accentColor.opacity(0.10))
                    .frame(width: 200, height: 200)
                    .blur(radius: 30)

                // Glass container
                RoundedRectangle(cornerRadius: NRadius.xlarge, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: NRadius.xlarge, style: .continuous)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .frame(width: 150, height: 150)
                    .shadow(color: page.accentColor.opacity(0.25), radius: 30, x: 0, y: 12)

                // Gradient icon
                Image(systemName: page.icon)
                    .font(.system(size: 60, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: page.iconColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: page.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .offset(y: iconFloat)
            .rotation3DEffect(.degrees(iconRotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(animate ? 1.0 : 0.6)
            .opacity(animate ? 1.0 : 0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    iconFloat = -12
                }
                withAnimation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true).delay(0.5)) {
                    iconRotation = 4
                }
            }

            // Text content with glass card
            VStack(spacing: NSpacing.md) {
                Text(page.title)
                    .font(NFont.title1(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .scaleEffect(animate ? 1.0 : 0.9)
                    .opacity(animate ? 1.0 : 0)

                Text(page.subtitle)
                    .font(NFont.callout())
                    .foregroundStyle(.white.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, NSpacing.lg)
                    .opacity(animate ? 1.0 : 0)
            }
        }
        .padding(.horizontal, NSpacing.lg)
    }
}

// MARK: - Premium Page Indicator
struct PremiumPageIndicator: View {
    let count: Int
    let currentIndex: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(
                        index == currentIndex
                        ? accentColor
                        : .white.opacity(0.25)
                    )
                    .frame(
                        width: index == currentIndex ? 28 : 8,
                        height: 8
                    )
                    .animation(NMotion.snappy, value: currentIndex)
            }
        }
    }
}

// MARK: - Premium Orbs Background
struct PremiumOrbsBackground: View {
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.04))
                .frame(width: 320, height: 320)
                .offset(x: animate ? -90 : -60, y: animate ? -210 : -230)
                .blur(radius: 2)

            Circle()
                .fill(.white.opacity(0.03))
                .frame(width: 220, height: 220)
                .offset(x: animate ? 130 : 100, y: animate ? 310 : 340)
                .blur(radius: 2)

            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 160, height: 160)
                .offset(x: animate ? 110 : 80, y: animate ? -360 : -340)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(Animation.easeInOut(duration: 9).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
        .environmentObject(AuthService())
}
