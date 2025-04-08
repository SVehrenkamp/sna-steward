//
//  PlantModel.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/7/25.
//

import Foundation

struct Plant: Identifiable, Codable, Groupable {
  let id: UUID;
  let group: String;
  let species: String;
  let confidence: String;
  let description: String;
  let common_name: String;
  let scientific_name: String;
  let image_url: String;
  
  enum CodingKeys: String, CodingKey {
    case group
    case species
    case confidence
    case description
    case common_name = "common_name"
    case scientific_name = "scientific_name"
    case image_url = "image_url"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = UUID()
    self.group = try container.decode(String.self, forKey: .group)
    self.species = try container.decode(String.self, forKey: .species)
    self.confidence = try container.decode(String.self, forKey: .confidence)
    self.image_url = try container.decode(String.self, forKey: .image_url)
    self.description = try container.decode(String.self, forKey: .description)
    self.common_name = try container.decode(String.self, forKey: .common_name)
    self.scientific_name = try container.decode(String.self, forKey: .scientific_name)
    
  }
}
