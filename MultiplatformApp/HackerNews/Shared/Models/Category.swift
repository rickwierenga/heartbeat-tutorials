//
//  Category.swift
//  HackerNews
//
//  Created by Rick Wierenga on 14/07/2020.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
  var id: String {
    return rawValue
  }

  case top
  case best
  case new
  case ask
  case show

  var name: String {
    switch self {
    case .best: return "Best"
    case .new: return "New"
    case .top: return "Top"
    case .ask: return "Ask HN"
    case .show: return "Show HN"
    }
  }

  var urlSuffix: String {
    return self.rawValue
  }

  var icon: String {
    switch self {
    case .best: return "rosette"
    case .new: return "clock"
    case .top: return "flame.fill"
    case .ask: return "questionmark.circle"
    case .show: return "eye"
    }
  }
}
