//
// Created by Neil Clayton on 1/09/20.
// Copyright (c) 2020 Neil Clayton. All rights reserved.
//

import Foundation
import SwiftUI

struct ColorEditor: View {
    @EnvironmentObject var state: AppState

    var item: Item

    var colorBinding: Binding<NSColor> {
        Binding<NSColor>(
                get: {
                    self.item.color
                },
                set: { color in
                    self.state.updateColorFor(self.item, color)
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
        let state = AppState.fakeData()
        let item = state.items.first!
        return ColorEditor(item: item).environmentObject(state)
    }
}