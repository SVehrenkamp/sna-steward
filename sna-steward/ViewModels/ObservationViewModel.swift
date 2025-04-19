import Foundation
import SwiftUI

class ObservationViewModel: ObservableObject {
    @Published var observations: [Observation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = ObservationRepository.shared
    
    // Fetch all observations
    func fetchObservations() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedObservations = try await repository.fetchObservations()
                
                await MainActor.run {
                    self.observations = fetchedObservations
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch observations: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // Save a new observation
    func saveObservation(_ observation: Observation) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let savedObservation = try await repository.saveObservation(observation)
                
                await MainActor.run {
                    if let index = self.observations.firstIndex(where: { $0.id == savedObservation.id }) {
                        self.observations[index] = savedObservation
                    } else {
                        self.observations.append(savedObservation)
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to save observation: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // Update an existing observation
    func updateObservation(_ observation: Observation) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let updatedObservation = try await repository.updateObservation(observation)
                
                await MainActor.run {
                    if let index = self.observations.firstIndex(where: { $0.id == updatedObservation.id }) {
                        self.observations[index] = updatedObservation
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to update observation: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
} 