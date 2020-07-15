//
//  Item.swift
//  HackerNews
//
//  Created by Rick Wierenga on 14/07/2020.
//

import Foundation

struct Item: Codable, Hashable {
  let id: Int
  let author: String
  let score: Int
  let date: Double
  let title: String
  let contentUrl: URL?
  
  private enum CodingKeys : String, CodingKey {
    case id
    case author = "by"
    case score
    case date = "time"
    case title
    case contentUrl = "url"
  }

  var formattedDate: String {
    // See https://nsdateformatter.com
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, h:mm a"
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter.string(from: Date(timeIntervalSince1970: date))
  }

  var url: URL {
    contentUrl ?? URL(string: "http://news.ycombinator.com/item?id=\(id)")!
  }
}
