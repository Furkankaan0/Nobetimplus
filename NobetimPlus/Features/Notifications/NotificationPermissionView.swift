import SwiftUI

struct NotificationPermissionView: View {
    var action: () -> Void

    var body: some View {
        PremiumGlassPanel(cornerRadius: 30) {
            VStack(alignment: .leading, spacing: Spacing.large) {
                HStack {
                    AwardDepthBadge(title: "Bildirim", subtitle: "Kontrol", systemImage: "bell.badge.fill", color: DesignColors.secondary, size: 72)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: Spacing.small) {
                    Text("Nöbetini kaçırma")
                        .font(.system(.title2, design: .rounded, weight: .black))
                    Text("Yaklaşan nöbet, ekip duyurusu ve takas isteği bildirimleri yalnızca izin verdiğinde gönderilir.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                PremiumCTAButton(title: "Bildirim izni ver", systemImage: "bell.badge.fill", tint: DesignColors.secondary, action: action)
            }
        }
        .accessibilityElement(children: .contain)
    }
}
