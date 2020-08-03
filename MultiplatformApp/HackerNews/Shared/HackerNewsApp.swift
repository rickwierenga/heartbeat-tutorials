//
//  HackerNewsApp.swift
//  Shared
//
//  Created by Rick Wierenga on 14/07/2020.
//

import SwiftUI

@main
struct HackerNewsApp: App {
  var body: some Scene {
    WindowGroup {
      #if os(macOS)
      NavigationView {
        Sidebar()
        ItemsListView(viewModel: ItemsViewModel(category: .top))
      }
      #else
      NavigationView {
        TabBar()
          .navigationTitle("Hacker News")
      }.navigationViewStyle(StackNavigationViewStyle())
      #endif
    }
  }
}
