//
//  TabBar.swift
//  HackerNews
//
//  Created by Rick Wierenga on 14/07/2020.
//

import SwiftUI

struct TabBar: View {
  var body: some View {
    TabView {
      ForEach(Category.allCases) { category in
        ItemsListView(viewModel: ItemsViewModel(category: category))
          .tabItem {
            Image(systemName: category.icon)
            Text(category.name)
          }
      }
    }
  }
}
