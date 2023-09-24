//
//  PageModel.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation

struct PageModel: Decodable {
  let content: [Content]
  let page: Int
  let pageSize: Int
  let totalElements: Int
  let totalPages: Int
}

struct Content: Decodable {
  let id: Int
  let name: String
  let image: String?
}
