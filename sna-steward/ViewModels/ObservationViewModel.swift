import Foundation
import SwiftUI // Added for ObservableObject

@MainActor
class ObservationViewModel: ObservableObject {
    @Published var observation: Observation // Renamed from report
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Assuming ObservationRepository exists and is adapted for the new Observation model
    private let repository = ObservationRepository.shared 
    
    init(observation: Observation = Observation()) { // Renamed from report
        self.observation = observation
    }
    
    // MARK: - Form Validation
    var isValid: Bool {
        !observation.siteName.isEmpty &&
        !observation.stewardName.isEmpty
    }
    
    // MARK: - Save and Submit (Updated)
    func saveObservation() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let savedObservation = try await repository.saveObservation(observation)
            self.observation = savedObservation 
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to save observation: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    func submitObservation() async throws {
        guard isValid else {
            throw ValidationError.invalidForm
        }
        await saveObservation() 
        if errorMessage != nil {
             throw SubmissionError.saveFailed(errorMessage!)
        }
    }
}

// MARK: - Errors
enum ValidationError: LocalizedError {
    case invalidForm
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "Please fill in all required fields (Site Name, Steward Name)"
        }
    }
}

enum SubmissionError: LocalizedError {
    case saveFailed(String)
    
    var errorDescription: String? {
        switch self {
            case .saveFailed(let msg):
                return "Failed to save observation: \(msg)"
        }
    }
} 