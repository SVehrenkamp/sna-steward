//
//  sna_stewardApp.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/6/25.
//

import SwiftUI

@main
struct SNA_StewardApp: App {
    // Initialize environment and Supabase at app startup
    init() {
        // Ensure DotEnv is loaded first to populate environment variables
        _ = DotEnv.shared
        
        // Initialize Supabase manager after environment variables are loaded
        _ = SupabaseManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
