import Foundation

enum EnvironmentVariables {
    enum Keys {
        static let supabaseURL = "SUPABASE_URL"
        static let supabaseKey = "SUPABASE_KEY"
    }
    
    // Use the DotEnv utility to get the values from .env file
    static var supabaseURL: String {
        guard let url = DotEnv.shared.get(Keys.supabaseURL) else {
            #if DEBUG
            // For SwiftUI previews, provide a default rather than crashing
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                print("⚠️ Using fallback URL for previews")
                return "https://example-preview-fallback.supabase.co"
            }
            #endif
            
            fatalError("SUPABASE_URL not found in environment variables. Make sure .env file exists.")
        }
        return url
    }
    
    static var supabaseKey: String {
        guard let key = DotEnv.shared.get(Keys.supabaseKey) else {
            #if DEBUG
            // For SwiftUI previews, provide a default rather than crashing
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                print("⚠️ Using fallback key for previews")
                return "example-preview-fallback-key"
            }
            #endif
            
            fatalError("SUPABASE_KEY not found in environment variables. Make sure .env file exists.")
        }
        return key
    }
} 