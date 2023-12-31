//
//  PhotoViewModelProtocol.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation
import UIKit

protocol PhotoViewModelProtocol {
    var model: [Content] { get set }
    var isLoading: Bool { get set }
    var currentPage: Int { get set }
    var errorHandler: ((String) -> Void)? { get set }
    var loadingCellIndexPath: IndexPath? { get set }
    func fetchPhotoData(completion: @escaping ((Bool, Bool) -> Void))
    func sendData(contentModel: ImagePostRequest, completion: @escaping (String, Bool) -> Void)
    func refreshPhotoData(completion: @escaping () -> Void)
}
