import Foundation

/// A utility for loading environment variables from .env files
struct DotEnv {
    static var shared = DotEnv()
    
    private var variables: [String: String] = [:]
    
    init(skipFileLoading: Bool = false) {
        if !skipFileLoading {
            loadEnvFile()
        }
    }
    
    /// Access an environment variable
    /// - Parameter key: The environment variable key
    /// - Returns: The value if found, nil otherwise
    func get(_ key: String) -> String? {
        // First check if it's in the environment variables set in the process
        if let value = ProcessInfo.processInfo.environment[key] {
            return value
        }
        
        // Next check our loaded .env variables
        return variables[key]
    }
    
    /// Setup mock environment variables for previews
    static func setupForPreviews() {
        print("🔧 Setting up mock environment for previews")
        
        // Create a completely new instance that skips loading from file
        var previewEnv = DotEnv(skipFileLoading: true)
        
        // Add mock values for Supabase - these need to be valid formatted values
        // even though they don't need to point to a real Supabase instance
        let mockURL = "https://mockproject.supabase.co" 
        let mockKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mockkey.T7lOqPdODFmcmVh8VvgUsITLGkBCOuRXz2MxWgBxVD0"
        
        previewEnv.variables[EnvironmentVariables.Keys.supabaseURL] = mockURL
        previewEnv.variables[EnvironmentVariables.Keys.supabaseKey] = mockKey
        
        // Also set them in the process environment for processes that check there directly
        setenv(EnvironmentVariables.Keys.supabaseURL, mockURL, 1)
        setenv(EnvironmentVariables.Keys.supabaseKey, mockKey, 1)
        
        // Replace the shared instance
        shared = previewEnv
        
        print("✅ Mock environment setup complete")
        
        // Verify the values are accessible
        if let url = shared.get(EnvironmentVariables.Keys.supabaseURL),
           let key = shared.get(EnvironmentVariables.Keys.supabaseKey) {
            print("🔍 Mock values set: URL=\(url)")
        } else {
            print("❌ Failed to verify mock values!")
        }
    }
    
    /// Load environment variables from .env file
    private mutating func loadEnvFile() {
        guard let projectDirectory = getProjectDirectory(),
              let fileContents = try? String(contentsOfFile: projectDirectory + "/.env", encoding: .utf8) else {
            print("Could not find or read .env file")
            return
        }
        
        // Parse the .env file
        let lines = fileContents.components(separatedBy: .newlines)
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skip empty lines and comments
            if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") {
                continue
            }
            
            // Parse KEY=VALUE format
            let parts = trimmedLine.components(separatedBy: "=")
            if parts.count >= 2 {
                let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = parts[1..<parts.count].joined(separator: "=").trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Remove quotes if present
                var processedValue = value
                if value.hasPrefix("\"") && value.hasSuffix("\"") {
                    processedValue = String(value.dropFirst().dropLast())
                }
                
                variables[key] = processedValue
            }
        }
    }
    
    /// Find the project directory containing the .env file
    private func getProjectDirectory() -> String? {
        // Try current directory first
        let currentDirectory = FileManager.default.currentDirectoryPath
        if FileManager.default.fileExists(atPath: currentDirectory + "/.env") {
            return currentDirectory
        }
        
        // Try bundle path
        let bundlePath = Bundle.main.bundlePath
        if FileManager.default.fileExists(atPath: bundlePath + "/.env") {
            return bundlePath
        }
        
        // Try one directory up (common in Xcode projects)
        let parentPath = URL(fileURLWithPath: Bundle.main.bundlePath).deletingLastPathComponent().path
        if FileManager.default.fileExists(atPath: parentPath + "/.env") {
            return parentPath
        }
        
        return nil
    }
} 
