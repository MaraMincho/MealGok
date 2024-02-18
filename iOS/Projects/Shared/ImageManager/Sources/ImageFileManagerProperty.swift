//
//  ImageFileManagerProperty.swift
//  ImageManager
//
//  Created by MaraMincho on 2/18/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import UIKit
final class ImageFileManagerProperty {
  
  //MARK: - Static Property
  static let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  static let imageDirPath = documentPath.appending(path: Constants.dirName)
  static let fileManger = FileManager.default
  static let imageNetworkFetchManager = ImageNetworkFetchManager()
  
  //MARK: - SingleTone Shared Property
  static let shared = ImageFileManagerProperty()
  
  //MARK: - StoreProperty
  var targetViewAndFetchProperty: NSMapTable<UIImageView, FetchDescriptionProperty> = .weakToStrongObjects()
  
  
  private enum Constants {
    static let dirName: String = "MealGokImages"
  }

  private init() { }
}
