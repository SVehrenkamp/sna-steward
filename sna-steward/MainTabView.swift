import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ObservationReportsView()
                .tabItem {
                    Label("Reports", systemImage: "doc.text")
                }
            
            ChecklistsView()
                .tabItem {
                    Label("Checklists", systemImage: "checklist")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
        .tint(Colors.primary)
    }
}

// Placeholder views for each tab
struct ObservationReportsView: View {
  
  @State private var createNewReport = false
  
    var body: some View {
      NavigationView {
        VStack {
          Text("Observation Reports")
            .navigationTitle("Reports")
          Button(action: {
            createNewReport.toggle()
          }) {
            Label("Create a new report", systemImage: "plus")
          }
          .padding(20)
          .frame(maxWidth: .infinity)
          .background(Colors.primary)
          .cornerRadius(10)
          .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
      }
      .sheet(isPresented: $createNewReport) {
      ObservationView()
    }
    }
}


struct ChecklistsView: View {
  @State private var selectedOption: Int = 0;
  
    var body: some View {
        NavigationView {
          VStack {
            Picker("Select a Checklist", selection: $selectedOption) {
              Label("Birds", systemImage: "bird").tag(0)
              Label("Plants", systemImage: "leaf").tag(1)
            }
            .pickerStyle(.segmented)
            
            if(selectedOption == 0) {
              BirdCheckListView()
            }
            
            if (selectedOption == 1) {
              PlantCheckListView()
            }
            
          }
          .padding(.horizontal, 20)
          .navigationTitle("Checklists")
        }
    }
}

struct MapView: View {
    var body: some View {
        NavigationView {
            Text("Map")
          .navigationTitle("Map")
        }
    }
}


#Preview {
    MainTabView()
} 
