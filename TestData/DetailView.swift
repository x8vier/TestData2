//
//  DetailView.swift
//  TestData
//
//  Created by Frank Lawlis on 3/5/25.
//

import SwiftUI

struct DetailView: View {
  @Bindable var item: Item
  
    var body: some View {
      
      VStack {
        Text("Detail View")
          .font(.largeTitle)
          .bold()
        Form {
          VStack(alignment: .leading) {
            HStack {
              Text("Date:")
              DatePicker("", selection: $item.timestamp, displayedComponents: .date)
                .background(Color.white)
                .onChange(of: item.timestamp) { oldValue, newValue in
                  item.year = Calendar.current.component(.year, from: newValue)
                }
            }
            HStack {
              Text("Quantity:")
              TextField( "Quantity:", value: $item.quantity, format: .number)
                .background(Color.white)
                .multilineTextAlignment(.trailing)
            }
            HStack {
              Text("Year:")
              Text("\(item.year, format: .number.grouping(.never))")
                .bold()
              Spacer()
              Text(item.viewed ? "Item Viewed" : "Item Not Viewed")
                .onAppear {
                  item.viewed = true
                }
            }
          }
          .padding(30)
          .background(Color.gray.opacity(0.4))
        }
      }
    }
}

#Preview {
  DetailView(item: Item(timestamp: Date(), quantity: 3))
}
