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
            self.state.container[self.selection]?.color ?? NSColor.black
        }, set: { color in
            self.state.container[self.selection]?.color = color
        })
        
        return VSplitView {
            Section(header: HStack {
                Text("Hi!")
//                Spacer()
            }) {
                List(selection: self.$selection) {
                    ForEach(state.container.items, id: \.id) { item in
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
                                .fill(Color(self.state.container[self.selection]?.color ?? NSColor.clear))
                    }.frame(minHeight: 32)
                } else {
                    Text("Select an item up top")
                }
                Spacer()
            }
        }.frame(minHeight: 200)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState.fakeData())
    }
}
