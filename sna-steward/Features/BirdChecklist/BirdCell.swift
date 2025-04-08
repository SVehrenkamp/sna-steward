//
//  BirdCell.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/7/25.
//

import SwiftUI

private class ImageCache {
  static let shared = NSCache<NSString, UIImage>()
}

struct BirdCell: View {
  let bird: Bird
  @State private var image: UIImage?

  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      if !bird.image_url.isEmpty {
        if let cachedImage = image {
          Image(uiImage: cachedImage)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        } else {
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 40, height: 40)
            .overlay(
              Image(systemName: "bird")
                .foregroundColor(.gray.opacity(0.5))
            )
            .task {
              await loadImage()
            }
        }
      } else {
        Image(systemName: "bird")
          .frame(width: 40, height: 40)
      }

      Text(bird.species)
        .lineLimit(2)
        .minimumScaleFactor(0.8)
    }
    .padding(.vertical, 4)
  }

  private func loadImage() async {
    if let cached = ImageCache.shared.object(forKey: bird.image_url as NSString) {
      image = cached
      return
    }

    let baseUrl = bird.image_url
    let resizeParams = "?w=40&h=40&fit=crop"
    let imageUrl = "\(baseUrl)\(resizeParams)"

    guard let url = URL(string: imageUrl),
          let (data, _) = try? await URLSession.shared.data(from: url),
          let loadedImage = UIImage(data: data) else { return }

    ImageCache.shared.setObject(loadedImage, forKey: bird.image_url as NSString)
    image = loadedImage
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
