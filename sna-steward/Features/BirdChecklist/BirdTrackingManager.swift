import Foundation

@MainActor
class BirdTrackingManager: ObservableObject {
    static let shared = BirdTrackingManager()
    @Published private(set) var trackedBirds: Set<UUID> = []
    
    private init() {
        // Load saved state
        if let data = UserDefaults.standard.data(forKey: "trackedBirds"),
           let decoded = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            trackedBirds = decoded
        }
    }
    
    func toggleBird(_ bird: Bird) {
        if trackedBirds.contains(bird.id) {
            trackedBirds.remove(bird.id)
        } else {
            trackedBirds.insert(bird.id)
        }
        saveState()
    }
    
    func isTracked(_ bird: Bird) -> Bool {
        trackedBirds.contains(bird.id)
    }
    
    func getBirdCount() -> Int {
     trackedBirds.count
    }
  
    private func saveState() {
        if let encoded = try? JSONEncoder().encode(trackedBirds) {
            UserDefaults.standard.set(encoded, forKey: "trackedBirds")
        }
    }
} 
