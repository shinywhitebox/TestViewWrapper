//
// Created by Neil Clayton on 4/09/20.
// Copyright (c) 2020 Neil Clayton. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


// Makes app state a subscribable combine publisher

// This makes a 'Injection' struct available from AppState; with default store state
// as a pure value only struct.
extension AppState {
    struct Injection: EnvironmentKey {
        let appState: CurrentValueSubject<AppState, Never>

        static var defaultValue: Self {
            .init(appState: .init(AppStateMaker.fakeData()))
        }
    }
}

// This I imagine makes 'injected' available as an environment value in SwiftUI?
extension EnvironmentValues {
    var appState: AppState.Injection {
        get {
            self[AppState.Injection.self]
        }
        set {
            NSLog("Setting NEW VALUE for the AppState: \(newValue)")
            self[AppState.Injection.self] = newValue
        }
    }
}

extension Binding where Value: Equatable {
    func dispatch(to state: CurrentValueSubject<AppState, Never>,
                  _ keyPath: WritableKeyPath<AppState, Value>) -> Self {
        .init(get: { () -> Value in
            self.wrappedValue
        }) { (v: Value) in
            self.wrappedValue = v
            NSLog("Updating value of \(keyPath) to \(v)")

            // this will cause the CurrentValueSubject to emit a new value
            state.value[keyPath: keyPath] = v
        }
    }

    func methodDispatch(to state: CurrentValueSubject<AppState, Never>,
                        _ action: @escaping (CurrentValueSubject<AppState, Never>, Value) -> Void) -> Self {
        .init(get: { () -> Value in
            self.wrappedValue
        }) { (v: Value) in
            self.wrappedValue = v
            action(state, v)
        }
    }
}

