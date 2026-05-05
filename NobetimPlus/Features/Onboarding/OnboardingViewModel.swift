import SwiftUI

struct OnboardingStep: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let message: String
    let symbol: String
    let accent: Color
}

enum OnboardingViewModel {
    static let steps: [OnboardingStep] = [
        OnboardingStep(title: "Nöbetlerini tek bakışta yönet", message: "Günlük vardiyanı, yaklaşan nöbetini ve çalışma ritmini sade bir kontrol merkezinde gör.", symbol: "calendar.badge.clock", accent: DesignColors.primary),
        OnboardingStep(title: "Ekip durumunu anlık takip et", message: "Aynı gün kim çalışıyor, kim izinli ve ekip yükü nasıl hızlıca fark et.", symbol: "person.3.fill", accent: DesignColors.secondary),
        OnboardingStep(title: "Mesai ve gelir hesaplarını kontrol et", message: "Fazla mesai, resmi tatil ve tahmini ek gelirini bilgilendirme amaçlı hesapla.", symbol: "turkishlirasign.circle.fill", accent: DesignColors.success),
        OnboardingStep(title: "Hatırlatmalar ve akıllı uyarılar", message: "Yaklaşan nöbetler, ekip duyuruları ve takas istekleri için kontrollü bildirim akışı hazır.", symbol: "bell.badge.fill", accent: DesignColors.warning),
        OnboardingStep(title: "Nöbetim+ Pro ile profesyonel deneyim", message: "Sınırsız vardiya, gelişmiş analiz, ekip yönetimi ve premium temalarla tam kontrol.", symbol: "sparkles", accent: DesignColors.accent)
    ]
}
