//
// Created by Neil Clayton on 1/09/20.
// Copyright (c) 2020 Neil Clayton. All rights reserved.
//

import Foundation
import SwiftUI

struct ColorEditorState {
    var scene: SceneDescription
}

extension AppState {
    func binding<Value>(_ keyPath: KeyPath<AppState, Value>, action: @escaping (Value) -> Void) -> Binding<Value> {
        Binding<Value>(
                get: { () -> Value in
                    self[keyPath: keyPath]
                },
                set: { (v: Value) in
                    action(v)
                }
        )
    }
}

struct ColorEditor: View {
    @Environment(\.appState) private var state: AppState.Injection

    var scene: SceneDescription

    var body: some View {
        NSLog("Render ColorEditor using \(self.scene.name)")
        let colorPath = \AppState.scene.scenes[self.scene.id]?.color
        let state = self.state.appState.value
        let colorBinding = state.binding(colorPath) { color in
            NSLog("Should update color of \(self.scene.name) to \(String(describing: color))")
            if let c = color {
                self.state.appState.value.scene.scenes.updateColorFor(self.scene, c)
            }
        }


        return HStack {
            WrappedColorWell(selectedColor: colorBinding)
            Spacer()
            Rectangle()
                    .fill(Color(self.scene.color))
        }.frame(minHeight: 32)
    }
}

struct ColorEditor_Previews: PreviewProvider {
    static var previews: some View {
        let injected = AppState.Injection.defaultValue
        let scene = injected.appState.value.scene.scenes.items.first!
        return ColorEditor(scene: scene).environment(\.appState, injected)
    }
}