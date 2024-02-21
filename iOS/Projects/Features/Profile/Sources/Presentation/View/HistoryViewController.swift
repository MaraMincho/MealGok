//
//  HistoryViewController.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/15/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

// MARK: - HistoryViewController

final class HistoryViewController: UIViewController {
  private let property: HistoryContentPictureViewProperty
  private var subscription: Set<AnyCancellable> = .init()

  init(property: HistoryContentPictureViewProperty, contentImage: UIImage?) {
    self.property = property
    super.init(nibName: nil, bundle: nil)

    contentView.setImage(image: contentImage)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("cant use this moethod")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
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
    setupUserInteraction()
  }

  func setupConstraintsAndLayouts() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(contentView)
    contentView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24).isActive = true
    contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24).isActive = true
  }

  func setupUserInteraction() {
    view.publisher(gesture: .tap)
      .sink { [weak self] _ in
        self?.dismiss(animated: true)
      }
      .store(in: &subscription)
  }

  enum Constants {
    static let backgroundAlpha: CGFloat = 0.8
  }
}
