import Foundation

@MainActor
class ObservationReportViewModel: ObservableObject {
    @Published var report: ObservationReport
    
    init(report: ObservationReport = ObservationReport()) {
        self.report = report
    }
    
    // MARK: - Form Validation
    var isValid: Bool {
        !report.siteName.isEmpty &&
        !report.stewardName.isEmpty
    }
    
    // MARK: - Save and Submit
    func saveReport() async throws {
        // TODO: Implement saving to local storage or backend
    }
    
    func submitReport() async throws {
        guard isValid else {
            throw ValidationError.invalidForm
        }
        
        // TODO: Implement submission to sna.dnr@state.mn.us
    }
}

// MARK: - Errors
enum ValidationError: LocalizedError {
    case invalidForm
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "Please fill in all required fields"
        }
    }
} 