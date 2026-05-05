import SwiftUI

struct PremiumPaywallView: View {
    @ObservedObject var appState: AppState
    @StateObject private var storeKitService = StoreKitService()

    var body: some View {
        NavigationStack {
            ZStack {
                CinematicBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.large) {
                        BrandHeroMark(size: 184, showTitle: true, subtitle: "Sınırsız çalışma görünürlüğü")

                        PremiumGlassPanel(cornerRadius: 30) {
                            VStack(alignment: .leading, spacing: Spacing.medium) {
                                Text("Pro ile tüm kontrol sende")
                                    .font(.system(.title2, design: .rounded, weight: .black))
                                Text("Nöbetim+ Pro ile sınırsız nöbet, ekip yönetimi, gelişmiş mesai analizi, resmi tatil hesaplama, widget’lar, akıllı öneriler ve gelişmiş raporlar açılır.")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)

                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                    PlanFeatureRow(title: "Sınırsız nöbet", icon: "infinity", color: DesignColors.primary)
                                    PlanFeatureRow(title: "Gelir analizi", icon: "banknote.fill", color: DesignColors.success)
                                    PlanFeatureRow(title: "Ekip yönetimi", icon: "person.3.fill", color: DesignColors.secondary)
                                    PlanFeatureRow(title: "Akıllı öneri", icon: "sparkles", color: DesignColors.accent)
                                }
                            }
                        }

                        ForEach(PremiumPlan.recommendedTurkeyPlans) { plan in
                            planCard(plan)
                        }

                        Button("Satın alımları geri yükle") {
                            Task {
                                let status = await storeKitService.restorePurchases()
                                var profile = appState.profile
                                profile.premiumStatus = status
                                appState.updateProfile(profile)
                                appState.showToast("Satın alımlar kontrol edildi")
                            }
                        }
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(DesignColors.secondary)
                        .frame(minHeight: 44)

                        Text("7 gün deneme ve yasal metinler App Store Connect ürünleriyle etkinleştirilecektir.")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(Spacing.large)
                    .padding(.bottom, Spacing.large)
                }
            }
            .navigationTitle("Pro")
            .toolbarBackground(.hidden, for: .navigationBar)
            .task { await storeKitService.loadProducts() }
        }
    }

    private func planCard(_ plan: PremiumPlan) -> some View {
        let tint = planTint(plan.id)
        let isHighlighted = plan.id == .yearly || plan.id == .lifetime

        return Button {
            Task {
                let status = await storeKitService.purchase(plan.id)
                var profile = appState.profile
                profile.premiumStatus = status
                appState.updateProfile(profile)
                appState.showToast("Pro etkinleştirildi")
            }
        } label: {
            PremiumGlassPanel(cornerRadius: 26) {
                VStack(alignment: .leading, spacing: Spacing.medium) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 7) {
                            if let badge = plan.badge {
                                ShiftStatusCapsule(title: badge, color: tint, systemImage: plan.id == .lifetime ? "crown.fill" : "star.fill")
                            } else {
                                ShiftStatusCapsule(title: "Esnek kullanım", color: tint, systemImage: "bolt.fill")
                            }
                            Text(plan.title)
                                .font(.system(.title3, design: .rounded, weight: .black))
                            Text(plan.subtitle)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(plan.priceText)
                            .font(.system(.title3, design: .rounded, weight: .black))
                            .foregroundStyle(tint)
                    }

                    if isHighlighted {
                        Divider().opacity(0.35)
                        Text(plan.id == .lifetime ? "Tek sefer öde, Pro alanları kalıcı aç." : "Aylığa göre daha avantajlı yıllık deneyim.")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(tint.opacity(isHighlighted ? 0.70 : 0.26), lineWidth: isHighlighted ? 1.4 : 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(plan.title), \(plan.priceText)")
    }

    private func planTint(_ kind: PremiumPlanKind) -> Color {
        switch kind {
        case .monthly: DesignColors.primary
        case .yearly: DesignColors.accent
        case .lifetime: DesignColors.warning
        }
    }
}

private struct PlanFeatureRow: View {
    var title: String
    var icon: String
    var color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.black))
                .foregroundStyle(.white)
                .frame(width: 25, height: 25)
                .background(color.opacity(0.32), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accessibilityHidden(true)
            Text(title)
                .font(.caption.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PremiumPaywallCard: View {
    var action: () -> Void

    var body: some View {
        PremiumGlassPanel(cornerRadius: 28) {
            VStack(alignment: .leading, spacing: Spacing.medium) {
                HStack {
                    ShiftStatusCapsule(title: "Pro", subtitle: "Analiz + ekip", color: DesignColors.accent, systemImage: "sparkles")
                    Spacer()
                    Image("BrandLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .accessibilityHidden(true)
                }
                Text("Gelişmiş analiz, gelir hesaplama, ekip yönetimi, widget ve premium temaları aç.")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                PremiumCTAButton(title: "Pro’yu keşfet", systemImage: "sparkles", tint: DesignColors.accent, action: action)
            }
        }
    }
}
