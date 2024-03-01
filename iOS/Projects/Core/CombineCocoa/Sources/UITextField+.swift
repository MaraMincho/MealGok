//
//  UITextField+.swift
//  CombineCocoa
//
//  Created by MaraMincho on 3/1/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import UIKit

public extension UITextField {
  func textPublisher() -> AnyPublisher<String, Never> {
    return publisher(event: .editingChanged)
      .compactMap { control in
        guard let text = (control as? UITextField)?.text else {
          return nil
        }
        return text
      }
      .eraseToAnyPublisher()
  }
}
