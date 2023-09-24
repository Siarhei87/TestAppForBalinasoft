//
//  NetworkServiceProtocol.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation

protocol NetworkServiceProtocol {
    func getPhotoTypes(currentPage: String, completion: @escaping (Result<PageModel, Error>) -> Void)
    func postRequest(contentModel: ImagePostRequest, completion: @escaping (String, Bool) -> Void)
}
