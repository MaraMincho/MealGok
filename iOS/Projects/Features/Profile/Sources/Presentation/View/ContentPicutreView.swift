//
//  ContentPicutreView.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/15/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import DesignSystem
import OSLog
import UIKit

// MARK: - MealGokSuccessContentView

final class ContentPictureView: UIStackView {
  private let property: ContentPictureViewProperty

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.text = property.date
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    label.textAlignment = .left

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var descriptionImageView: UIImageView = {
    let imageView = UIImageView(image: SharedImages.successSceneDefaultImage)
    imageView.contentMode = .scaleAspectFit

    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var descriptionTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.text = property.title
    label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
    label.textAlignment = .center

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  func setupLayout() {
    addArrangedSubview(dateLabel)
    addArrangedSubview(descriptionImageView)
    addArrangedSubview(descriptionTitleLabel)

    descriptionImageView.heightAnchor.constraint(equalToConstant: Metrics.imageHeight).isActive = true
  }

  init(frame: CGRect, contentPictureViewProperty: ContentPictureViewProperty) {
    property = contentPictureViewProperty
    super.init(frame: frame)

    setupStyle()
    setupLayout()
  }

  func setupStyle() {
    let inset = Metrics.contentInset

    layoutMargins = .init(top: inset, left: inset, bottom: Metrics.bottomContentInse, right: inset)
    spacing = Metrics.contentInset
    isLayoutMarginsRelativeArrangement = true
    axis = .vertical
    alignment = .center
    distribution = .equalSpacing

    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 2
    layer.shadowOffset = CGSize(width: 0, height: 2)

    layer.cornerRadius = 8
    layer.backgroundColor = DesignSystemColor.secondaryBackground.cgColor
    layer.cornerCurve = .continuous
  }

  @available(*, unavailable)
  required init(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private enum Metrics {
    static let contentInset: CGFloat = 12
    static let bottomContentInse: CGFloat = 30

    static let imageHeight: CGFloat = 240
    static let imageWidth: CGFloat = 320

    static let dateAndImageSpacing: CGFloat = 12

    static let imageAndDescriptionLabelSpacing: CGFloat = 12

    static let descriptionLabelsSpacing: CGFloat = 12
  }

  private enum Constants {}
}

// MARK: - MealGokSuccessContentViewProperty

struct ContentPictureViewProperty {
  /// yyyy. mm. dd 형식의 날짜 String
  let date: String

  /// 결과 화면의 이미지 입니다.
  let pictureURL: URL?

  /// 설명의 타이틀 입니다.
  let title: String

  /// 설명 문구 입니다.
  let description: String
}
