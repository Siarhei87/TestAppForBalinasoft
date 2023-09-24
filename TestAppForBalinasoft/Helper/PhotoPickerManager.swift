//
//  PhotoPickerManager.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation
import UIKit

final class PhotoPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private weak var presentingViewController: UIViewController?
    private var completionHandler: ((UIImage?) -> Void)?

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

    func presentPhotoPicker(completion: @escaping (UIImage?) -> Void) {
        guard let presentingViewController = presentingViewController else {
            completion(nil)
            return
        }

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
                imagePickerController.sourceType = .camera
                presentingViewController.present(imagePickerController, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }

        let photoLibraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            presentingViewController.present(imagePickerController, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completion(nil)
        }
        alertController.addAction(cancelAction)

        completionHandler = completion
        presentingViewController.present(alertController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            completionHandler?(nil)
            return
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
        completionHandler?(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        completionHandler?(nil)
    }
}
