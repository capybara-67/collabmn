import SwiftUI

// MARK: - Business Dashboard
struct BusinessDashboardView: View {
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
                                Text(authManager.currentUser?.name ?? "Бизнес")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Circle()
                                .fill(Color(hex: "#7C3AED").opacity(0.3))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text("B")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(hex: "#A78BFA"))
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Stats
                        HStack(spacing: 12) {
                            DashboardStatCard(value: "\(dataStore.offers.count)", label: "Нийт санал", icon: "gift.fill", color: "#7C3AED")
                            DashboardStatCard(value: "\(dataStore.applications.count)", label: "Хүсэлт", icon: "person.fill.checkmark", color: "#EC4899")
                            DashboardStatCard(value: "\(dataStore.applications.filter { $0.status == .completed }.count)", label: "Дууссан", icon: "checkmark.seal.fill", color: "#10B981")
                        }
                        .padding(.horizontal, 20)
                        
                        // Recent Applications
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Сүүлийн хүсэлтүүд")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            if dataStore.applications.isEmpty {
                                EmptyStateView(icon: "person.fill.questionmark", message: "Одоогоор хүсэлт ирээгүй байна")
                                    .padding(.horizontal, 20)
                            } else {
                                ForEach(dataStore.applications.prefix(5)) { app in
                                    ApplicationRowView(application: app)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // My Active Offers
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Миний идэвхтэй саналууд")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            ForEach(dataStore.offers.prefix(3)) { offer in
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

struct DashboardStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: color))
                .font(.system(size: 20))
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.06))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: color).opacity(0.3), lineWidth: 1))
    }
}

// MARK: - Business Offers View
struct BusinessOffersView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(dataStore.offers) { offer in
                            NavigationLink(destination: OfferDetailView(offer: offer)) {
                                OfferCardView(offer: offer)
                            }
                            .padding(.horizontal, 20)
                        }
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Миний саналууд")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Create Offer View
struct CreateOfferView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @State private var title = ""
    @State private var description = ""
    @State private var offerValue = ""
    @State private var selectedCategory: BusinessCategory = .food
    @State private var selectedContentTypes: Set<ContentType> = []
    @State private var minFollowers = 1000
    @State private var location = "Улаанбаатар"
    @State private var deadline = Date().addingTimeInterval(14 * 24 * 3600)
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Section: Basic Info
                        SectionCard(title: "Үндсэн мэдээлэл") {
                            VStack(spacing: 12) {
                                CollabTextField(icon: "tag.fill", placeholder: "Саналын гарчиг", text: $title)
                                
                                ZStack(alignment: .topLeading) {
                                    if description.isEmpty {
                                        Text("Дэлгэрэнгүй тайлбар...")
                                            .foregroundColor(Color.white.opacity(0.3))
                                            .padding(16)
                                    }
                                    TextEditor(text: $description)
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .frame(minHeight: 100)
                                        .scrollContentBackground(.hidden)
                                }
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                                
                                CollabTextField(icon: "gift.fill", placeholder: "Санал (жш: Үнэгүй матча x2)", text: $offerValue)
                            }
                        }
                        
                        // Section: Category
                        SectionCard(title: "Ангилал") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(BusinessCategory.allCases, id: \.self) { cat in
                                        Button {
                                            selectedCategory = cat
                                        } label: {
                                            HStack(spacing: 6) {
                                                Image(systemName: cat.icon)
                                                    .font(.system(size: 12))
                                                Text(cat.rawValue)
                                                    .font(.system(size: 13, weight: .medium))
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(selectedCategory == cat ? Color(hex: "#7C3AED") : Color.white.opacity(0.07))
                                            .foregroundColor(selectedCategory == cat ? .white : Color.white.opacity(0.6))
                                            .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Section: Content Types
                        SectionCard(title: "Хэрэгтэй контент") {
                            FlowLayout(items: ContentType.allCases, spacing: 10) { type in
                                Button {
                                    if selectedContentTypes.contains(type) {
                                        selectedContentTypes.remove(type)
                                    } else {
                                        selectedContentTypes.insert(type)
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: type.icon)
                                            .font(.system(size: 11))
                                        Text(type.rawValue)
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedContentTypes.contains(type) ? Color(hex: "#EC4899") : Color.white.opacity(0.07))
                                    .foregroundColor(selectedContentTypes.contains(type) ? .white : Color.white.opacity(0.6))
                                    .cornerRadius(20)
                                }
                            }
                        }
                        
                        // Section: Requirements
                        SectionCard(title: "Шаардлага") {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Хамгийн бага дагагч")
                                        .foregroundColor(Color.white.opacity(0.7))
                                    Spacer()
                                    Text("\(minFollowers)")
                                        .foregroundColor(Color(hex: "#A78BFA"))
                                        .fontWeight(.semibold)
                                }
                                Slider(value: Binding(
                                    get: { Double(minFollowers) },
                                    set: { minFollowers = Int($0) }
                                ), in: 500...50000, step: 500)
                                .accentColor(Color(hex: "#7C3AED"))
                                
                                CollabTextField(icon: "location.fill", placeholder: "Байршил", text: $location)
                                
                                HStack {
                                    Text("Дуусах хугацаа")
                                        .foregroundColor(Color.white.opacity(0.7))
                                    Spacer()
                                    DatePicker("", selection: $deadline, displayedComponents: .date)
                                        .colorScheme(.dark)
                                }
                            }
                        }
                        
                        // Post Button
                        Button {
                            postOffer()
                        } label: {
                            Text("Санал нийтлэх")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .disabled(title.isEmpty || offerValue.isEmpty)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Санал нэмэх")
            .navigationBarTitleDisplayMode(.large)
            .alert("Амжилттай!", isPresented: $showSuccess) {
                Button("OK") { clearForm() }
            } message: {
                Text("Таны санал амжилттай нийтлэгдлээ!")
            }
        }
    }
    
    func postOffer() {
        let offer = Offer(
            businessId: UUID(),
            businessName: "Миний Бизнес",
            businessCategory: selectedCategory,
            title: title,
            description: description,
            offerValue: offerValue,
            requiredContent: Array(selectedContentTypes),
            minFollowers: minFollowers,
            preferredNiches: [],
            location: location,
            deadline: deadline,
            status: .active
        )
        dataStore.addOffer(offer)
        showSuccess = true
    }
    
    func clearForm() {
        title = ""
        description = ""
        offerValue = ""
        selectedContentTypes = []
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            content
        }
        .padding(20)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))
        .padding(.horizontal, 20)
    }
}

// Simple flow layout
struct FlowLayout<T: Hashable, Content: View>: View {
    let items: [T]
    let spacing: CGFloat
    let content: (T) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(spacing: spacing) {
                ForEach(items.prefix(3), id: \.self) { item in
                    content(item)
                }
            }
            HStack(spacing: spacing) {
                ForEach(items.dropFirst(3), id: \.self) { item in
                    content(item)
                }
            }
        }
    }
}
