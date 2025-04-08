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
  
  var body: some View {
    VStack {
      Text("Bird Checklist")
      
      if (birds.isEmpty == true) {
        Text("No birds found")
      }
      
      if (birds.isEmpty == false) {
        List{
          ForEach(groupedBirds.keys.sorted(), id: \.self) {
            birdGroup in
            Section(header: Text(birdGroup)
              .font(.headline)
              .bold()
            ) {
              BirdListView(birdList: groupedBirds[birdGroup] ?? [])
            }
          }
        }
      }
      
     
    }
    .onAppear {
      birds = loadJson(StaticData.birdDataFilename) ?? []
      groupedBirds = group(birds)
    }
  }
}

struct BirdListView: View {
  let birdList: [Bird]
  
  var body: some View {
    VStack {
      ForEach(birdList, id: \.self) { bird in
        BirdCell(bird: bird)
      }
    }
  }

}

#Preview {
  BirdCheckListView()
}
