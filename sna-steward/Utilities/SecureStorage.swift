import Foundation
import Security

class SecureStorage {
    enum Keys: String {
        case refreshToken = "auth.refreshToken"
        case accessToken = "auth.accessToken"
        case userId = "auth.userId"
        case biometricsEnabled = "auth.biometricsEnabled"
    }
    
    static let shared = SecureStorage()
    private let service = Bundle.main.bundleIdentifier ?? "com.sna-steward"
    
    private init() {}
    
    // MARK: - Save methods
    
    func save(value: String, for key: Keys) -> Bool {
        let data = value.data(using: .utf8)!
        
        // Query to see if the item already exists
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue
        ]
        
        // Remove any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add the new item
        let saveQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // Save Bool
    func save(value: Bool, for key: Keys) -> Bool {
        return save(value: value ? "true" : "false", for: key)
    }
    
    // MARK: - Get methods
    
    func getValue(for key: Keys) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, 
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    // Get Bool
    func getBool(for key: Keys) -> Bool {
        guard let value = getValue(for: key) else {
            return false
        }
        return value == "true"
    }
    
    // MARK: - Delete methods
    
    func delete(key: Keys) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    // MARK: - Helper methods
    
    // Save all auth tokens
    func saveAuthTokens(accessToken: String, refreshToken: String, userId: String) {
        _ = save(value: accessToken, for: .accessToken)
        _ = save(value: refreshToken, for: .refreshToken)
        _ = save(value: userId, for: .userId)
    }
    
    // Delete all auth tokens
    func clearAuthTokens() {
        _ = delete(key: .accessToken)
        _ = delete(key: .refreshToken)
        _ = delete(key: .userId)
    }
    
    // Check if tokens exist
    func hasAuthTokens() -> Bool {
        return getValue(for: .refreshToken) != nil && getValue(for: .accessToken) != nil
    }
} 