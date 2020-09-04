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

struct SceneList {
    var items: [Item] = []
    var selectedItem: UUID?

    mutating func updateColorFor(_ item: Item, _ color: NSColor) {
        self[item.id]?.color = color
    }

    public mutating func addItem(item: Item) {
        self.items.append(item)
        if self.selectedItem == nil {
            self.selectedItem = item.id
        }
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

struct AppState {
    public var scenes: SceneList = SceneList()
}

struct AppStateMaker {
    public static func fakeData() -> AppState {
        var scenes = SceneList()
        scenes.addItem(item: Item(name: "Foo", color: NSColor.systemIndigo))
        scenes.addItem(item: Item(name: "Bar", color: NSColor.systemYellow))
        scenes.addItem(item: Item(name: "Muppet", color: NSColor.systemTeal))
        scenes.addItem(item: Item(name: "Train", color: NSColor.systemOrange))
        scenes.addItem(item: Item(name: "Animal", color: NSColor.systemBrown))
        return AppState(scenes: scenes)
    }
}
