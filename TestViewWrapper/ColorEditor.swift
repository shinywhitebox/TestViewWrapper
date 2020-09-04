//
// Created by Neil Clayton on 1/09/20.
// Copyright (c) 2020 Neil Clayton. All rights reserved.
//

import Foundation
import SwiftUI

struct ColorEditor: View {
    @Environment(\.appState) private var state: AppState.Injection
    var item: Item

    var colorBinding: Binding<NSColor> {
        Binding<NSColor>(
                get: {
                    self.item.color
                },
                set: { color in
                    self.state.appState.value.scenes.updateColorFor(self.item, color)
                }
        )
    }

    var body: some View {
        HStack {
            WrappedColorWell(selectedColor: self.colorBinding)
            Rectangle()
                    .fill(Color(self.item.color))
        }
    }
}

struct ColorEditor_Previews: PreviewProvider {
    static var previews: some View {
        let injected = AppState.Injection.defaultValue
        let item = Item(name: "some random item", color: NSColor.systemPurple)
        return ColorEditor(item: item).environment(\.appState, injected)
    }
}