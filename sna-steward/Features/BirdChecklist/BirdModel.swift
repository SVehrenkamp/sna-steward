//
//  BirdModel.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/6/25.
//
import Foundation

struct Bird: Identifiable, Codable, Groupable, Hashable {
  let id: UUID;
  let group: String;
  let species: String;
  let spring: Bool;
  let fall: Bool;
  let summer: Bool;
  let winter: Bool;
  let description: String;
  let image_url: String;
  
  enum CodingKeys: String, CodingKey {
    case group
    case species
    case spring
    case fall
    case summer
    case winter
    case description
    case image_url
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self);
    self.id = UUID();
    self.group = try container.decode(String.self, forKey: .group);
    self.spring = try container.decode(Bool.self, forKey: .spring);
    self.summer = try container.decode(Bool.self, forKey: .summer);
    self.fall = try container.decode(Bool.self, forKey: .fall);
    self.winter = try container.decode(Bool.self, forKey: .winter);
    self.species = try container.decode(String.self, forKey: .species);
    self.description = try container.decode(String.self, forKey: .description);
    self.image_url = try container.decode(String.self, forKey: .image_url);
  }
  
  // Custom initializer for sample birds
  init(id: UUID = UUID(),
       group: String,
       species: String,
       spring: Bool,
       fall: Bool,
       summer: Bool,
       winter: Bool,
       description: String,
       image_url: String) {
    self.id = id
    self.group = group
    self.species = species
    self.spring = spring
    self.fall = fall
    self.summer = summer
    self.winter = winter
    self.description = description
    self.image_url = image_url
  }
  
  // Sample birds for preview
  static let sampleRobin = Bird(
    group: "THRUSHES",
    species: "American Robin",
    spring: true,
    fall: true,
    summer: true,
    winter: true,
    description: "A common thrush with a red breast",
    image_url: "https://images.unsplash.com/photo-1608561220714-a7522ff43710"
  )
  
  static let sampleBlueJay = Bird(
    group: "JAYS",
    species: "Blue Jay",
    spring: true,
    fall: true,
    summer: true,
    winter: true,
    description: "A blue and white jay with a crest",
    image_url: ""
  )
}
