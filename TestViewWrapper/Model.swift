//
//  Model.swift
//  TestViewWrapper
//
//  Created by Neil Clayton on 1/09/20.
//  Copyright © 2020 Neil Clayton. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

struct SceneDescription: Hashable {
    var id: UUID = UUID()
    var name: String
    var color: NSColor

    public mutating func setColor(col: NSColor) {
        self.color = col
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(color)
    }

    static func ==(lhs: SceneDescription, rhs: SceneDescription) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.color != rhs.color {
            return false
        }
        return true
    }
}

struct SceneList {
    var items: [SceneDescription] = []

    public subscript(id: UUID?) -> SceneDescription? {
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

    mutating func updateColorFor(_ item: SceneDescription, _ color: NSColor) {
        self[item.id]?.color = color
    }
}

struct SceneState {
    var scenes: SceneList
    var selectedSceneID: UUID?

    public var selectedSceneDescriptor: SceneDescription? {
        scenes.items.first { scene in
            scene.id == self.selectedSceneID
        }
    }
}

struct AppState {
    var scene: SceneState // mimic a redux slice, representing scene information
}

func DefaultEmptySceneState() -> AppState {
    let sceneList = SceneList()
    let sceneState = SceneState(scenes: sceneList)
    return AppState(scene: sceneState)
}

class ObservableStore: ObservableObject {
    @Published var root: AppState = DefaultEmptySceneState()

    init(root: AppState) {
        self.root = root
    }

    public static func fakeAppState() -> AppState {
        let sceneList = SceneList(items: [SceneDescription(name: "Foo", color: NSColor.systemOrange),
                                          SceneDescription(name: "Cat", color: NSColor.systemYellow),
                                          SceneDescription(name: "Mouse", color: NSColor.systemRed),
                                          SceneDescription(name: "Bar", color: NSColor.systemPurple),
                                          SceneDescription(name: "Missile", color: NSColor.systemTeal)
        ])
        var sceneState = SceneState(scenes: sceneList)
        sceneState.selectedSceneID = sceneList.items.first?.id
        return AppState(scene: sceneState)
    }

    public static func fakeData() -> ObservableStore {
        ObservableStore(root: fakeAppState())
    }

    func binding<Value>(for keyPath: KeyPath<AppState, Value>, action: @escaping (Value) -> Void) -> Binding<Value> {
        Binding<Value>(
                get: {
                    self.root[keyPath: keyPath]
                },
                set: { newValue in
                    action(newValue)
                    self.objectWillChange.send()
                }
        )
    }

    // Mimic actions on a redux store

    func selectScene(_ id: UUID?) {
        self.root.scene.selectedSceneID = id
        NSLog("""
              Selected item is now: \(String(describing: self.root.scene.selectedSceneID)), 
              \(String(describing: self.root.scene.scenes[self.root.scene.selectedSceneID]?.name))
              """)
    }
}
