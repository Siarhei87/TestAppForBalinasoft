//
//  PhotoViewController.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation
import UIKit

final class PhotoViewController: UIViewController {
    private var viewModel: PhotoViewModelProtocol
    private var tableView: UITableView = .init(frame: .zero)
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновляю")
        return refreshControl
    }()

    private var photoPickerManager: PhotoPickerManager?
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
  
    init(viewModel: PhotoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
  
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setConstraints()
        displayError()
        fetchData()
        photoPickerManager = PhotoPickerManager(presentingViewController: self)
    }
  
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 120.0
        tableView.refreshControl = refreshControl
        registerCells()
    }
  
    private func registerCells() {
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: String(describing: PhotoTableViewCell.self))
    
        tableView.register(LoadingCell.self, forCellReuseIdentifier: String(describing: LoadingCell.self))
    }
  
    func fetchData() {
        viewModel.fetchPhotoData { _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  
    func loadMoreData() {
        if !viewModel.isLoading {
            viewModel.isLoading = true
            viewModel.currentPage += 1
      
            viewModel.fetchPhotoData { success, isEmpty in
                DispatchQueue.main.async {
                    self.viewModel.isLoading = false
                    if success {
                        if isEmpty {
                            self.hideSpiner()
                            self.viewModel.isLoading = false
                        } else {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension PhotoViewController {
    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.refreshPhotoData {
            DispatchQueue.main.async {
                sender.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

extension PhotoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.model.count
        case 1: return 1
        default: return 0
        }
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotoTableViewCell.self), for: indexPath) as? PhotoTableViewCell
            let content = viewModel.model[indexPath.row]
      
            cell?.configure(model: content)
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath) as? LoadingCell
            viewModel.loadingCellIndexPath = indexPath
            cell?.activityIndicator.startAnimating()
            return cell ?? UITableViewCell()
        }
    }
}

extension PhotoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let id = viewModel.model[indexPath.row].id
        showPhotoPicker(id: id)
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.model.count - 1, !viewModel.isLoading {
            loadMoreData()
        }
    }
}

private extension PhotoViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
        view.addSubview(activityIndicator)
    
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension PhotoViewController {
    func displayError() {
        viewModel.errorHandler = { [weak self] errorMessage in
            self?.handleAPIError(errorMessage)
        }
    }
}

private extension PhotoViewController {
    func displaySuccess(messageId: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Успешно", message: "ID: \(messageId)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
      
            self.present(alert, animated: true, completion: nil)
        }
    }
}

private extension PhotoViewController {
    func handleAPIError(_ errorMessage: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
      
            self.present(alert, animated: true, completion: nil)
        }
    }
}

private extension PhotoViewController {
    func showPhotoAlert(image: UIImage, id: Int) {
        let name = "Дубко Сергей Александрович"
        let alertController = UIAlertController(title: name, message: "id: \(id)", preferredStyle: .alert)
    
        let image = image
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        alertController.view.addSubview(imageView)
    
        let sendAction = UIAlertAction(title: "Отправить", style: .default) { _ in
            if let data = image.jpegData(compressionQuality: 0.8) {
                let model = ImagePostRequest(name: name, photo: data, typeId: id)
                self.activityIndicator.startAnimating()
                self.viewModel.sendData(contentModel: model) { id, _ in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    self.displaySuccess(messageId: id)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
    }
}

private extension PhotoViewController {
    func showPhotoPicker(id: Int) {
        photoPickerManager?.presentPhotoPicker { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.showPhotoAlert(image: image, id: id)
                }
            }
        }
    }
}

extension PhotoViewController {
    func hideSpiner() {
        if let indexPath = viewModel.loadingCellIndexPath {
            if let cell = tableView.cellForRow(at: indexPath) as? LoadingCell {
                cell.activityIndicator.stopAnimating()
            }
        }
    }
}
