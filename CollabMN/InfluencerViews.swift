import SwiftUI

// MARK: - Influencer Dashboard
struct InfluencerDashboardView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Сайн уу 👋")
                                    .foregroundColor(Color.white.opacity(0.6))
                                Text(authManager.currentUser?.name ?? "Инфлүенсер")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text("I")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Stats
                        HStack(spacing: 12) {
                            DashboardStatCard(value: "\(dataStore.offers.count)", label: "Нийт санал", icon: "gift.fill", color: "#7C3AED")
                            DashboardStatCard(value: "\(dataStore.applications(forInfluencer: authManager.currentUser?.id).count)", label: "Хүсэлт", icon: "paperplane.fill", color: "#EC4899")
                            DashboardStatCard(value: "\(dataStore.applications(forInfluencer: authManager.currentUser?.id).filter { $0.status == .completed }.count)", label: "Дууссан", icon: "checkmark.seal.fill", color: "#10B981")
                        }
                        .padding(.horizontal, 20)
                        
                        // Featured Offers
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Онцлох саналууд")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("Бүгдийг харах")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#A78BFA"))
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(dataStore.offers.prefix(5)) { offer in
                                        NavigationLink(destination: OfferDetailView(offer: offer)) {
                                            FeaturedOfferCard(offer: offer)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // All Offers
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Шинэ саналууд")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ForEach(dataStore.offers) { offer in
                                NavigationLink(destination: OfferDetailView(offer: offer)) {
                                    OfferCardView(offer: offer)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Featured Offer Card (horizontal scroll)
struct FeaturedOfferCard: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category badge
            HStack {
                Image(systemName: offer.businessCategory.icon)
                    .font(.system(size: 11))
                Text(offer.businessCategory.rawValue)
                    .font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(hex: "#7C3AED").opacity(0.3))
            .foregroundColor(Color(hex: "#A78BFA"))
            .cornerRadius(10)
            
            Text(offer.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Text(offer.businessName)
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.6))
            
            Spacer()
            
            // Value highlight
            HStack {
                Image(systemName: "gift.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#EC4899"))
                Text(offer.offerValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#EC4899"))
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(width: 200, height: 160)
        .background(Color.white.opacity(0.07))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

// MARK: - Offers List View (Full)
struct OffersListView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var searchText = ""
    @State private var selectedCategory: BusinessCategory? = nil
    
    var filteredOffers: [Offer] {
        var offers = dataStore.offers
        if !searchText.isEmpty {
            offers = offers.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.businessName.localizedCaseInsensitiveContains(searchText)
            }
        }
        if let cat = selectedCategory {
            offers = offers.filter { $0.businessCategory == cat }
        }
        return offers
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.white.opacity(0.4))
                        TextField("Санал хайх...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(14)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(14)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            FilterChip(label: "Бүгд", isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            ForEach(BusinessCategory.allCases, id: \.self) { cat in
                                FilterChip(label: cat.rawValue, isSelected: selectedCategory == cat) {
                                    selectedCategory = cat
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                    
                    // Offers
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(filteredOffers) { offer in
                                NavigationLink(destination: OfferDetailView(offer: offer)) {
                                    OfferCardView(offer: offer)
                                        .padding(.horizontal, 20)
                                }
                            }
                            Spacer(minLength: 100)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.top, 16)
            }
            .navigationTitle("Саналууд")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "#7C3AED") : Color.white.opacity(0.07))
                .foregroundColor(isSelected ? .white : Color.white.opacity(0.6))
                .cornerRadius(20)
        }
    }
}

// MARK: - My Applications View
struct MyApplicationsView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if dataStore.applications(forInfluencer: authManager.currentUser?.id).isEmpty {
                            EmptyStateView(icon: "paperplane.fill", message: "Та одоогоор ямар нэгэн саналд хүсэлт гаргаагүй байна")
                                .padding(.top, 80)
                        } else {
                            ForEach(dataStore.applications(forInfluencer: authManager.currentUser?.id)) { app in
                                ApplicationDetailCard(application: app)
                                    .padding(.horizontal, 20)
                            }
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Миний хүсэлтүүд")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ApplicationDetailCard: View {
    let application: Application
    
    var statusColor: Color {
        switch application.status {
        case .pending: return Color.orange
        case .accepted: return Color.green
        case .rejected: return Color.red
        case .completed: return Color.blue
        case .cancelled: return Color.gray
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(statusColor.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(statusColor)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Хүсэлт #\(application.id.uuidString.prefix(8))")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(application.message.isEmpty ? "Хүсэлт илгээсэн" : application.message)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(application.status.rawValue)
                .font(.system(size: 11, weight: .semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .cornerRadius(10)
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .cornerRadius(16)
    }
}

// MARK: - Influencer Discover View (for Business)
struct InfluencerDiscoverView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(dataStore.influencers) { influencer in
                            InfluencerCard(influencer: influencer)
                                .padding(.horizontal, 20)
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Инфлүенсер хайх")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct InfluencerCard: View {
    let influencer: InfluencerProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                // Avatar
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(String(influencer.instagramHandle?.prefix(1) ?? "I").uppercased())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(influencer.instagramHandle ?? "@influencer")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text(influencer.location)
                        .font(.system(size: 13))
                        .foregroundColor(Color.white.opacity(0.5))
                }
                
                Spacer()
                
                // Engagement badge
                VStack(spacing: 2) {
                    Text("\(String(format: "%.1f", influencer.engagementRate))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "#10B981"))
                    Text("Eng.")
                        .font(.system(size: 10))
                        .foregroundColor(Color.white.opacity(0.4))
                }
            }
            
            // Stats
            HStack(spacing: 12) {
                if let handle = influencer.instagramHandle {
                    SocialStatBadge(icon: "camera.fill", handle: handle,
                                    followers: influencer.instagramFollowers, color: "#E1306C")
                }
                if let handle = influencer.tiktokHandle, influencer.tiktokFollowers > 0 {
                    SocialStatBadge(icon: "music.note", handle: handle,
                                    followers: influencer.tiktokFollowers, color: "#69C9D0")
                }
            }
            
            // Niches
            HStack(spacing: 8) {
                ForEach(influencer.niche, id: \.self) { niche in
                    Text("\(niche.icon) \(niche.rawValue)")
                        .font(.system(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.07))
                        .foregroundColor(Color.white.opacity(0.8))
                        .cornerRadius(20)
                }
            }
            
            Text(influencer.bio)
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.6))
                .lineLimit(2)
        }
        .padding(20)
        .background(Color.white.opacity(0.06))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}

struct SocialStatBadge: View {
    let icon: String
    let handle: String
    let followers: Int
    let color: String
    
    var formattedFollowers: String {
        followers >= 1000 ? String(format: "%.1fK", Double(followers)/1000) : "\(followers)"
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: color))
            Text(formattedFollowers)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
            Text("дагагч")
                .font(.system(size: 11))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(hex: color).opacity(0.1))
        .cornerRadius(12)
    }
}
