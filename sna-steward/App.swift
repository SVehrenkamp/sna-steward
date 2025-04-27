import SwiftUI

@main
struct SNAStewardApp: App {
  // Initialize environment and Supabase at app startup
  init() {
      // Ensure DotEnv is loaded first to populate environment variables
      _ = DotEnv.shared
      
      // Initialize Supabase manager after environment variables are loaded
      _ = SupabaseManager.shared
  }
  
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            if authViewModel.isFirstTimeUser {
                SelectSnaSiteView(viewModel: authViewModel)
            } else {
                MainTabView(viewModel: authViewModel)
            }
        } else {
            SignInView(viewModel: authViewModel)
        }
    }
} 
