//
//  MealGokSuccessContentView.swift
//  MealTimerFeature
//
//  Created by MaraMincho on 2/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit
import DesignSystem

final class MealGokSuccessContentView: UIView {
  
  private let property: MealGokSuccessContentViewProperty
  
  override var intrinsicContentSize: CGSize {
    return .init(width: Metrics.imageWidth + Metrics.contentInset * 2, height: descriptionLabel.bounds.maxY)
  }
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.text = property.date
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "figure.run"))
    imageView.contentMode = .scaleAspectFill
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var descriptionTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.text = property.date
    label.font = .preferredFont(forTextStyle: .title2, weight: .semibold)
    label.textAlignment = .center
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = DesignSystemColor.primaryText
    label.text = property.date
    label.font = .preferredFont(forTextStyle: .body, weight: .semibold)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func setupLayout() {
    addSubview(dateLabel)
    dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.contentInset).isActive = true
    dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.contentInset).isActive = true
    dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.contentInset).isActive = true
    
    addSubview(descriptionImageView)
    descriptionImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Metrics.dateAndImageSpacing).isActive = true
    descriptionImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    descriptionImageView.widthAnchor.constraint(equalToConstant: Metrics.imageWidth).isActive = true
    descriptionImageView.heightAnchor.constraint(equalToConstant: Metrics.imageHeight).isActive = true
    
    addSubview(descriptionTitleLabel)
    descriptionTitleLabel.topAnchor
      .constraint(equalTo: descriptionImageView.bottomAnchor, constant: Metrics.imageAndDescriptionLabelSpacing).isActive = true
    descriptionTitleLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
    descriptionTitleLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
    
    addSubview(descriptionLabel)
    descriptionLabel.topAnchor
      .constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: Metrics.descriptionLabelsSpacing).isActive = true
    descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
    descriptionLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive = true
  }
  
  init(frame: CGRect, mealGokContentProperty: MealGokSuccessContentViewProperty) {
    self.property = mealGokContentProperty
    super.init(frame: frame)
    setupLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("Cant use this method")
  }
  
  private enum Metrics {
    static let contentInset: CGFloat = 12
    
    static let imageHeight: CGFloat = 240
    static let imageWidth: CGFloat = 320
    
    static let dateAndImageSpacing: CGFloat = 12
    
    static let imageAndDescriptionLabelSpacing: CGFloat = 12
    
    static let descriptionLabelsSpacing: CGFloat = 12
  }
  
  private enum Constants {
    
  }
}

struct MealGokSuccessContentViewProperty {
  /// yyyy. mm. dd 형식의 날짜 String
  let date: String
  
  let pictureURL: URL?
  
  let description: String
}
