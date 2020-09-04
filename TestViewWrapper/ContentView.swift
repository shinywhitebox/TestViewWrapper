//
//  ContentView.swift
//  TestViewWrapper
//
//  Created by Neil Clayton on 1/09/20.
//  Copyright © 2020 Neil Clayton. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.appState) private var state: AppState.Injection

    @State private var selectedScene: SceneDescription?
    @State private var sceneList: SceneList = SceneList()
    @State private var selectedSceneID: UUID?

    var body: some View {
        VSplitView {
            Form() {
                Section(header: HStack {
                    Text("Hi!")
                    Text(self.selectedSceneID?.uuidString ?? "Nothing")
                }) {
                    List(selection: self.$selectedSceneID.dispatch(to: state.appState, \.scene.selectedSceneID)) {
                        ForEach(sceneList.items, id: \.id) { item in
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
                    if self.selectedScene != nil {
                        ColorEditor(scene: selectedScene!)
                    } else {
                        Text("Select an item up top")
                    }
                    Spacer()
                }
            }
                    .onReceive(state.appState) { state in
                        self.selectedSceneID = state.scene.selectedSceneID
                        self.sceneList = state.scene.scenes
                        self.selectedScene = state.scene.selectedSceneDescriptor
                        NSLog("Selected scene now: \(String(describing: self.selectedScene?.name))")
                    }
        }.frame(minHeight: 200)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let injected = AppState.Injection.defaultValue
        return ContentView().environment(\.appState, injected)
    }
}
