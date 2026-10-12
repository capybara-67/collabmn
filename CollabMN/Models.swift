import Foundation

// MARK: - User Role
enum UserRole: String, Codable, CaseIterable {
    case business = "business"
    case influencer = "influencer"
}

// MARK: - User
struct User: Identifiable, Codable {
    var id: UUID = UUID()
    var email: String
    var name: String
    var role: UserRole
    var profileImageURL: String?
    var location: String
    var createdAt: Date = Date()
}

// MARK: - Business Profile
struct BusinessProfile: Identifiable, Codable {
    var id: UUID = UUID()
    var userId: UUID
    var businessName: String
    var category: BusinessCategory
    var description: String
    var website: String?
    var instagramHandle: String?
    var logoURL: String?
    var location: String
    var isVerified: Bool = false
}

enum BusinessCategory: String, Codable, CaseIterable {
    case food = "Хоол & Ресторан"
    case beauty = "Гоо сайхан"
    case fitness = "Фитнес"
    case fashion = "Загвар"
    case tech = "Технологи"
    case travel = "Аялал"
    case education = "Боловсрол"
    case other = "Бусад"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .beauty: return "sparkles"
        case .fitness: return "figure.run"
        case .fashion: return "tshirt"
        case .tech: return "laptopcomputer"
        case .travel: return "airplane"
        case .education: return "book"
        case .other: return "square.grid.2x2"
        }
    }
}

// MARK: - Influencer Profile
struct InfluencerProfile: Identifiable, Codable {
    var id: UUID = UUID()
    var userId: UUID
    var bio: String
    var niche: [ContentNiche]
    var instagramHandle: String?
    var instagramFollowers: Int
    var tiktokHandle: String?
    var tiktokFollowers: Int
    var facebookHandle: String?
    var engagementRate: Double
    var location: String
    var profileImageURL: String?
    var completedDeals: Int = 0
    
    var totalFollowers: Int {
        instagramFollowers + tiktokFollowers
    }
    
    var formattedFollowers: String {
        let total = totalFollowers
        if total >= 1000 {
            return String(format: "%.1fK", Double(total) / 1000.0)
        }
        return "\(total)"
    }
}

enum ContentNiche: String, Codable, CaseIterable {
    case food = "Хоол"
    case beauty = "Гоо сайхан"
    case fitness = "Фитнес"
    case fashion = "Загвар"
    case tech = "Технологи"
    case travel = "Аялал"
    case lifestyle = "Амьдралын хэв маяг"
    case gaming = "Геймер"
    
    var icon: String {
        switch self {
        case .food: return "🍜"
        case .beauty: return "💄"
        case .fitness: return "💪"
        case .fashion: return "👗"
        case .tech: return "💻"
        case .travel: return "✈️"
        case .lifestyle: return "🌟"
        case .gaming: return "🎮"
        }
    }
}

// MARK: - Offer
struct Offer: Identifiable, Codable {
    var id: UUID = UUID()
    var businessId: UUID
    var businessName: String
    var businessCategory: BusinessCategory
    var title: String
    var description: String
    var offerValue: String           // e.g. "Үнэгүй матча кофе x2"
    var requiredContent: [ContentType]
    var minFollowers: Int
    var preferredNiches: [ContentNiche]
    var location: String
    var deadline: Date
    var status: OfferStatus
    var createdAt: Date = Date()
    var applicationCount: Int = 0
    var imageURL: String?
}

enum ContentType: String, Codable, CaseIterable {
    case instagramStory = "Instagram Story"
    case instagramReel = "Instagram Reel"
    case instagramPost = "Instagram Post"
    case tiktokVideo = "TikTok Видео"
    case facebookPost = "Facebook Post"
    
    var icon: String {
        switch self {
        case .instagramStory, .instagramReel, .instagramPost: return "camera.fill"
        case .tiktokVideo: return "music.note"
        case .facebookPost: return "person.2.fill"
        }
    }
}

enum OfferStatus: String, Codable {
    case active = "Идэвхтэй"
    case paused = "Түр зогссон"
    case completed = "Дууссан"
    case cancelled = "Цуцлагдсан"
}

// MARK: - Application
struct Application: Identifiable, Codable {
    var id: UUID = UUID()
    var offerId: UUID
    var influencerId: UUID
    var influencerName: String
    var influencerHandle: String
    var influencerFollowers: Int
    var message: String
    var status: ApplicationStatus
    var createdAt: Date = Date()
    var completionProofURL: String?
    var completedAt: Date?
}

enum ApplicationStatus: String, Codable {
    case pending = "Хүлээгдэж буй"
    case accepted = "Зөвшөөрсөн"
    case rejected = "Татгалзсан"
    case completed = "Гүйцэтгэсэн"
    case cancelled = "Цуцлагдсан"
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .accepted: return "green"
        case .rejected: return "red"
        case .completed: return "blue"
        case .cancelled: return "gray"
        }
    }
}
