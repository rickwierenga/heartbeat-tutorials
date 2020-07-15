//
//  HackerNewsError.swift
//  HackerNews
//
//  Created by Rick Wierenga on 14/07/2020.
//

import Foundation

enum HackerNewsError: Error {
  case message(String)
  case other(Error)

  static func map(_ error: Error) -> HackerNewsError {
    return (error as? HackerNewsError) ?? .other(error)
  }
}

extension HackerNewsError: CustomStringConvertible {
  var description: String {
    switch self {
    case .message(let message):
      return message
    case .other(let error):
      return error.localizedDescription
    }
  }
}
