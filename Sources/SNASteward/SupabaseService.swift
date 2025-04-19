import Foundation
import Supabase

public class SupabaseService {
    public static let shared = SupabaseService()
    
    private let supabaseURL: URL
    private let supabaseKey: String
    
    public lazy var client: SupabaseClient = {
        SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }()
    
    private init() {
        // Try to get from environment variables
        if let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
           let url = URL(string: urlString),
           let key = ProcessInfo.processInfo.environment["SUPABASE_KEY"] {
            self.supabaseURL = url
            self.supabaseKey = key
            return
        }
        
        // Try to find .env file
        let fileManager = FileManager.default
        let possiblePaths = [
            fileManager.currentDirectoryPath,
            Bundle.main.bundlePath,
            URL(fileURLWithPath: Bundle.main.bundlePath).deletingLastPathComponent().path
        ]
        
        for path in possiblePaths {
            let envPath = path + "/.env"
            if fileManager.fileExists(atPath: envPath),
               let fileContents = try? String(contentsOfFile: envPath, encoding: .utf8) {
                var urlValue: String?
                var keyValue: String?
                
                let lines = fileContents.components(separatedBy: .newlines)
                for line in lines {
                    let parts = line.split(separator: "=", maxSplits: 1).map(String.init)
                    if parts.count == 2 {
                        let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if key == "SUPABASE_URL" {
                            urlValue = value
                        } else if key == "SUPABASE_KEY" {
                            keyValue = value
                        }
                    }
                }
                
                if let urlString = urlValue, let url = URL(string: urlString), let key = keyValue {
                    self.supabaseURL = url
                    self.supabaseKey = key
                    return
                }
            }
        }
        
        // If we reach here, we couldn't find the environment variables
        fatalError("Could not find SUPABASE_URL and SUPABASE_KEY in environment variables or .env file")
    }
    
    // Add your Supabase service methods here
} 