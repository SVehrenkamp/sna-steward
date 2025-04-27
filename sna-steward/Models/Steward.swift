// Models/Steward.swift
import Foundation

struct Steward: Identifiable, Codable, Hashable {
    let id: UUID
    var sna_site: String? // Make it optional if it can be NULL
    let created_at: Date // Supabase sends ISO8601, decoding should handle it

    // Add other fields if needed
} 