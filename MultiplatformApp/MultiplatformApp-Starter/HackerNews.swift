//
//  HackerNews.swift
//  HackerNews
//
//  Created by Rick Wierenga on 14/07/2020.
//

import Combine
import Foundation

final class HackerNews {
  private static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0/")!

  static func loadItems(in category: Category) -> AnyPublisher<[ItemViewModel], HackerNewsError> {
    let url = baseUrl.appendingPathComponent("\(category.urlSuffix)stories.json")
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { response in
        if let httpURLResponse = response.response as? HTTPURLResponse,
              !(200...299 ~= httpURLResponse.statusCode) {
          throw HackerNewsError.message("Got an HTTP \(httpURLResponse.statusCode) error.")
        }
        return response.data
      }
      .decode(type: [Int].self, decoder: JSONDecoder())
      .map { $0[0..<30] } // Limit the number of items to 30 to limit the load on the API.
      .map { items in
        items.map { id in
          ItemViewModel(id: id)
        }
      }
      .mapError { HackerNewsError.map($0) }
      .eraseToAnyPublisher()
  }

  static func loadItem(withId id: Int) -> AnyPublisher<Item, HackerNewsError> {
    let url = baseUrl.appendingPathComponent("item/\(id).json")
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { response in
        if let httpURLResponse = response.response as? HTTPURLResponse,
              !(200...299 ~= httpURLResponse.statusCode) {
          throw HackerNewsError.message("Got an HTTP \(httpURLResponse.statusCode) error.")
        }
        return response.data
      }
      .decode(type: Item.self, decoder: JSONDecoder())
      .mapError { HackerNewsError.map($0) }
      .eraseToAnyPublisher()
  }
}

