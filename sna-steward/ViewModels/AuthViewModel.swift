import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    // Published properties for UI binding
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedSnaSite: String?
    @Published var isFirstTimeUser = false
    @Published var showBiometricSignIn = false
    
    // Private properties
    private var cancellables = Set<AnyCancellable>()
    private let supabaseManager = SupabaseManager.shared
    private let secureStorage = SecureStorage.shared
    private let biometricsHelper = BiometricAuthHelper.shared
    
    init() {
        // Check if biometrics should be shown
        showBiometricSignIn = secureStorage.getBool(for: .biometricsEnabled) && 
                              biometricsHelper.biometricType() != .none &&
                              secureStorage.hasAuthTokens()
        
        // Check authentication state
        checkAuthState()
    }
    
    // MARK: - Public Methods
    
    // Sign in with email and password
    func signIn() async {
        errorMessage = nil
        isLoading = true
        
        do {
            let session = try await supabaseManager.signIn(email: email, password: password)
            
            // Store tokens in Keychain
            secureStorage.saveAuthTokens(
                accessToken: session.accessToken,
                refreshToken: session.refreshToken,
                userId: session.user.id.uuidString
            )
            
            // Check if user is new
            await checkIfFirstTimeUser()
            
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Sign up with email and password
    func signUp() async {
        errorMessage = nil
        isLoading = true
        
        do {
            let response = try await supabaseManager.signUp(email: email, password: password)
            
            DispatchQueue.main.async {
                self.isLoading = false
                if response.user != nil {
                    // User created successfully - auto sign-in will happen if email confirmation is not required
                    self.isFirstTimeUser = true
                }
                // Note: In production app, you might want to show a "verification email sent" message
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Send magic link
    func sendMagicLink() async {
        errorMessage = nil
        isLoading = true
        
        do {
            try await supabaseManager.signInWithMagicLink(email: email)
            
            DispatchQueue.main.async {
                self.isLoading = false
                // Show success message or navigate to "check your email" screen
                self.errorMessage = "Magic link sent to your email"
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Sign in with biometrics
    func signInWithBiometrics() async {
        errorMessage = nil
        isLoading = true
        
        do {
            // 1. Authenticate with biometrics
            try await biometricsHelper.authenticate(reason: "Sign in to SNA Steward")
            
            // 2. Get stored tokens
            guard let refreshToken = secureStorage.getValue(for: .refreshToken),
                  let accessToken = secureStorage.getValue(for: .accessToken) else {
                throw BiometricAuthHelper.BiometricError.authenticationFailed
            }
            
            // 3. Set the session in Supabase client
            // This part depends on how your Supabase client is set up to restore a session
            // You might need to manually create a session object and set it
            // For now, we'll just set the authenticated flag
            
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                if let biometricError = error as? BiometricAuthHelper.BiometricError {
                    self.errorMessage = biometricError.errorDescription
                } else {
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
    
    // Save SNA site for first-time user
    func saveSnaSite() async {
        guard let site = selectedSnaSite, !site.isEmpty else {
            errorMessage = "Please select an SNA site"
            return
        }
        
        isLoading = true
        
        do {
            try await supabaseManager.updateSnaSiteForCurrentUser(newSite: site)
            
            DispatchQueue.main.async {
                self.isFirstTimeUser = false
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Enable biometric sign-in
    func enableBiometricSignIn() {
        secureStorage.save(value: true, for: .biometricsEnabled)
        showBiometricSignIn = true
    }
    
    // Disable biometric sign-in
    func disableBiometricSignIn() {
        secureStorage.save(value: false, for: .biometricsEnabled)
        showBiometricSignIn = false
    }
    
    // Sign out
    func signOut() async {
        isLoading = true
        
        do {
            try await supabaseManager.signOut()
            
            // Clear stored tokens
            secureStorage.clearAuthTokens()
            
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.isLoading = false
                self.email = ""
                self.password = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func checkAuthState() {
        Task {
            do {
                // This depends on how your Supabase client works
                // You might need to check if there's a valid session
                let _ = try await supabaseManager.client.auth.session
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
                await checkIfFirstTimeUser()
            } catch {
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    private func checkIfFirstTimeUser() async {
        do {
            if let profile = try await supabaseManager.fetchCurrentUserStewardProfile(),
               profile.sna_site != nil {
                DispatchQueue.main.async {
                    self.isFirstTimeUser = false
                    self.selectedSnaSite = profile.sna_site
                }
            } else {
                DispatchQueue.main.async {
                    self.isFirstTimeUser = true
                }
            }
        } catch {
            DispatchQueue.main.async {
                // If we can't fetch profile, assume first time
                self.isFirstTimeUser = true
            }
        }
    }
} 