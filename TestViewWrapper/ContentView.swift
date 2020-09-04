//
//  ContentView.swift
//  TestViewWrapper
//
//  Created by Neil Clayton on 1/09/20.
//  Copyright © 2020 Neil Clayton. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.appState) private var state: AppState.Injection

    @State var selection: UUID?
    @State var selectedItem: Item?
    @State var color: NSColor = NSColor.black

    var appState: CurrentValueSubject<AppState, Never> {
        state.appState
    }

    var body: some View {
        let colorBinding = self.$color.methodDispatch(to: self.appState) { state, color in
            if let i = self.selectedItem {
                state.value.scenes.updateColorFor(i, color)
            }
        }

        return VSplitView {
            Section(header: HStack {
                Text("Hi!")
            }) {
                List(selection: self.$selection.dispatch(to: appState, \.scenes.selectedItem)) {
                    ForEach(state.appState.value.scenes.items, id: \.id) { item in
                        HStack {
                            Text(item.name)
                            Spacer().frame(minHeight: 2)
                            Rectangle()
                                    .size(CGSize(width: 45, height: 22))
                                    .fill(Color(item.color))
                                    .cornerRadius(4)
                        }
                    }
                    Spacer()
                }
            }.frame(minWidth: 240)

            Section(header: Text("Detail")) {
                if selection != nil {
                    HStack {
                        WrappedColorWell(selectedColor: colorBinding)
                        Spacer()
                        Rectangle()
                                .fill(Color(self.state.appState.value.scenes[self.selection]?.color ?? NSColor.clear))
                    }.frame(minHeight: 32)
                } else {
                    Text("Select an item up top")
                }
                Spacer()
            }
        }.frame(minHeight: 200)
                .onReceive(state.appState) { state in
                    self.selection = state.scenes.selectedItem
                    self.selectedItem = state.scenes[self.selection]
                    self.color = self.selectedItem?.color ?? NSColor.black
                }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let injected = AppState.Injection.defaultValue
        return ContentView().environment(\.appState, injected)
    }
}
