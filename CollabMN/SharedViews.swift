import SwiftUI

// MARK: - Offer Card View
struct OfferCardView: View {
    let offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Top row
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: offer.businessCategory.icon)
                        .font(.system(size: 11))
                    Text(offer.businessCategory.rawValue)
                        .font(.system(size: 11, weight: .medium))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(hex: "#7C3AED").opacity(0.2))
                .foregroundColor(Color(hex: "#A78BFA"))
                .cornerRadius(10)
                
                Spacer()
                
                // Status
                Circle()
                    .fill(Color(hex: "#10B981"))
                    .frame(width: 8, height: 8)
                Text(offer.status.rawValue)
                    .font(.system(size: 11))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            
            // Title & business
            VStack(alignment: .leading, spacing: 4) {
                Text(offer.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(offer.businessName)
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
            }
            
            // Offer value highlight
            HStack(spacing: 8) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#EC4899"))
                Text(offer.offerValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#EC4899"))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#EC4899").opacity(0.1))
            .cornerRadius(12)
            
            // Bottom info
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                    Text(offer.location.components(separatedBy: ",").first ?? offer.location)
                        .font(.system(size: 12))
                }
                .foregroundColor(Color.white.opacity(0.4))
                
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 11))
                    Text("\(offer.minFollowers >= 1000 ? "\(offer.minFollowers/1000)K+" : "\(offer.minFollowers)+") дагагч")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color.white.opacity(0.4))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 11))
                    Text("\(offer.applicationCount)")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(Color(hex: "#A78BFA"))
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.06))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}

// MARK: - Offer Detail View
struct OfferDetailView: View {
    let offer: Offer
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataStore: DataStore
    @State private var showApplySheet = false
    @State private var appliedSuccess = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D1A").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: offer.businessCategory.icon)
                                    .font(.system(size: 12))
                                Text(offer.businessCategory.rawValue)
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color(hex: "#7C3AED").opacity(0.2))
                            .foregroundColor(Color(hex: "#A78BFA"))
                            .cornerRadius(12)
                            
                            Spacer()
                            
                            Text(offer.status.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(Color(hex: "#10B981").opacity(0.2))
                                .foregroundColor(Color(hex: "#10B981"))
                                .cornerRadius(12)
                        }
                        
                        Text(offer.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(offer.businessName)
                            .font(.system(size: 16))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    .padding(.horizontal, 20)
                    
                    // Offer Value Box
                    VStack(spacing: 8) {
                        Text("Санал болгож буй үнэ цэнэ")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.5))
                        Text(offer.offerValue)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        LinearGradient(colors: [Color(hex: "#7C3AED").opacity(0.3), Color(hex: "#EC4899").opacity(0.2)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(
                        LinearGradient(colors: [Color(hex: "#7C3AED").opacity(0.5), Color(hex: "#EC4899").opacity(0.3)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                    .padding(.horizontal, 20)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Тайлбар")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        Text(offer.description)
                            .font(.system(size: 15))
                            .foregroundColor(Color.white.opacity(0.7))
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 20)
                    
                    // Required Content
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Хэрэгтэй контент")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        HStack(spacing: 10) {
                            ForEach(offer.requiredContent, id: \.self) { type in
                                HStack(spacing: 6) {
                                    Image(systemName: type.icon)
                                        .font(.system(size: 11))
                                    Text(type.rawValue)
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#EC4899").opacity(0.15))
                                .foregroundColor(Color(hex: "#EC4899"))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Requirements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Шаардлага")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 10) {
                            RequirementRow(icon: "person.fill", label: "Хамгийн бага дагагч",
                                           value: "\(offer.minFollowers >= 1000 ? "\(offer.minFollowers/1000)K" : "\(offer.minFollowers)") дагагч")
                            RequirementRow(icon: "location.fill", label: "Байршил", value: offer.location)
                            RequirementRow(icon: "calendar", label: "Дуусах хугацаа",
                                           value: offer.deadline.formatted(date: .abbreviated, time: .omitted))
                            RequirementRow(icon: "paperplane.fill", label: "Нийт хүсэлт",
                                           value: "\(offer.applicationCount) хүн")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 120)
                }
                .padding(.top, 20)
            }
            
            // Apply Button (fixed bottom)
            if authManager.userRole == .influencer && !appliedSuccess {
                VStack {
                    Spacer()
                    Button {
                        showApplySheet = true
                    } label: {
                        Text("Хүсэлт илгээх")
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
                    .padding(.bottom, 32)
                    .background(
                        LinearGradient(colors: [Color(hex: "#0D0D1A").opacity(0), Color(hex: "#0D0D1A")],
                                       startPoint: .top, endPoint: .bottom)
                    )
                }
            } else if appliedSuccess {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Хүсэлт илгээгдлээ!")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color(hex: "#10B981"))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showApplySheet) {
            ApplyView(offer: offer, onApply: {
                appliedSuccess = true
            })
        }
    }
}

struct RequirementRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#A78BFA"))
                    .frame(width: 20)
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(14)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Apply View
struct ApplyView: View {
    let offer: Offer
    let onApply: () -> Void
    
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @State private var message = ""
    @State private var handle = ""
    @State private var followers = ""
    @State private var applicationError = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D1A").ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Handle bar
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                Text("Хүсэлт илгээх")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 14) {
                    CollabTextField(icon: "at", placeholder: "Instagram/TikTok handle", text: $handle)
                    CollabTextField(icon: "person.2.fill", placeholder: "Нийт дагагчийн тоо", text: $followers)
                    
                    ZStack(alignment: .topLeading) {
                        if message.isEmpty {
                            Text("Өөрийгөө товч танилцуулаарай...")
                                .foregroundColor(Color.white.opacity(0.3))
                                .padding(16)
                        }
                        TextEditor(text: $message)
                            .foregroundColor(.white)
                            .padding(12)
                            .frame(minHeight: 120)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.horizontal, 20)
                
                if !applicationError.isEmpty {
                    Text(applicationError).foregroundColor(.orange).padding(.horizontal, 20)
                }
                Button {
                    guard let user = authManager.currentUser else { return }
                    let inserted = dataStore.applyToOffer(
                        offerId: offer.id,
                        influencerId: user.id,
                        name: user.name,
                        handle: handle,
                        followers: Int(followers) ?? 0,
                        message: message
                    )
                    if inserted {
                        onApply()
                        dismiss()
                    } else {
                        applicationError = "Энэ саналд аль хэдийн хүсэлт илгээсэн, эсвэл шаардлага хангахгүй байна."
                    }
                } label: {
                    Text("Хүсэлт илгээх")
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
                .disabled(handle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (Int(followers) ?? -1) < offer.minFollowers)
                
                Spacer()
            }
        }
    }
}

// MARK: - Application Row View
struct ApplicationRowView: View {
    let application: Application
    
    var statusColor: Color {
        switch application.status {
        case .pending: return .orange
        case .accepted: return .green
        case .rejected: return .red
        case .completed: return .blue
        case .cancelled: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(statusColor.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(application.influencerHandle.prefix(1)).uppercased())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(statusColor)
                )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(application.influencerHandle.isEmpty ? "Инфлүенсер" : application.influencerHandle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("\(application.influencerFollowers >= 1000 ? "\(application.influencerFollowers/1000)K" : "\(application.influencerFollowers)") дагагч")
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.5))
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
        .padding(14)
        .background(Color.white.opacity(0.05))
        .cornerRadius(14)
    }
}


// MARK: - Profile View
struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0D0D1A").ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Profile Header
                        VStack(spacing: 16) {
                            Circle()
                                .fill(LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 90, height: 90)
                                .overlay(
                                    Text(String(authManager.currentUser?.name.prefix(1) ?? "U").uppercased())
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(spacing: 6) {
                                Text(authManager.currentUser?.name ?? "")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                Text(authManager.currentUser?.email ?? "")
                                    .foregroundColor(Color.white.opacity(0.5))
                                Text(authManager.userRole == .business ? "🏢 Бизнес" : "⭐ Инфлүенсер")
                                    .font(.system(size: 13, weight: .medium))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(Color(hex: "#7C3AED").opacity(0.2))
                                    .foregroundColor(Color(hex: "#A78BFA"))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Settings
                        VStack(spacing: 1) {
                            ProfileMenuItem(icon: "person.fill", title: "Профайл засах", color: "#7C3AED")
                            ProfileMenuItem(icon: "bell.fill", title: "Мэдэгдэл", color: "#EC4899")
                            ProfileMenuItem(icon: "lock.fill", title: "Нууцлал & Аюулгүй байдал", color: "#10B981")
                            ProfileMenuItem(icon: "questionmark.circle.fill", title: "Тусламж", color: "#F59E0B")
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        
                        // Logout
                        Button {
                            authManager.logout()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.right.square.fill")
                                Text("Гарах")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(Color.red.opacity(0.8))
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        
                        // Footer
                        Text("Collab.mn v1.0.0")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.3))
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Профайл")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: color))
                .frame(width: 36, height: 36)
                .background(Color(hex: color).opacity(0.15))
                .cornerRadius(10)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(Color.white.opacity(0.3))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "#7C3AED").opacity(0.5))
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white.opacity(0.5))
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
