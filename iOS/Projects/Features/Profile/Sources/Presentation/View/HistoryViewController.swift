//
//  HistoryViewController.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/15/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit

// MARK: - HistoryViewController

final class HistoryViewController: UIViewController {
  let property: HistoryContentPictureViewProperty
  private var contentWidth: CGFloat {
    guard let screenWidth = view.window?.screen.bounds.width else {
      return 345
    }
    return screenWidth - 24 + 2
  }

  init(property: HistoryContentPictureViewProperty) {
    self.property = property
    super.init(nibName: nil, bundle: nil)

    setup()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("cant use this moethod")
  }

  private lazy var contentView: HistoryContentPictureView = {
    let view = HistoryContentPictureView(frame: .zero, contentPictureViewProperty: property)

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}

private extension HistoryViewController {
  func setup() {
    view.backgroundColor = .black.withAlphaComponent(Constants.backgroundAlpha)
    setupConstraintsAndLayouts()
  }

  func setupConstraintsAndLayouts() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(contentView)
    contentView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24).isActive = true
    contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24).isActive = true
  }

  enum Constants {
    static let backgroundAlpha: CGFloat = 0.8
  }
}
