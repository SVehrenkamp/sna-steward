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
