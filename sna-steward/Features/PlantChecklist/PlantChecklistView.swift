//
//  PlantChecklistView.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/7/25.
//

import SwiftUI

struct PlantCheckListView: View {
  @State private var plants: [Plant]?
  
  var body: some View {
    VStack {
      Text("Plant Checklist")
      
      if (plants == nil || plants!.isEmpty) {
        Text("No plants found")
      }
      
      if (plants != nil  && !plants!.isEmpty) {
        Text("Total Plants: \(plants?.count ?? 0)")
      }
    }
    .onAppear {
      plants = loadJson(StaticData.plantDataFilename)
    }
  }
}

#Preview {
  // Setup mock environment for preview
  DotEnv.setupForPreviews()
  
  return PlantCheckListView()
}
