//
//  BirdDetailView.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/7/25.
//

import SwiftUI

struct BirdDetailView: View {
  let bird: Bird
  @Environment(\.dismiss) private var dismiss
    
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // Image
          if !bird.image_url.isEmpty {
            let baseUrl = bird.image_url
            let resizeParams = "?w=640&h=480"
            let imageUrl = "\(baseUrl)\(resizeParams)"
                      
            AsyncImage(url: URL(string: imageUrl)) { phase in
              switch phase {
              case .empty:
                RoundedRectangle(cornerRadius: 4)
                  .fill(Color.gray.opacity(0.2))
                  .frame(width: 300, height: 300)
                  .overlay(
                    Image(systemName: "bird")
                      .foregroundColor(.gray.opacity(0.5))
                  )
              case .success(let image):
                image
                  .resizable()
                  .scaledToFit()
                  .frame(maxHeight: 300)
                  .clipShape(RoundedRectangle(cornerRadius: 8))
              case .failure:
                Image(systemName: "bird")
                  .font(.system(size: 100))
              @unknown default:
                EmptyView()
              }
            }
          }
                    
          // Species
          Text(bird.species)
            .font(.title)
            .bold()
                    
          // Group
          Text(bird.group)
            .font(.headline)
            .foregroundColor(.secondary)
                    
          // Description
          Text(bird.description)
            .font(.body)
                    
          // Seasons
          VStack(alignment: .leading, spacing: 8) {
            Text("Seasons")
              .font(.headline)
                        
            HStack {
              SeasonIndicator(season: "Spring", isPresent: bird.spring)
              SeasonIndicator(season: "Summer", isPresent: bird.summer)
              SeasonIndicator(season: "Fall", isPresent: bird.fall)
              SeasonIndicator(season: "Winter", isPresent: bird.winter)
            }
          }
        }
        .padding()
      }
      .navigationTitle("Bird Details")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            dismiss()
          }
        }
      }
    }
  }
}

struct SeasonIndicator: View {
  let season: String
  let isPresent: Bool
    
  var body: some View {
    HStack {
      Image(systemName: isPresent ? "checkmark.circle.fill" : "circle")
        .foregroundColor(isPresent ? .green : .gray)
      Text(season)
        .font(.subheadline)
    }
  }
}

#Preview {
  BirdDetailView(bird: Bird.sampleRobin)
}
