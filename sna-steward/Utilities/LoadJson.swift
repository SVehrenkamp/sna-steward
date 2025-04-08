//
//  LoadJson.swift
//  sna-steward
//
//  Created by Scott Vehrenkamp on 4/7/25.
//
import Foundation

func loadJson<T: Decodable>(_ filename: String) -> T? {
  guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
    #if DEBUG
      print("Couldn't find \(filename).json")
    #endif
    return nil
  }
  
  do {
    let data = try Data(contentsOf: url);
    let decoder = JSONDecoder();
    return try decoder.decode(T.self, from: data);
  } catch {
    #if DEBUG
      print("Error loading \(filename).json: \(error)")
    #endif
    return nil
  }
}
