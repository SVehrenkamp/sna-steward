import Foundation
import SwiftUI

/// Helper for setting up SwiftUI previews with mocked dependencies
struct PreviewHelper {
    /// Set up all the environment needs for previews
    static func setupPreviewEnvironment() {
        // Set preview flag
        setenv("XCODE_RUNNING_FOR_PREVIEWS", "1", 1)
        
        // First set up the mock environment variables
        DotEnv.setupForPreviews()
        
        print("🔧 Preview environment setup complete")
    }
    
    /// Create a preview-ready AuthViewModel with mocked dependencies
    static func createMockAuthViewModel() -> AuthViewModel {
        // First ensure the environment is set up
        setupPreviewEnvironment()
        
        // Create the view model
        let viewModel = AuthViewModel()
        
        // Setup some default values for convenient preview
        viewModel.selectedSnaSite = "Green Valley SNA"
        
        // Return the configured view model
        return viewModel
    }
    
    /// Create a simplified preview-ready AuthViewModel that appears authenticated
    static func createAuthenticatedViewModel() -> AuthViewModel {
        let viewModel = createMockAuthViewModel()
        viewModel.isAuthenticated = true
        return viewModel
    }
    
    /// Create a simplified preview-ready AuthViewModel for a first-time user
    static func createFirstTimeUserViewModel() -> AuthViewModel {
        let viewModel = createAuthenticatedViewModel()
        viewModel.isFirstTimeUser = true
        return viewModel
    }
} 