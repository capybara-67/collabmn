import SwiftUI

// MARK: - Landing View
struct LandingView: View {
    @State private var showLogin = false
    @State private var showRegister = false
    @State private var selectedRole: UserRole = .influencer
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "#0D0D1A"), Color(hex: "#1A0A2E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Purple glow
            Circle()
                .fill(Color(hex: "#7C3AED").opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: 100, y: -200)
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(width: 52, height: 52)
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Text("Collab.mn")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 24)
                
                // Badge
                Text("🇲🇳 Монголын #1 Инфлүенсер Маркетплейс")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#A78BFA"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#7C3AED").opacity(0.2))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(hex: "#7C3AED").opacity(0.4), lineWidth: 1))
                    .padding(.bottom, 32)
                
                // Headline
                VStack(spacing: 8) {
                    Text("Бизнес ба")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                    Text("Инфлүенсерийн")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(colors: [Color(hex: "#A78BFA"), Color(hex: "#EC4899")],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                    Text("холбоос")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
                
                Text("Хоол, гоо сайхан, фитнес... Дуртай\nбизнестэйгээ хамтран ажиллаж, хамтдаа өсье.")
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 48)
                
                Spacer()
                
                // Stats
                HStack(spacing: 12) {
                    StatCard(value: "500+", label: "Бизнес")
                    StatCard(value: "2K+", label: "Инфлүенсер")
                    StatCard(value: "5K+", label: "Хамтрал")
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                
                // CTA Buttons
                VStack(spacing: 12) {
                    Button {
                        selectedRole = .business
                        showRegister = true
                    } label: {
                        HStack {
                            Image(systemName: "briefcase.fill")
                            Text("Бизнес бүртгүүлэх")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#6D28D9")],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    Button {
                        selectedRole = .influencer
                        showRegister = true
                    } label: {
                        HStack {
                            Image(systemName: "person.2.fill")
                            Text("Инфлүенсер болох")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white.opacity(0.08))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.15), lineWidth: 1))
                    }
                    
                    Button {
                        showLogin = true
                    } label: {
                        Text("Нэвтрэх")
                            .foregroundColor(Color(hex: "#A78BFA"))
                            .font(.system(size: 15, weight: .medium))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .sheet(isPresented: $showRegister) {
            RegisterView(preselectedRole: selectedRole)
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.07))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

// MARK: - Login View
struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole: UserRole = .influencer
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D1A").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Нэвтрэх")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("Тавтай морил!")
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    .padding(.top, 40)
                    
                    // Role Picker
                    HStack(spacing: 0) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Button {
                                selectedRole = role
                            } label: {
                                Text(role == .business ? "Бизнес" : "Инфлүенсер")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedRole == role ? Color(hex: "#7C3AED") : Color.clear)
                                    .foregroundColor(selectedRole == role ? .white : Color.white.opacity(0.5))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(14)
                    
                    // Fields
                    VStack(spacing: 16) {
                        CollabTextField(icon: "envelope.fill", placeholder: "И-мэйл", text: $email)
                        CollabTextField(icon: "lock.fill", placeholder: "Нууц үг", text: $password, isSecure: true)
                    }
                    
                    // Login Button
                    Button {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            authManager.login(email: email, password: password, role: selectedRole)
                            dismiss()
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Нэвтрэх")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Register View
struct RegisterView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var preselectedRole: UserRole
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole: UserRole
    @State private var isLoading = false
    
    init(preselectedRole: UserRole) {
        self.preselectedRole = preselectedRole
        _selectedRole = State(initialValue: preselectedRole)
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D1A").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Text("Бүртгүүлэх")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("Collab.mn-д тавтай морил!")
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    .padding(.top, 40)
                    
                    // Role Picker
                    HStack(spacing: 0) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Button {
                                selectedRole = role
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: role == .business ? "briefcase.fill" : "person.2.fill")
                                    Text(role == .business ? "Бизнес" : "Инфлүенсер")
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(selectedRole == role ? Color(hex: "#7C3AED") : Color.clear)
                                .foregroundColor(selectedRole == role ? .white : Color.white.opacity(0.5))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(14)
                    
                    VStack(spacing: 16) {
                        CollabTextField(icon: "person.fill", placeholder: selectedRole == .business ? "Бизнесийн нэр" : "Таны нэр", text: $name)
                        CollabTextField(icon: "envelope.fill", placeholder: "И-мэйл", text: $email)
                        CollabTextField(icon: "lock.fill", placeholder: "Нууц үг", text: $password, isSecure: true)
                    }
                    
                    Button {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            authManager.register(email: email, password: password, name: name, role: selectedRole)
                            dismiss()
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Бүртгүүлэх")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(colors: [Color(hex: "#7C3AED"), Color(hex: "#EC4899")],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Shared Text Field
struct CollabTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#7C3AED"))
                .frame(width: 20)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .keyboardType(placeholder.contains("мэйл") ? .emailAddress : .default)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.07))
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}
