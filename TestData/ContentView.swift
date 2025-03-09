//
//  ContentView.swift
//  TestData
//
//  Created by Frank Lawlis on 3/5/25.
//

import SwiftUI
import SwiftData
import Observation

@Observable class QuantitySummary {
  var sumOfQuantityByYear: Int = 0
}

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @AppStorage("year") var year: Int = 2025
  @Query(sort: [SortDescriptor(\Item.timestamp, order: .reverse)]) private var items: [Item]
  @State private var quantitySummary = QuantitySummary()
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          NavigationLink {
            DetailView(item: item)
          } label: {
            CellView(item: item)
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem(placement: .principal) {
          Text("TestData")
            .font(.title)
            .bold()
            .italic()
        }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
        ToolbarItem(placement: .bottomBar) {
          HStack {
            Button(action: { calculateYearQuantity() }) {
              Text("\(year, format: .number.grouping(.never))")
            }
            Spacer()
            Text("Annual Quantity: \(quantitySummary.sumOfQuantityByYear, format: .number)")
              .task {
                calculateYearQuantity(false)
              }
          }
        }
      }
      .toolbarBackground(.gray.opacity(0.4), for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarBackground(.gray.opacity(0.4), for: .bottomBar)
      .toolbarBackground(.visible, for: .bottomBar)
      .scrollContentBackground(.hidden)
      .onAppear {
        if items.isEmpty {
          modelContext.insert(Item.examples()[0])
          modelContext.insert(Item.examples()[1])
          modelContext.insert(Item.examples()[2])
          modelContext.insert(Item.examples()[3])
          modelContext.insert(Item.examples()[4])
        }
      }
    } detail: {
      Text("Select an item")
    }
    .onAppear {
      calculateYearQuantity(false)
    }
  }
  
  private func addItem() {
    withAnimation {
      let newItem = Item(timestamp: Date(), quantity: 0)
      modelContext.insert(newItem)
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        ///Adding this statement sets the member var so I can exclude this deleted item if SwiftData has not deleted it from the Query array
        items[index].toBeDeleted = true
        modelContext.delete(items[index])
      }
    }
    ///I now need to call this function to execute the test
    calculateYearQuantity(false)
  }
  
  private func incrementYear() {
    let myDate = Date()
    let currentYear = Int(myDate.formatted(Date.FormatStyle().year(.defaultDigits)))
    if year == currentYear {
      year = 2024
      //year = 2021
    } else {
      year += 1
    }

  }
  private func calculateYearQuantity(_ increment: Bool = true) {
    ///handle the incrementing of year: max at current year, min at 2021
    if increment {
      print("Year before increment:\(year)")
      incrementYear()
      print("Year after increment:\(year)")
    }
    var tempSum: Int = 0
    for item in items {
      ///Added test "&& (item.toBeDeleted == false)" to exclude record if SwiftData has not yet updated the Query for the items array
      if ((item.year == year) && (item.toBeDeleted == false)) {
        tempSum += item.quantity
        print("\(year) year w/ \(tempSum) quantity")
      }
    }
    quantitySummary.sumOfQuantityByYear = tempSum
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
