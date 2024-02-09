//
//  ProfileViewMealGokTableViewCell.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/4/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import UIKit

final class ProfileViewMealGokTableViewCell: UITableViewCell {
  static let identifier = "ProfileViewMealGokTableViewCell"

  override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setupViewHierarchyAndConstraints()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this method")
  }

  private let challengeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.tintColor = DesignSystemColor.primaryBackground
    imageView.backgroundColor = DesignSystemColor.main01

    imageView.layer.cornerRadius = Metrics.imageCornerRadius
    imageView.layer.cornerCurve = .continuous
    imageView.layer.masksToBounds = true

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title3, weight: .regular)
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body, weight: .medium)
    label.textColor = DesignSystemColor.gray03

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var labelStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      descriptionLabel,
    ])
    stackView.axis = .vertical
    stackView.spacing = Metrics.descriptionLabelTopSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  func setupViewHierarchyAndConstraints() {
    let safeArea = safeAreaLayoutGuide
    contentView.addSubview(labelStackView)
    labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.leadingSpacing).isActive = true
    labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    labelStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true

    contentView.addSubview(challengeImageView)
    challengeImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Metrics.trailingSpacing).isActive = true
    challengeImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    challengeImageView.widthAnchor.constraint(equalToConstant: Metrics.imageWidthAndHeight).isActive = true
    challengeImageView.heightAnchor.constraint(equalToConstant: Metrics.imageWidthAndHeight).isActive = true
  }

  func configure(challengeProperty: MealGokChallengeProperty) {
    let (minutes, seconds) = challengeProperty.challengeDurationTime()
    titleLabel.text = challengeProperty.isSuccess ? Constants.successText : "\(minutes)\(Constants.minutsString) \(seconds)\(Constants.secondsString)"

    descriptionLabel.text = "\(challengeProperty.stringOfAMPM()): \(challengeProperty.formattedStartDate()) ~ \(challengeProperty.formattedEndDate())"

    // URL을 통해서 이미지를 받아오는 과정 필요
    challengeImageView.image = UIImage(systemName: Constants.placeHolderImageSystemName, withConfiguration: Constants.imageSymbolConfiguration)
  }

  private enum Metrics {
    static let imageCornerRadius: CGFloat = 8
    static let leadingSpacing: CGFloat = 24
    static let descriptionLabelTopSpacing: CGFloat = 6

    static let trailingSpacing: CGFloat = 24

    static let imageWidthAndHeight: CGFloat = 45
  }

  private enum Constants {
    static let successText: String = "성공"
    static let minutsString: String = "분"
    static let secondsString: String = "초"

    static let imageSymbolConfiguration: UIImage.SymbolConfiguration = .init(pointSize: 20)
    static let placeHolderImageSystemName: String = "photo.on.rectangle.angled"
  }
}
