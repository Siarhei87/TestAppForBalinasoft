//
//  Builder.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation
import UIKit

final class Builder: BuilderProtocol {
    static func createPhotoVCModule() -> UIViewController {
        let networkService = NetworkService()
        let viewModel = PhotoViewModel(networkService: networkService)
        let view = PhotoViewController(viewModel: viewModel)
        return view
    }
}
