//
//  UIButton+.swift
//  CombineCocoa
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import UIKit

public extension UIButton {
  func touchupInsidePublisher() -> AnyPublisher<Void, Never> {
    publisher(event: .touchUpInside).map { _ in return }.eraseToAnyPublisher()
  }
}
