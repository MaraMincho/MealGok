//
//  HistoryContentPictureView.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/15/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import DesignSystem
import ImageManager
import OSLog
import UIKit

// MARK: - HistoryContentPictureView

final class HistoryContentPictureView: UIStackView {
  private let property: HistoryContentPictureViewProperty
  private var imageSubscription: AnyCancellable?
  private var imageHeightConstraint: NSLayoutConstraint?

  private var portraitImageHeight: CGFloat {
    return 448
  }

  private var landScapeImageHeight: CGFloat {
    return 309
  }

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
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.backgroundColor = .red

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

    imageSubscription = descriptionImageView
      .publisher(for: \.image, options: .new)
      .compactMap { [weak self] _ -> Void? in
        if self?.descriptionImageView.frame.width == 0 {
          return nil
        }
        return ()
      }
      .sink { [weak self] _ in
        guard let self else { return }
        guard let imageSize = descriptionImageView.image?.size else {
          return
        }
        let imageHeight = imageSize.height > imageSize.width ? portraitImageHeight : landScapeImageHeight
        imageHeightConstraint?.constant = imageHeight
      }
    imageHeightConstraint = descriptionImageView.heightAnchor.constraint(equalToConstant: landScapeImageHeight)
    imageHeightConstraint?.isActive = true
  }

  init(frame: CGRect, contentPictureViewProperty: HistoryContentPictureViewProperty) {
    property = contentPictureViewProperty
    super.init(frame: frame)

    setupStyle()
    setupLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    descriptionImageView.setImage(
      url: property.pictureURL,
      downSampleProperty: DownSampleProperty(size: .init(width: frame.width, height: 0))
    )
  }

  func setupStyle() {
    let inset = Metrics.contentInset

    layoutMargins = .init(top: inset, left: inset, bottom: Metrics.bottomContentInse, right: inset)
    spacing = Metrics.contentInset
    isLayoutMarginsRelativeArrangement = true
    axis = .vertical
    alignment = .fill
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

// MARK: - HistoryContentPictureViewProperty

struct HistoryContentPictureViewProperty {
  /// yyyy. mm. dd 형식의 날짜 String
  let date: String

  /// 컨텐츠의 이미지 입니다.
  let pictureURL: URL?

  /// 먹은 시간에 대한 표시를 위한 Property 입니다.
  let title: String
}
