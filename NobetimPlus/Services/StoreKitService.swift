import Foundation
import StoreKit

@MainActor
final class StoreKitService: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var premiumStatus: PremiumStatus = .free
    var mockMode = true

    func loadProducts() async {
        guard !mockMode else { return }
        do {
            products = try await Product.products(for: PremiumPlanKind.allCases.map(\.productID))
            await refreshEntitlements()
        } catch {
            products = []
        }
    }

    func purchase(_ plan: PremiumPlanKind) async -> PremiumStatus {
        guard !mockMode else {
            premiumStatus = plan == .lifetime ? .lifetime : (plan == .yearly ? .yearly : .monthly)
            return premiumStatus
        }

        guard let product = products.first(where: { $0.id == plan.productID }) else { return .free }
        do {
            let result = try await product.purchase()
            if case let .success(verification) = result,
               case let .verified(transaction) = verification {
                await transaction.finish()
                premiumStatus = plan == .lifetime ? .lifetime : (plan == .yearly ? .yearly : .monthly)
            }
        } catch {
            return .free
        }
        return premiumStatus
    }

    func restorePurchases() async -> PremiumStatus {
        guard !mockMode else {
            premiumStatus = .yearly
            return premiumStatus
        }
        try? await AppStore.sync()
        await refreshEntitlements()
        return premiumStatus
    }

    private func refreshEntitlements() async {
        premiumStatus = .free
        for await entitlement in Transaction.currentEntitlements {
            guard case let .verified(transaction) = entitlement else { continue }
            switch transaction.productID {
            case PremiumPlanKind.lifetime.productID:
                premiumStatus = .lifetime
            case PremiumPlanKind.yearly.productID:
                premiumStatus = .yearly
            case PremiumPlanKind.monthly.productID:
                premiumStatus = .monthly
            default:
                break
            }
        }
    }
}
