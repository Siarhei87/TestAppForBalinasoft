//
//  ImagePostRequest.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation

struct ImagePostRequest: Codable {
  let name: String
  let photo: Data
  let typeId: Int
}
