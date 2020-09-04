//
//  WrappedColorWell.swift
//
//  Created by Neil Clayton on 20/08/20.
//  Copyright © 2020 Neil Clayton. All rights reserved.
//

import SwiftUI
import Combine

struct WrappedColorWell: NSViewRepresentable {
    typealias NSViewType = NSColorWell
    @Binding var selectedColor: NSColor?

    func makeNSView(context: Context) -> NSColorWell {
        let newCW = NSColorWell(frame: .zero)
        context.coordinator.listenToUIChanges(colorWell: newCW)
        return newCW
    }

    // Propagate changes from SwiftUI to the View
    func updateNSView(_ nsView: NSColorWell, context: Context) {
        if let s = self.selectedColor {
            if (!s.isEqual(to: nsView.color)) {
                nsView.color = s
//            NSLog("Set color of well (from state) to \(selectedColor)")
            }
        }
    }

    static func dismantleNSView(_ nsView: Self.NSViewType, coordinator: Self.Coordinator) {
        NSLog("DIUE DIE DIEE")
        coordinator.cleanup()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Make sure relevant changes to the view are sent back to SwiftUI
    class Coordinator: NSObject {
        var wrapped: WrappedColorWell
        var subscription: AnyCancellable?

        init(_ wr: WrappedColorWell) {
            self.wrapped = wr
        }

        func listenToUIChanges(colorWell: NSColorWell) {
            subscription = colorWell.publisher(for: \.color, options: .new)
                    .sink { color in
                        if (!color.isEqual(to: self.wrapped.selectedColor)) {
                            DispatchQueue.main.async {
                                NSLog("User changed col to \(color)")
                                self.wrapped.selectedColor = color
                            }
                        }
                    }
        }

        func cleanup() {
            NSLog("ColorWell GONE")
            subscription?.cancel()
        }
    }
}

var someColor: NSColor = NSColor.red

struct WrappedColorWell_Previews: PreviewProvider {
    static var previews: some View {
        WrappedColorWell(selectedColor: Binding<NSColor?>(get: { () -> NSColor? in
            someColor
        }, set: { (color) in
            someColor = color ?? NSColor.black
        }))
    }
}
