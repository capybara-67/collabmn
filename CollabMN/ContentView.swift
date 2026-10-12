import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isLoggedIn {
            if authManager.userRole == .business {
                BusinessTabView()
            } else {
                InfluencerTabView()
            }
        } else {
            LandingView()
        }
    }
}

// MARK: - Business Tab View
struct BusinessTabView: View {
    var body: some View {
        TabView {
            BusinessDashboardView()
                .tabItem {
                    Label("Нүүр", systemImage: "house.fill")
                }
            BusinessOffersView()
                .tabItem {
                    Label("Санал", systemImage: "list.bullet")
                }
            CreateOfferView()
                .tabItem {
                    Label("Нэмэх", systemImage: "plus.circle.fill")
                }
            InfluencerDiscoverView()
                .tabItem {
                    Label("Хайх", systemImage: "magnifyingglass")
                }
            ProfileView()
                .tabItem {
                    Label("Профайл", systemImage: "person.fill")
                }
        }
        .accentColor(Color(hex: "#7C3AED"))
        .environmentObject(DataStore.shared)
    }
}

// MARK: - Influencer Tab View
struct InfluencerTabView: View {
    var body: some View {
        TabView {
            InfluencerDashboardView()
                .tabItem {
                    Label("Нүүр", systemImage: "house.fill")
                }
            OffersListView()
                .tabItem {
                    Label("Санал", systemImage: "gift.fill")
                }
            MyApplicationsView()
                .tabItem {
                    Label("Миний", systemImage: "checkmark.circle.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Профайл", systemImage: "person.fill")
                }
        }
        .accentColor(Color(hex: "#7C3AED"))
        .environmentObject(DataStore.shared)
    }
}
