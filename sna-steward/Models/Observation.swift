import SwiftUI

struct Observation: Identifiable, Codable { // Renamed from ObservationReport
    let id: UUID
    var siteName: String
    var stewardName: String
    var visitDate: Date
    var visitLength: String
    
    // New Observations
    var invasiveSpecies: String
    var rareSpecies: String
    var currentlyBlooming: String
    var wildlifeObserved: String
    var visitorUse: String
    
    // Problems or Illegal Activities
    var hasGarbage: Bool
    var hasCamping: Bool
    var hasIllegalVehicleUse: Bool
    var hasDeerStands: Bool
    var hasVegetationDamage: Bool
    var hasNaturalDisturbance: Bool
    var otherProblems: String?
    
    // Management Activities
    var needsTreeBrushCutting: Bool
    var needsInvasiveRemoval: Bool
    var needsPrescribedBurn: Bool
    var otherManagementNeeded: String?
    
    // Completed Activities
    var completedTreeBrushCutting: Bool
    var completedInvasiveRemoval: Bool
    var completedGarbageRemoval: Bool
    var otherCompletedActivities: String?
    
    // Inspection Items
    var hasEntranceSign: Bool
    var hasInterpretiveSigns: Bool
    var hasBoundarySigns: Bool
    var hasRulesSigns: Bool
    var hasParking: Bool
    var hasTrails: Bool
    var hasFencing: Bool
    var otherInspectionItems: String?

    // Added CodingKeys for snake_case mapping
    enum CodingKeys: String, CodingKey {
        case id
        case siteName = "site_name"
        case stewardName = "steward_name"
        case visitDate = "visit_date"
        case visitLength = "visit_length"
        case invasiveSpecies = "invasive_species"
        case rareSpecies = "rare_species"
        case currentlyBlooming = "currently_blooming"
        case wildlifeObserved = "wildlife_observed"
        case visitorUse = "visitor_use"
        case hasGarbage = "has_garbage"
        case hasCamping = "has_camping"
        case hasIllegalVehicleUse = "has_illegal_vehicle_use"
        case hasDeerStands = "has_deer_stands"
        case hasVegetationDamage = "has_vegetation_damage"
        case hasNaturalDisturbance = "has_natural_disturbance"
        case otherProblems = "other_problems"
        case needsTreeBrushCutting = "needs_tree_brush_cutting"
        case needsInvasiveRemoval = "needs_invasive_removal"
        case needsPrescribedBurn = "needs_prescribed_burn"
        case otherManagementNeeded = "other_management_needed"
        case completedTreeBrushCutting = "completed_tree_brush_cutting"
        case completedInvasiveRemoval = "completed_invasive_removal"
        case completedGarbageRemoval = "completed_garbage_removal"
        case otherCompletedActivities = "other_completed_activities"
        case hasEntranceSign = "has_entrance_sign"
        case hasInterpretiveSigns = "has_interpretive_signs"
        case hasBoundarySigns = "has_boundary_signs"
        case hasRulesSigns = "has_rules_signs"
        case hasParking = "has_parking"
        case hasTrails = "has_trails"
        case hasFencing = "has_fencing"
        case otherInspectionItems = "other_inspection_items"
    }
    
    init(id: UUID = UUID(), siteName: String = "", stewardName: String = "", visitDate: Date = Date(), visitLength: String = "") {
        self.id = id
        self.siteName = siteName
        self.stewardName = stewardName
        self.visitDate = visitDate
        self.visitLength = visitLength
        
        // Initialize all other properties with default values
        self.invasiveSpecies = ""
        self.rareSpecies = ""
        self.currentlyBlooming = ""
        self.wildlifeObserved = ""
        self.visitorUse = ""
        
        self.hasGarbage = false
        self.hasCamping = false
        self.hasIllegalVehicleUse = false
        self.hasDeerStands = false
        self.hasVegetationDamage = false
        self.hasNaturalDisturbance = false
        
        self.needsTreeBrushCutting = false
        self.needsInvasiveRemoval = false
        self.needsPrescribedBurn = false
        
        self.completedTreeBrushCutting = false
        self.completedInvasiveRemoval = false
        self.completedGarbageRemoval = false
        
        self.hasEntranceSign = false
        self.hasInterpretiveSigns = false
        self.hasBoundarySigns = false
        self.hasRulesSigns = false
        self.hasParking = false
        self.hasTrails = false
        self.hasFencing = false
    }
} 

// Repository to handle Supabase interactions for Observations
// Adapted for the new Observation struct (previously ObservationReport)
class ObservationRepository {
    static let shared = ObservationRepository()
    // Assuming SupabaseManager.shared exists and is configured
    private let supabase = SupabaseManager.shared 
    private let tableName = "observations"
    
    private init() {}
    
    // Fetches all observations (might need pagination for large datasets)
    func fetchObservations() async throws -> [Observation] {
        // Ensure SupabaseManager.fetchData can decode the new Observation struct
        return try await supabase.fetchData(from: tableName)
    }
    
    // Saves an observation (handles insert or update based on existence)
    // Note: Supabase typically uses upsert for this, or separate insert/update calls.
    // This example assumes an `insert` function that might need adjustment
    // depending on SupabaseManager's capabilities.
    func saveObservation(_ observation: Observation) async throws -> Observation {
         // We might need an `upsert` or check if exists then `update` vs `insert`
         // Using insert for now, assuming SupabaseManager handles potential conflicts or we need separate logic
        print("Attempting to save observation with ID: \(observation.id)")
        return try await supabase.insert(to: tableName, values: observation) 
    }
    
    // Explicit update function if needed
    func updateObservation(_ observation: Observation) async throws -> Observation {
        print("Attempting to update observation with ID: \(observation.id)")
        return try await supabase.update(
            table: tableName,
            values: observation,
            match: ["id": observation.id.uuidString]
        )
    }
    
    // Delete function might also be needed
    // func deleteObservation(_ observation: Observation) async throws { ... }
} 