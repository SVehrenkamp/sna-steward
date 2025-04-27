//
//  BirdChecklistView.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/6/25.
//

import SwiftUI

struct BirdCheckListView: View {
  @State private var birds: [Bird] = []
  @State private var groupedBirds: [String: [Bird]] = [:]
  @State private var selectedBird: Bird?

  var body: some View {
    NavigationView {
      if birds.isEmpty {
        Text("No birds found")
      } else {
        List {
          ForEach(groupedBirds.keys.sorted(), id: \.self) { birdGroup in
            Section(header: Text(birdGroup)
              .font(.headline)
              .bold()
            ) {
              ForEach(groupedBirds[birdGroup] ?? [], id: \.id) { bird in
                BirdCell(bird: bird) {
                  selectedBird = bird
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
              }
            }
          }
        }
        .listStyle(.plain)
        .sheet(item: $selectedBird) { bird in
          BirdDetailView(bird: bird)
        }
      }
    }
    .navigationTitle("Bird Checklist")
    .task {
      await loadData()
    }
  }

  private func loadData() async {
    let loadedBirds = await Task.detached {
      loadJson(StaticData.birdDataFilename) as [Bird]? ?? []
    }.value

    await MainActor.run {
      self.birds = loadedBirds
      self.groupedBirds = group(loadedBirds)
    }
  }
}

#Preview {
  // Setup mock environment for preview
  DotEnv.setupForPreviews()
  
  return BirdCheckListView()
}
