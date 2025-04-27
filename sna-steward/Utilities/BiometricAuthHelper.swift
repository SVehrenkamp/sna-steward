import Foundation
import LocalAuthentication
import Security

class BiometricAuthHelper {
    enum BiometricType {
        case none
        case touchID
        case faceID
        
        var description: String {
            switch self {
            case .none: return "None"
            case .touchID: return "Touch ID"
            case .faceID: return "Face ID"
            }
        }
    }
    
    enum BiometricError: LocalizedError {
        case authenticationFailed
        case userCancel
        case userFallback
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .authenticationFailed: return "Authentication failed"
            case .userCancel: return "User canceled"
            case .userFallback: return "User fallback"
            case .biometryNotAvailable: return "Biometry not available"
            case .biometryNotEnrolled: return "Biometry not enrolled"
            case .biometryLockout: return "Biometry lockout"
            case .unknown: return "Unknown error"
            }
        }
    }
    
    static let shared = BiometricAuthHelper()
    private init() {}
    
    // Check if device supports biometrics
    func biometricType() -> BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            case .none:
                return .none
            @unknown default:
                return .none
            }
        } else {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
    // Authenticate with biometrics
    func authenticate(reason: String) async throws {
        let context = LAContext()
        var authError: NSError?
        
        // Check if we can use biometric authentication
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) else {
            if let error = authError {
                switch error.code {
                case LAError.biometryNotAvailable.rawValue:
                    throw BiometricError.biometryNotAvailable
                case LAError.biometryNotEnrolled.rawValue:
                    throw BiometricError.biometryNotEnrolled
                case LAError.biometryLockout.rawValue:
                    throw BiometricError.biometryLockout
                default:
                    throw BiometricError.unknown
                }
            }
            throw BiometricError.unknown
        }
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            if !success {
                throw BiometricError.authenticationFailed
            }
        } catch let error as LAError {
            switch error.code {
            case .authenticationFailed:
                throw BiometricError.authenticationFailed
            case .userCancel:
                throw BiometricError.userCancel
            case .userFallback:
                throw BiometricError.userFallback
            case .biometryNotAvailable:
                throw BiometricError.biometryNotAvailable
            case .biometryNotEnrolled:
                throw BiometricError.biometryNotEnrolled
            case .biometryLockout:
                throw BiometricError.biometryLockout
            default:
                throw BiometricError.unknown
            }
        }
    }
} 