//
//  ContentView.swift
//  TestViewWrapper
//
//  Created by Neil Clayton on 1/09/20.
//  Copyright © 2020 Neil Clayton. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    @State var selection: UUID?

    var body: some View {
        let colorBinding: Binding<NSColor> = Binding<NSColor>(get: {
            self.state[self.selection]?.color ?? NSColor.black
        }, set: { color in
            self.state[self.selection]?.color = color
        })
        return VSplitView {
            Section(header: Text("Hi!")) {
                List(selection: self.$selection) {
                    ForEach(state.items, id: \.id) { item in
                        HStack {
                            Text(item.name)
                            Rectangle()
                                    .size(CGSize(width: 45, height: 22))
                                    .fill(Color(item.color))
                                    .cornerRadius(4)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }.frame(minWidth: 240)

            Section(header: Text("Detail")) {
                if selection != nil {
                    HStack {
                        WrappedColorWell(selectedColor: colorBinding)
                        Rectangle()
                                .fill(Color(self.state[self.selection]?.color ?? NSColor.clear))
                    }
                } else {
                    Text("Select an item up top")
                }
                Spacer()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState.fakeData())
    }
}
