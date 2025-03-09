//
//  Item.swift
//  TestData
//
//  Created by Frank Lawlis on 3/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date
  var quantity: Int
  var year: Int
  var viewed: Bool = false
  ///Adding this member var to Item model gives me the ability to test the "items" array (SwiftData Query) after a planned deletion
  var toBeDeleted: Bool = false
  
  init(timestamp: Date, quantity: Int) {
    self.timestamp = timestamp
    self.quantity = quantity
    self.year = Int(timestamp.formatted(Date.FormatStyle().year(.defaultDigits))) ?? 2025
  }
  
  static func examples() -> [Item] {
    return Array(1...5).map { i in
      Item(timestamp: Date(), quantity: i)
    }
  }
}
