//
//  CellView.swift
//  TestData
//
//  Created by Frank Lawlis on 3/6/25.
//

import SwiftUI
import SwiftData

struct CellView: View {
  var item: Item
  
    var body: some View {
      HStack {
        //Text(item.year)
        Text(item.timestamp, format: Date.FormatStyle(date: .numeric))
        Spacer()
        Text("\(item.year, format: .number.grouping(.never))")
        Spacer()
        Text("\(item.quantity)")
      }
      .foregroundStyle(item.viewed ? .primary : Color.red)
    }
}

//#Preview {
//    CellView()
//}
