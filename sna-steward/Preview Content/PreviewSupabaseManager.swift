import Foundation
import Supabase
import ObjectiveC

/// A special version of SupabaseManager for SwiftUI previews
class PreviewSupabaseManager {
    /// Shared preview instance
    static let shared = PreviewSupabaseManager()
    
    /// Mock Supabase URL
    private let supabaseURL = URL(string: "https://example-preview.supabase.co")!
    
    /// Mock Supabase key
    private let supabaseKey = "example-preview-anon-key"
    
    /// Mock Supabase client
    lazy var client = SupabaseClient(
        supabaseURL: supabaseURL,
        supabaseKey: supabaseKey
    )
    
    private init() {}
    
    /// Setup the environment for previews
    static func setupPreviewEnvironment() {
        // Set up mock environment variables first
        DotEnv.setupForPreviews()
        
        // Note: We don't actually replace the shared instance in preview mode
        // as it would require unsafe runtime manipulation
        print("📱 Using PreviewSupabaseManager for previews")
    }
    
    // MARK: - Mock Auth Methods
    
    func signIn(email: String, password: String) async throws -> Session {
        // Return a mock session with the correct parameters
        return Session(
            providerToken: nil,
            providerRefreshToken: nil,
            accessToken: "mock-access-token",
            tokenType: "bearer",
            expiresIn: 3600,
            expiresAt: Date().timeIntervalSince1970 + 3600,
            refreshToken: "mock-refresh-token",
            weakPassword: nil,
            user: createMockUser(email: email)
        )
    }
    
    func signUp(email: String, password: String) async throws -> AuthResponse {
        // For preview purposes, just sign in since we don't need an actual AuthResponse
        // This avoids serialization issues with the real AuthResponse
        _ = createMockUser(email: email)
        
        // Throw a custom error that we can catch in the preview
        struct PreviewSignUpSuccess: Error, LocalizedError {
            var errorDescription: String? { "Preview sign-up successful. This is expected." }
        }
        throw PreviewSignUpSuccess()
    }
    
    func signOut() async throws {
        // Mock sign out - does nothing in preview
    }
    
    func signInWithMagicLink(email: String) async throws {
        // Mock sending magic link - does nothing in preview
    }
    
    // MARK: - Helper Methods
    
    private func createMockUser(email: String) -> User {
        return User(
            id: UUID(),
            appMetadata: [:],
            userMetadata: [:],
            aud: "authenticated",
            confirmationSentAt: nil,
            recoverySentAt: nil,
            emailChangeSentAt: nil,
            newEmail: nil,
            invitedAt: nil,
            actionLink: nil,
            email: email,
            phone: nil,
            createdAt: Date(),
            confirmedAt: Date(),
            emailConfirmedAt: Date(),
            phoneConfirmedAt: nil,
            lastSignInAt: Date(),
            role: nil,  // Use 'role' instead of 'roleId'
            updatedAt: Date(),
            identities: nil,
            factors: nil
        )
    }
    
    // MARK: - Mock Database Methods
    
    func updateSnaSiteForCurrentUser(newSite: String) async throws {
        // Mock updating SNA site - does nothing in preview
    }
    
    func fetchCurrentUserStewardProfile() async throws -> StewardProfile? {
        // Return a mock profile
        return StewardProfile(
            id: UUID(),
            user_id: UUID(),
            sna_site: "Green Valley SNA",
            created_at: Date(),
            updated_at: Date()
        )
    }
} 