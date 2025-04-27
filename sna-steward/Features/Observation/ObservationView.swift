import SwiftUI

struct ObservationView: View {
    @StateObject private var viewModel = ObservationViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Information
                Section("Site Information") {
                    TextField("Site Name", text: $viewModel.observation.siteName)
                    TextField("Steward Name", text: $viewModel.observation.stewardName)
                    DatePicker("Visit Date", selection: $viewModel.observation.visitDate, displayedComponents: [.date, .hourAndMinute])
                    TextField("Length of Visit", text: $viewModel.observation.visitLength)
                }
                
                // New Observations
                Section("New Observations") {
                    TextEditor(text: $viewModel.observation.invasiveSpecies)
                        .frame(height: 100)
                        .overlay(
                            Text("Invasive Species")
                                .foregroundColor(.gray)
                                .opacity(viewModel.observation.invasiveSpecies.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.observation.rareSpecies)
                        .frame(height: 100)
                        .overlay(
                            Text("Rare Species")
                                .foregroundColor(.gray)
                                .opacity(viewModel.observation.rareSpecies.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.observation.currentlyBlooming)
                        .frame(height: 100)
                        .overlay(
                            Text("Currently Blooming")
                                .foregroundColor(.gray)
                                .opacity(viewModel.observation.currentlyBlooming.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.observation.wildlifeObserved)
                        .frame(height: 100)
                        .overlay(
                            Text("Wildlife Observed")
                                .foregroundColor(.gray)
                                .opacity(viewModel.observation.wildlifeObserved.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                    
                    TextEditor(text: $viewModel.observation.visitorUse)
                        .frame(height: 100)
                        .overlay(
                            Text("Visitor Use")
                                .foregroundColor(.gray)
                                .opacity(viewModel.observation.visitorUse.isEmpty ? 1 : 0),
                            alignment: .topLeading
                        )
                }
                
                // Problems or Illegal Activities
                Section("Problems or Illegal Activities") {
                    Toggle("Garbage", isOn: $viewModel.observation.hasGarbage)
                    Toggle("Camping/Campfires", isOn: $viewModel.observation.hasCamping)
                    Toggle("Illegal Vehicle Use", isOn: $viewModel.observation.hasIllegalVehicleUse)
                    Toggle("Deer Stands", isOn: $viewModel.observation.hasDeerStands)
                    Toggle("Vegetation Damage", isOn: $viewModel.observation.hasVegetationDamage)
                    Toggle("Natural Disturbance", isOn: $viewModel.observation.hasNaturalDisturbance)
                    TextField("Other Problems", text: Binding(
                        get: { viewModel.observation.otherProblems ?? "" },
                        set: { viewModel.observation.otherProblems = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // Management Activities
                Section("Management Activities Needed") {
                    Toggle("Tree/Brush Cutting", isOn: $viewModel.observation.needsTreeBrushCutting)
                    Toggle("Invasive Removal/Treatment", isOn: $viewModel.observation.needsInvasiveRemoval)
                    Toggle("Prescribe Burn/Mowing", isOn: $viewModel.observation.needsPrescribedBurn)
                    TextField("Other Management Needed", text: Binding(
                        get: { viewModel.observation.otherManagementNeeded ?? "" },
                        set: { viewModel.observation.otherManagementNeeded = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // Completed Activities
                Section("Activities Completed") {
                    Toggle("Tree/Brush Cutting", isOn: $viewModel.observation.completedTreeBrushCutting)
                    Toggle("Invasive Removal/Treatment", isOn: $viewModel.observation.completedInvasiveRemoval)
                    Toggle("Garbage Removal", isOn: $viewModel.observation.completedGarbageRemoval)
                    TextField("Other Completed Activities", text: Binding(
                        get: { viewModel.observation.otherCompletedActivities ?? "" },
                        set: { viewModel.observation.otherCompletedActivities = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                // Inspection
                Section("Inspection Items") {
                    Toggle("Entrance Sign", isOn: $viewModel.observation.hasEntranceSign)
                    Toggle("Interpretive Signs", isOn: $viewModel.observation.hasInterpretiveSigns)
                    Toggle("Boundary Signs", isOn: $viewModel.observation.hasBoundarySigns)
                    Toggle("Rules/Other Signs", isOn: $viewModel.observation.hasRulesSigns)
                    Toggle("Parking Areas", isOn: $viewModel.observation.hasParking)
                    Toggle("Trails", isOn: $viewModel.observation.hasTrails)
                    Toggle("Fencing/Exclosures", isOn: $viewModel.observation.hasFencing)
                    TextField("Other Inspection Items", text: Binding(
                        get: { viewModel.observation.otherInspectionItems ?? "" },
                        set: { viewModel.observation.otherInspectionItems = $0.isEmpty ? nil : $0 }
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
                                try await viewModel.submitObservation()
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
    ObservationView()
} 