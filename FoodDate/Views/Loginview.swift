//
//  loginView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 9/23/24.
//
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String?
    @State private var showRegistration = false
    @State private var showResetAlert = false
    @State private var resetEmail = ""
    @State private var resetMessage = ""
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        ZStack {
            // Background gradient (two-tone for depth)
            LinearGradient(
                colors: [Color(hex: "f194c7"), Color(hex: "ffbfd8")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    Image("logo")
                      .renderingMode(.original)
                      .resizable()
                      .scaledToFit()
                      .frame(height: 100)
                      .padding(16)
                      .background(
                        RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial)
                      )
                      .overlay( // pink tint on top of the material
                        RoundedRectangle(cornerRadius: 18)
                          .fill(Color(hex: "f194c7").opacity(0.25))
                      )
                      .overlay(
                        RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.15), lineWidth: 1)
                      )
                      .shadow(color: .black.opacity(0.2), radius: 18, y: 10)



                    // Headline
                    Text("Welcome")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(radius: 8, y: 3)

                    // Card
                    VStack(spacing: 16) {
                        // Email
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .imageScale(.medium)
                                .foregroundStyle(.secondary)
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .focused($focusedField, equals: .email)
                        }
                        .modifier(InputFieldStyle())

                        // Password with eye toggle
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .imageScale(.medium)
                                .foregroundStyle(.secondary)

                            Group {
                                if showPassword {
                                    TextField("Password", text: $password)
                                } else {
                                    SecureField("Password", text: $password)
                                }
                            }
                            .focused($focusedField, equals: .password)

                            Button {
                                withAnimation { showPassword.toggle() }
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                        }
                        .modifier(InputFieldStyle())

                        // Error message
                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Forgot password
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                resetEmail = email
                                showResetAlert = true
                            }
                            .buttonStyle(LinkCapsuleStyle())
                        }

                        // Login
                        Button {
                            validateCredentials()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Log In")
                                    .fontWeight(.semibold)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        // Divider text
                        HStack {
                            Rectangle().fill(.secondary.opacity(0.3)).frame(height: 1)
                            Text("or")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Rectangle().fill(.secondary.opacity(0.3)).frame(height: 1)
                        }

                        // Register
                        Button {
                            showRegistration.toggle()
                        } label: {
                            Text("Create an account")
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    .padding(20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(radius: 18, y: 10)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
                .font(.system(.body, design: .rounded)) // base font for the card
            }
        }
        .sheet(isPresented: $showRegistration) {
            RegistrationView()
        }
        .alert("Reset Password", isPresented: $showResetAlert, actions: {
            TextField("Enter your email", text: $resetEmail)
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
            Button("Send Reset Link", action: sendPasswordReset)
            Button("Cancel", role: .cancel) { }
        }, message: {
            Text(resetMessage)
        })
        .onSubmit {
            if focusedField == .email { focusedField = .password }
            else { validateCredentials() }
        }
        .submitLabel(.go)
    }

    // Replace with your real Firebase login later
    func validateCredentials() {
        let validUser = "Lorenzojh"
        let validPass = "Juicewrld999"
        if email == validUser && password == validPass {
            isLoggedIn = true
            errorMessage = nil
        } else {
            withAnimation { errorMessage = "Invalid username or password" }
        }
    }

    func sendPasswordReset() {
        Auth.auth().sendPasswordReset(withEmail: resetEmail) { error in
            if let error = error {
                resetMessage = "Error: \(error.localizedDescription)"
            } else {
                resetMessage = "Password reset email sent."
            }
        }
    }
}

// MARK: - Styles & Helpers

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 10, y: 4)
                    .opacity(0.95)
            )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .font(.system(.body, design: .rounded))
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(configuration.isPressed ? Color.blue.opacity(0.8) : Color.blue)
            )
            .shadow(radius: configuration.isPressed ? 4 : 10, y: 6)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .font(.system(.body, design: .rounded))
            .foregroundStyle(Color.blue)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.blue.opacity(0.25), lineWidth: 1)
            )
            .shadow(radius: configuration.isPressed ? 2 : 8, y: 5)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

struct LinkCapsuleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote.bold())
            .foregroundStyle(.blue.opacity(configuration.isPressed ? 0.6 : 1))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule(style: .continuous)
                    .fill(.white.opacity(configuration.isPressed ? 0.25 : 0.15))
            )
    }
}

// Hex color helper (unchanged)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB,
                  red: Double(r)/255,
                  green: Double(g)/255,
                  blue: Double(b)/255,
                  opacity: Double(a)/255)
    }
}

/**
struct Previews_Loginview_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn:.constant(false))
    }
}
*/
