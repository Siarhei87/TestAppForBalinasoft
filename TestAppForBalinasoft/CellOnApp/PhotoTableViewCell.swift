//
//  PhotoTableViewCell.swift
//  TestAppForBalinasoft
//
//  Created by Dubko Siarhei on 24.09.23.
//

import Foundation
import UIKit
import SDWebImage

final class PhotoTableViewCell: UITableViewCell {

  //MARK: - Properties

  private var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 30.0)
    return label
  }()

  private var image: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleToFill
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleToFill
    return image
  }()

  //MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Configure

  func configure(model: Content) {
    nameLabel.text = model.name
    guard let imageURL = URL(string: model.image ?? "no-image") else { return }
    image.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no-image"))

  }
}

//MARK: - Constraints

extension PhotoTableViewCell {
  private func setupConstraints() {
    contentView.addSubview(image)
    contentView.addSubview(nameLabel)

    NSLayoutConstraint.activate([
      nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])

    NSLayoutConstraint.activate([
      image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      image.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      image.widthAnchor.constraint(equalTo: image.heightAnchor)
    ])
  }
}
