//
//  NavigationLazyLink.swift
//  QuizProject
//
//  Created by Martin Dinev on 10.03.22.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
