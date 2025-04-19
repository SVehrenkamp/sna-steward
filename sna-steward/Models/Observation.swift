import Foundation

struct Observation: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var latitude: Double
    var longitude: Double
    var date: Date
    var images: [String]?
    var createdBy: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case latitude
        case longitude
        case date
        case images
        case createdBy = "created_by"
    }
}

// Repository to handle Supabase interactions for Observations
class ObservationRepository {
    static let shared = ObservationRepository()
    private let supabase = SupabaseManager.shared
    private let tableName = "observations"
    
    private init() {}
    
    func fetchObservations() async throws -> [Observation] {
        return try await supabase.fetchData(from: tableName)
    }
    
    func saveObservation(_ observation: Observation) async throws -> Observation {
        return try await supabase.insert(to: tableName, values: observation)
    }
    
    func updateObservation(_ observation: Observation) async throws -> Observation {
        return try await supabase.update(
            table: tableName,
            values: observation,
            match: ["id": observation.id.uuidString]
        )
    }
} 