import SwiftUI

struct ObservationReportView: View {
    @StateObject private var viewModel = ObservationReportViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Information
                Section("Site Information") {
                    TextField("Site Name", text: $viewModel.report.siteName)
                    TextField("Steward Name", text: $viewModel.report.stewardName)
                    DatePicker("Visit Date", selection: $viewModel.report.visitDate, displayedComponents: [.date, .hourAndMinute])
                    TextField("Length of Visit", text: $viewModel.report.visitLength)
                }
                
                // New Observations
                Section("New Observations") {
                    TextEditor(text: $viewModel.report.invasiveSpecies)
                        .frame(height: 100)
                        .overlay(
                            Text("Invasive Species")
                                .foregroundColor(.gray)
                                .opacity(viewModel.report.invasiveSpecies.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.report.rareSpecies)
                        .frame(height: 100)
                        .overlay(
                            Text("Rare Species")
                                .foregroundColor(.gray)
                                .opacity(viewModel.report.rareSpecies.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.report.currentlyBlooming)
                        .frame(height: 100)
                        .overlay(
                            Text("Currently Blooming")
                                .foregroundColor(.gray)
                                .opacity(viewModel.report.currentlyBlooming.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.report.wildlifeObserved)
                        .frame(height: 100)
                        .overlay(
                            Text("Wildlife Observed")
                                .foregroundColor(.gray)
                                .opacity(viewModel.report.wildlifeObserved.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.report.visitorUse)
                        .frame(height: 100)
                        .overlay(
                            Text("Visitor Use")
                                .foregroundColor(.gray)
                                .opacity(viewModel.report.visitorUse.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                }
                
                // Problems or Illegal Activities
                Section("Problems or Illegal Activities") {
                    Toggle("Garbage", isOn: $viewModel.report.hasGarbage)
                    Toggle("Camping/Campfires", isOn: $viewModel.report.hasCamping)
                    Toggle("Illegal Vehicle Use", isOn: $viewModel.report.hasIllegalVehicleUse)
                    Toggle("Deer Stands", isOn: $viewModel.report.hasDeerStands)
                    Toggle("Vegetation Damage", isOn: $viewModel.report.hasVegetationDamage)
                    Toggle("Natural Disturbance", isOn: $viewModel.report.hasNaturalDisturbance)
                    TextField("Other Problems", text: Binding(
                        get: { viewModel.report.otherProblems ?? "" },
                        set: { viewModel.report.otherProblems = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // Management Activities
                Section("Management Activities Needed") {
                    Toggle("Tree/Brush Cutting", isOn: $viewModel.report.needsTreeBrushCutting)
                    Toggle("Invasive Removal/Treatment", isOn: $viewModel.report.needsInvasiveRemoval)
                    Toggle("Prescribe Burn/Mowing", isOn: $viewModel.report.needsPrescribedBurn)
                    TextField("Other Management Needed", text: Binding(
                        get: { viewModel.report.otherManagementNeeded ?? "" },
                        set: { viewModel.report.otherManagementNeeded = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // Completed Activities
                Section("Activities Completed") {
                    Toggle("Tree/Brush Cutting", isOn: $viewModel.report.completedTreeBrushCutting)
                    Toggle("Invasive Removal/Treatment", isOn: $viewModel.report.completedInvasiveRemoval)
                    Toggle("Garbage Removal", isOn: $viewModel.report.completedGarbageRemoval)
                    TextField("Other Completed Activities", text: Binding(
                        get: { viewModel.report.otherCompletedActivities ?? "" },
                        set: { viewModel.report.otherCompletedActivities = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // Inspection
                Section("Inspection Items") {
                    Toggle("Entrance Sign", isOn: $viewModel.report.hasEntranceSign)
                    Toggle("Interpretive Signs", isOn: $viewModel.report.hasInterpretiveSigns)
                    Toggle("Boundary Signs", isOn: $viewModel.report.hasBoundarySigns)
                    Toggle("Rules/Other Signs", isOn: $viewModel.report.hasRulesSigns)
                    Toggle("Parking Areas", isOn: $viewModel.report.hasParking)
                    Toggle("Trails", isOn: $viewModel.report.hasTrails)
                    Toggle("Fencing/Exclosures", isOn: $viewModel.report.hasFencing)
                    TextField("Other Inspection Items", text: Binding(
                        get: { viewModel.report.otherInspectionItems ?? "" },
                        set: { viewModel.report.otherInspectionItems = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
            .navigationTitle("Observation Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        Task {
                            do {
                                try await viewModel.submitReport()
                                dismiss()
                            } catch {
                                alertMessage = error.localizedDescription
                                showingAlert = true
                            }
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    ObservationReportView()
} 