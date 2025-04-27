import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private let supabaseURL = URL(string: EnvironmentVariables.supabaseURL)!
    private let supabaseKey = EnvironmentVariables.supabaseKey
    
    lazy var client = SupabaseClient(
        supabaseURL: supabaseURL,
        supabaseKey: supabaseKey
    )
    
    private init() {}
    
    // Auth methods
    func signUp(email: String, password: String) async throws -> AuthResponse {
        try await client.auth.signUp(
            email: email,
            password: password
        )
    }
    
    func signIn(email: String, password: String) async throws -> Session {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    func signInWithMagicLink(email: String) async throws {
        try await client.auth.signInWithOTP(
            email: email
        )
    }
    
    // Optional: Method to handle sign-in from a deep link URL
    func sessionFromDeeplink(url: URL) async throws -> Session {
        try await client.auth.session(from: url)
    }
    
    // Database methods - examples to be expanded as needed
    func fetchData<T: Decodable>(from table: String) async throws -> [T] {
        try await client.database
            .from(table)
            .select()
            .execute()
            .value
    }
    
    func insert<T: Encodable, R: Decodable>(to table: String, values: T) async throws -> R {
        try await client.database
            .from(table)
            .insert(values)
            .execute()
            .value
    }
    
    func update<T: Encodable, R: Decodable>(table: String, values: T, match: [String: PostgrestFilterValue]) async throws -> R {
        try await client.database
            .from(table)
            .update(values)
            .match(match)
            .execute()
            .value
    }
}

// Helper Error Enum (Optional, but good practice)
enum AuthError: Error {
    case sessionNotFound
}

extension SupabaseManager {
    // Assumes you have a Steward struct defined as shown above
    func fetchCurrentUserStewardProfile() async throws -> Steward? {
        guard let userId = try? await client.auth.user().id else {
            throw AuthError.sessionNotFound // Or a more specific error
        }

        // Fetch the single row matching the user's ID
        let profile: Steward = try await client.database
            .from("stewards")
            .select() // Selects all columns by default
            .eq("id", value: userId) // Filter by the user ID
            .single() // Expect exactly one row
            .execute()
            .value

        return profile
    }

    func updateSnaSiteForCurrentUser(newSite: String?) async throws {
         guard let userId = try? await client.auth.user().id else {
            throw AuthError.sessionNotFound // Or a more specific error
        }

        struct UpdatePayload: Encodable {
            let sna_site: String?
        }
        let payload = UpdatePayload(sna_site: newSite)

        // Update the row matching the user's ID
        try await client.database
            .from("stewards")
            .update(payload) // Update only the specified fields
            .eq("id", value: userId) // Filter by the user ID
            .execute()

        // Note: .execute() for update doesn't return the updated row by default.
        // If you need the updated row, you might need to fetch it again or adjust Supabase settings/query.
    }
} 
