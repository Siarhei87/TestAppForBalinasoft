//
//  PhotoViewModel.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation
import UIKit

final class PhotoViewModel: PhotoViewModelProtocol {
    var networkService: NetworkServiceProtocol
    var model: [Content] = []
    var isLoading: Bool = false
    var currentPage: Int = 0
    var errorHandler: ((String) -> Void)?
    var loadingCellIndexPath: IndexPath?
  
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
  
    func fetchPhotoData(completion: @escaping ((Bool, Bool) -> Void)) {
        networkService.getPhotoTypes(currentPage: "\(currentPage)") { result in
            switch result {
            case .success(let model):
                let isEmpty = model.content.isEmpty
                if !isEmpty {
                    self.model.append(contentsOf: model.content)
                }
                dump(isEmpty)
                completion(true, isEmpty)
            case .failure(let error):
                print(error.localizedDescription)
                self.handleAPIError(error)
                completion(false, false)
            }
        }
    }
  
    func refreshPhotoData(completion: @escaping () -> Void) {
        currentPage = 0
        networkService.getPhotoTypes(currentPage: "\(currentPage)") { result in
            switch result {
            case .success(let model):
                self.model = model.content
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.handleAPIError(error)
                completion()
            }
        }
    }
  
    func sendData(contentModel: ImagePostRequest, completion: @escaping (String, Bool) -> Void) {
        networkService.postRequest(contentModel: contentModel) { id, success in
            if success {
                completion(id, true)
            } else {
                completion(APIError.connectionError.localizedDescription, false)
            }
        }
    }
  
    func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .unknownError:
                errorHandler?("Неизвестная ошибка")
            case .connectionError:
                errorHandler?("Ошибка соединения")
            }
        } else {
            errorHandler?(error.localizedDescription)
        }
    }
}
