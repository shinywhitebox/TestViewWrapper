//
//  Model.swift
//  TestViewWrapper
//
//  Created by Neil Clayton on 1/09/20.
//  Copyright © 2020 Neil Clayton. All rights reserved.
//

import Foundation
import Cocoa

struct Item {
    var id = UUID()
    var name: String
    var color: NSColor

    public mutating func setColor(col: NSColor) {
        self.color = col
    }
}

class AppState: ObservableObject {
    @Published var items: [Item] = []

    func updateColorFor(_ item: Item, _ color: NSColor) {
        self[item.id]?.color = color
    }

    @Published var selectedItem: UUID?

    public static func fakeData() -> AppState {
        let appState = AppState()
        appState.items.append(Item(name: "Foo", color: NSColor.systemIndigo))
        appState.items.append(Item(name: "Bar", color: NSColor.systemYellow))
        return appState
    }

    public subscript(id: UUID?) -> Item? {
        get {
            items.first {
                $0.id == id
            }
        }
        set(newValue) {
            if let index = self.items.firstIndex(where: { id == $0.id }) {
                if let val = newValue {
                    self.items[index] = val
                } else {
                    self.items.remove(at: index)
                }
            }
        }
    }
}
