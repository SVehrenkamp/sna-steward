//
//  BirdCell.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/7/25.
//

import SwiftUI

struct BirdCell: View {
  let bird: Bird
  
  var body: some View {
    HStack(alignment: .center) {
      // Image
      if (bird.image_url != "") {
        AsyncImage(url: URL(string: bird.image_url)) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView().progressViewStyle(.circular)
        }
        
        .frame(width: 40, height: 40)
      } else {
        Image(systemName: "bird")
          .frame(width: 40, height: 40)
      }
      // Name
      Text(bird.species)
    }
  }
}

#Preview {
    Group {
        // Preview with image
        BirdCell(bird: Bird.sampleRobin)
        
        // Preview without image
        BirdCell(bird: Bird.sampleBlueJay)
    }
    .padding()
}



