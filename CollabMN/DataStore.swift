import Foundation
import Combine

// MARK: - Auth Manager
class AuthManager: ObservableObject {
    private var demoUsers: [String: User] = [:]
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var userRole: UserRole?
    
    func login(email: String, password: String, role: UserRole) {
        // Mock login - replace with Supabase auth
        let key = role.rawValue + ":" + email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let user = demoUsers[key] ?? User(
            email: email,
            name: role == .business ? "Миний Бизнес" : "Миний Хэвлэл",
            role: role,
            location: "Улаанбаатар"
        )
        demoUsers[key] = user
        self.currentUser = user
        self.userRole = role
        self.isLoggedIn = true
    }
    
    func register(email: String, password: String, name: String, role: UserRole) {
        let key = role.rawValue + ":" + email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var user = demoUsers[key] ?? User(email: email, name: name, role: role, location: "Улаанбаатар")
        user.name = name
        demoUsers[key] = user
        self.currentUser = user
        self.userRole = role
        self.isLoggedIn = true
    }
    
    func logout() {
        self.currentUser = nil
        self.userRole = nil
        self.isLoggedIn = false
    }
}

// MARK: - Data Store (Mock - Replace with Supabase)
class DataStore: ObservableObject {
    static let shared = DataStore()
    
    @Published var offers: [Offer] = []
    @Published var applications: [Application] = []
    @Published var influencers: [InfluencerProfile] = []
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        let now = Date()
        let future = Calendar.current.date(byAdding: .day, value: 14, to: now)!
        
        offers = [
            Offer(
                id: UUID(),
                businessId: UUID(),
                businessName: "Matcha House UB",
                businessCategory: .food,
                title: "Үнэгүй Матча Кофе x2",
                description: "Манай шинэ матча кофены цэсийг сурталчлаарай. 2 хүнд үнэгүй матча өгнө.",
                offerValue: "Үнэгүй матча кофе x2 (₮18,000 үнэтэй)",
                requiredContent: [.instagramStory, .instagramReel],
                minFollowers: 2000,
                preferredNiches: [.food, .lifestyle],
                location: "Улаанбаатар, Сүхбаатар дүүрэг",
                deadline: future,
                status: .active,
                applicationCount: 8
            ),
            Offer(
                id: UUID(),
                businessId: UUID(),
                businessName: "FitZone Gym",
                businessCategory: .fitness,
                title: "7 хоногийн үнэгүй нэвтрэх эрх",
                description: "Манай шинэ дасгалын заалыг сурталчлаарай. 1 долоо хоногийн эрх өгнө.",
                offerValue: "7 хоногийн gym pass (₮35,000 үнэтэй)",
                requiredContent: [.instagramReel, .tiktokVideo],
                minFollowers: 5000,
                preferredNiches: [.fitness, .lifestyle],
                location: "Улаанбаатар, Баянзүрх дүүрэг",
                deadline: future,
                status: .active,
                applicationCount: 12
            ),
            Offer(
                id: UUID(),
                businessId: UUID(),
                businessName: "Glow Beauty Studio",
                businessCategory: .beauty,
                title: "Үнэгүй нүүр арчилгааны үйлчилгээ",
                description: "Манай шинэ нүүр арчилгааны үйлчилгээг туршиж сурталчлаарай.",
                offerValue: "Facial үйлчилгээ (₮60,000 үнэтэй)",
                requiredContent: [.instagramPost, .instagramStory],
                minFollowers: 3000,
                preferredNiches: [.beauty, .lifestyle, .fashion],
                location: "Улаанбаатар, Чингэлтэй дүүрэг",
                deadline: future,
                status: .active,
                applicationCount: 5
            ),
            Offer(
                id: UUID(),
                businessId: UUID(),
                businessName: "Urban Burger MN",
                businessCategory: .food,
                title: "2 хүний үнэгүй бургер сет",
                description: "Манай шинэ бургер менюг сурталчлаарай. 2 хүний сет хоол өгнө.",
                offerValue: "2 бургер сет (₮42,000 үнэтэй)",
                requiredContent: [.tiktokVideo, .instagramReel],
                minFollowers: 1000,
                preferredNiches: [.food],
                location: "Улаанбаатар, Хан-Уул дүүрэг",
                deadline: future,
                status: .active,
                applicationCount: 20
            ),
            Offer(
                id: UUID(),
                businessId: UUID(),
                businessName: "StyleMN Fashion",
                businessCategory: .fashion,
                title: "Загварын хувцас бэлэглэл",
                description: "Манай шинэ цуглуулгаас хувцас сонгоод Instagram-д тавиарай.",
                offerValue: "₮80,000 хүртэлх хувцас",
                requiredContent: [.instagramPost, .instagramReel],
                minFollowers: 8000,
                preferredNiches: [.fashion, .lifestyle],
                location: "Улаанбаатар",
                deadline: future,
                status: .active,
                applicationCount: 3
            )
        ]
        
        influencers = [
            InfluencerProfile(
                id: UUID(),
                userId: UUID(),
                bio: "Хоол хийх, идэх дуртай. UB-ийн хамгийн сайн ресторануудыг танилцуулдаг.",
                niche: [.food, .lifestyle],
                instagramHandle: "@ub_foodie",
                instagramFollowers: 12400,
                tiktokHandle: "@ub_foodie",
                tiktokFollowers: 8200,
                engagementRate: 4.2,
                location: "Улаанбаатар"
            ),
            InfluencerProfile(
                id: UUID(),
                userId: UUID(),
                bio: "Фитнес, эрүүл амьдрал. Өдөр тутмын дасгал, хоол тэжээлийн зөвлөгөө.",
                niche: [.fitness, .lifestyle],
                instagramHandle: "@fit_mongol",
                instagramFollowers: 23100,
                tiktokHandle: "@fit_mongol",
                tiktokFollowers: 15000,
                engagementRate: 5.8,
                location: "Улаанбаатар"
            ),
            InfluencerProfile(
                id: UUID(),
                userId: UUID(),
                bio: "Гоо сайхан, арьс арчилгаа. K-beauty дуртай.",
                niche: [.beauty, .fashion],
                instagramHandle: "@glow_mongolia",
                instagramFollowers: 18700,
                tiktokHandle: nil,
                tiktokFollowers: 0,
                engagementRate: 6.1,
                location: "Улаанбаатар"
            )
        ]
    }
    
    func offers(forBusiness id: UUID?) -> [Offer] {
        offers.filter { $0.businessId == id }
    }

    func applications(forBusiness id: UUID?) -> [Application] {
        let offerIds = Set(offers(forBusiness: id).map(\.id))
        return applications.filter { offerIds.contains($0.offerId) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func applications(forInfluencer id: UUID?) -> [Application] {
        applications.filter { $0.influencerId == id }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func addOffer(_ offer: Offer, business: User) -> Bool {
        guard business.role == .business, offer.businessId == business.id,
              !offer.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !offer.offerValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !offer.requiredContent.isEmpty, offer.deadline > Date(),
              offer.minFollowers >= 0,
              !offers.contains(where: { $0.id == offer.id }) else { return false }
        offers.insert(offer, at: 0)
        return true
    }
    
    func applyToOffer(offerId: UUID, influencerId: UUID, name: String, handle: String, followers: Int, message: String) -> Bool {
        guard let offer = offers.first(where: { $0.id == offerId }),
              offer.status == .active, offer.deadline > Date(),
              followers >= offer.minFollowers,
              !handle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !applications.contains(where: { $0.offerId == offerId && $0.influencerId == influencerId })
        else { return false }
        let app = Application(
            offerId: offerId,
            influencerId: influencerId,
            influencerName: name,
            influencerHandle: handle,
            influencerFollowers: followers,
            message: message,
            status: .pending
        )
        applications.append(app)
        if let idx = offers.firstIndex(where: { $0.id == offerId }) {
            offers[idx].applicationCount += 1
        }
        return true
    }
}
