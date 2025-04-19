import Foundation

/// A utility for loading environment variables from .env files
struct DotEnv {
    static var shared = DotEnv()
    
    private var variables: [String: String] = [:]
    
    init() {
        loadEnvFile()
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