//
//  ProfileContentHeaderView.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/21/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import MealGokCacher
import UIKit

// MARK: - ProfileContentHeaderView

final class ProfileContentHeaderView: UIStackView {
  override init(frame _: CGRect) {
    super.init(frame: .zero)
    setup()
  }

  @available(*, unavailable)
  required init(coder _: NSCoder) {
    fatalError("Cant use this method")
  }

  // MARK: - Property

  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Metrics.imageViewWidthAndHeight / 2
    imageView.layer.masksToBounds = false
    imageView.layer.cornerCurve = .continuous
    imageView.layer.borderColor = DesignSystemColor.main01.cgColor
    imageView.layer.borderWidth = Metrics.imageViewBorderWidth

    imageView.clipsToBounds = true

    imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  lazy var profileNameLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .title1)
    label.text = " "
    label.textColor = DesignSystemColor.primaryText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var profileAndNameStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      self.profileImageView,
      self.profileNameLabel,
    ])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = Metrics.profileAndNameLabelSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var profileDescriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body, weight: .medium)
    label.text = " "
    label.textColor = DesignSystemColor.primaryText
    label.numberOfLines = 4

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  func setup() {
    setupStackViewProperty()
    setupLayout()
  }

  func setupStackViewProperty() {
    [
      profileAndNameStackView,
      profileDescriptionLabel,
    ]
    .forEach { addArrangedSubview($0) }

    axis = .vertical
    alignment = .fill
    spacing = Metrics.profileAndDescriptionLabelSpacing
    let leftAndRightMargin = Metrics.headerStackViewLeftAndRightMargin
    layoutMargins = .init(
      top: Metrics.headerStackViewTopMargin,
      left: leftAndRightMargin,
      bottom: Metrics.headerStackViewBottomMargin,
      right: leftAndRightMargin
    )
    isLayoutMarginsRelativeArrangement = true
    backgroundColor = DesignSystemColor.secondaryBackground

    layer.cornerRadius = Metrics.headerCornerRadius
    layer.cornerCurve = .continuous
    addShadow()

    translatesAutoresizingMaskIntoConstraints = false
  }

  func setupLayout() {
    profileImageView.widthAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: Metrics.imageViewWidthAndHeight).isActive = true
  }

  enum Metrics {
    static let topSpacing: CGFloat = 24

    static let headerCornerRadius: CGFloat = 8

    static let headerStackViewTopSpacing: CGFloat = 12
    static let headerStackViewLeftAndRightMargin: CGFloat = 12
    static let headerStackViewTopMargin: CGFloat = 12
    static let headerStackViewBottomMargin: CGFloat = 24

    static let imageViewWidthAndHeight: CGFloat = 72
    static let profileAndDescriptionLabelSpacing: CGFloat = 12
    static let profileAndNameLabelSpacing: CGFloat = 12

    static let imageViewBorderWidth: CGFloat = 2
  }
}
