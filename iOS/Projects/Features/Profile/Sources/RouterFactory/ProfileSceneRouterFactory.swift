//
//  ProfileSceneRouterFactory.swift
//  ProfileFeature
//
//  Created by MaraMincho on 2/3/24.
//  Copyright © 2024 com.maramincho. All rights reserved.
//

import Combine
import CombineCocoa
import RouterFactory
import UIKit

// MARK: - ProfileSceneRouterable

protocol ProfileSceneRouterable: Routing {
  func pushSettingScene()
}

// MARK: - ProfileSceneRouterFactory

public final class ProfileSceneRouterFactory: RouterFactoryBase {
  override public func build() -> UIViewController {
    let mealGokHistoryFetchRepository = MealGokHistoryFetchRepository()
    let mealGokHistoryFetchUseCase = MealGokHistoryFetchUseCase(fetchRepository: mealGokHistoryFetchRepository)

    let profileFetchRepository = ProfileFetchRepository()
    let profileFetchUseCase = ProfileFetchUseCase(profileFetchRepository: profileFetchRepository)

    let viewModel = ProfileViewModel(
      mealGokHistoryFetchUseCase: mealGokHistoryFetchUseCase,
      profileFetchUseCase: profileFetchUseCase,
      profileSceneRouterable: self
    )
    let initDate = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 1, day: 1).date!
    let property: ProfileViewControllerProperty = .init(startDate: initDate, endDate: Date.now)

    let viewController = ProfileViewController(viewModel: viewModel, property: property)
    let mockViewController = MockViewController(vm: viewModel)

    return mockViewController
  }
}

// MARK: ProfileSceneRouterable

extension ProfileSceneRouterFactory: ProfileSceneRouterable {
  func pushSettingScene() {
    let settingRouterFactory = SettingSceneRouterFactory(parentRouter: self, navigationController: navigationController)
    childRouters.append(settingRouterFactory)
    settingRouterFactory.start(build: settingRouterFactory.build())
  }
}

// MARK: - MockViewController

class MockViewController: UIViewController {
  let vm: ProfileViewModel

  init(vm: ProfileViewModel) {
    self.vm = vm
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError()
  }

  let button = UIButton(type: .system)
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()

    // 화면 배경색 설정
    view.backgroundColor = .red

    // 버튼 생성 및 속성 설정
    button.setTitle("버튼", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    // 버튼을 화면에 추가
    view.addSubview(button)

    // Auto Layout을 이용하여 버튼을 화면 중앙에 배치
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  private let didChangeDate: PassthroughSubject<DateComponents, Never> = .init()
  private let requestMealGokHistory: PassthroughSubject<Void, Never> = .init()
  let requestHistoryContentViewController: PassthroughSubject<MealGokChallengeProperty, Never> = .init()
  private let updateProfileSubject: PassthroughSubject<Void, Never> = .init()

  private var subscription = Set<AnyCancellable>()

  @objc func buttonTapped() {}

  func bind() {
    // 버튼이 눌렸을 때 동작할 내용을 여기에 추가
    let transfrom = vm.transform(input: .init(
      didChangeDate: didChangeDate.eraseToAnyPublisher(),
      fetchMealGokHistory: requestMealGokHistory.eraseToAnyPublisher(),
      showHistoryContent: requestHistoryContentViewController.eraseToAnyPublisher(),
      didTapSettingButton: button.touchupInsidePublisher(),
      updateProfile: updateProfileSubject.eraseToAnyPublisher()
    )
    )

    transfrom
      .sink { [weak self] state in
        switch state {
        default:
          break
        }
      }
      .store(in: &subscription)
  }
}
