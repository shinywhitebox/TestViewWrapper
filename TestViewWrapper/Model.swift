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

struct Container {
    var items: [Item] = []
    var selectedItem: UUID?

    mutating func updateColorFor(_ item: Item, _ color: NSColor) {
        self[item.id]?.color = color
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

class AppState: ObservableObject {
    @Published var container: Container = Container()

    public static func fakeData() -> AppState {
        let appState = AppState()
        var container = Container()
        container.items.append(Item(name: "Foo", color: NSColor.systemIndigo))
        container.items.append(Item(name: "Bar", color: NSColor.systemYellow))
        container.items.append(Item(name: "Muppet", color: NSColor.systemTeal))
        container.items.append(Item(name: "Train", color: NSColor.systemOrange))
        container.items.append(Item(name: "Animal", color: NSColor.systemBrown))
        appState.container = container
        return appState
    }
}
