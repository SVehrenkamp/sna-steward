import Foundation

struct ObservationReport: Identifiable, Codable {
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