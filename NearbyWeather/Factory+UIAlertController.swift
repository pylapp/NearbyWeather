//
//  Factory+UIAlertController.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 09.02.20.
//  Copyright © 2020 Erik Maximilian Martens. All rights reserved.
//

import UIKit.UIAlertController
import MapKit

extension Factory {
  
  struct AlertController: FactoryFunction {
    
    enum AlertControllerType {
      case weatherListType(currentListType: ListType, completionHandler: ((ListType) -> Void))
      case weatherMapType(currentMapType: MKMapType, completionHandler: ((MKMapType) -> Void))
      case focusMapOnLocation(bookmarks: [WeatherInformationDTO], completionHandler: ((WeatherInformationDTO?) -> Void))
      case preferredBookmarkOptions(options: [PreferredBookmark], completionHandler: ((Bool) -> Void))
      case preferredAmountOfResultsOptions(options: [AmountOfResults], completionHandler: ((Bool) -> Void))
      case preferredSortingOrientationOptions(options: [SortingOrientation], completionHandler: ((Bool) -> Void))
      case preferredTemperatureUnitOptions(options: [TemperatureUnit], completionHandler: ((Bool) -> Void))
      case pushNotificationsDisabled
      case dimissableNotice(title: String?, message: String?)
    }
    
    typealias InputType = AlertControllerType
    typealias ResultType = UIAlertController
    
    static func make(fromType type: InputType) -> ResultType {
      switch type {
      case let .weatherListType(currentListType, completionHandler):
        return weatherListTypeAlert(
          currentListType: currentListType,
          completionHandler: completionHandler
        )
      case let .weatherMapType(currentMapType, completionHandler):
        return weatherMapTypeAlert(
          currentMapType: currentMapType,
          completionHandler: completionHandler
        )
      case let .focusMapOnLocation(bookmarks, completionHandler):
        return focusMapOnLocationAlert(
          bookmarks: bookmarks,
          completionHandler: completionHandler
        )
      case let .preferredBookmarkOptions(options, completionHandler):
        return preferredBookmarkOptionsAlert(
          options: options,
          completionHandler: completionHandler
        )
      case let .preferredAmountOfResultsOptions(options, completionHandler):
        return preferredAmountOfResultsOptionsAlert(
          options: options,
          completionHandler: completionHandler
        )
      case let .preferredSortingOrientationOptions(options, completionHandler):
        return preferredSortingOrientationOptionsAlert(
          options: options,
          completionHandler: completionHandler
        )
      case let .preferredTemperatureUnitOptions(options, completionHandler):
        return preferredTemperatureUnitOptionsAlert(
          options: options,
          completionHandler: completionHandler
        )
      case .pushNotificationsDisabled:
        return pushNotificationsDisabledAlert()
      case let .dimissableNotice(title, message):
        return dimissableNoticeAlert(
          title: title,
          message: message
        )
      }
    }
  }
}

private extension Factory.AlertController {
  
  static func weatherListTypeAlert(currentListType: ListType, completionHandler: @escaping ((ListType) -> Void)) -> UIAlertController {
    let actions = ListType.allCases.map { listType -> UIAlertAction in
      let action = UIAlertAction(title: listType.title, style: .default, handler: { _ in
        completionHandler(listType)
      })
      if listType == currentListType { action.setValue(true, forKey: Constants.Keys.KeyValueBindings.kChecked) }
      return action
    }
    
    return UIAlertController(
      title: R.string.localizable.select_list_type().capitalized,
      actions: actions,
      canceable: true
    )
  }
  
  static func weatherMapTypeAlert(currentMapType: MKMapType, completionHandler: @escaping ((MKMapType) -> Void)) -> UIAlertController {
    let actions = MKMapType.supportedCases.map { mapType -> UIAlertAction in
      let action = UIAlertAction(title: mapType.title, style: .default, handler: { _ in
        completionHandler(mapType)
      })
      if mapType == currentMapType { action.setValue(true, forKey: Constants.Keys.KeyValueBindings.kChecked) }
      return action
    }
    
    return UIAlertController(
      title: R.string.localizable.select_map_type().capitalized,
      actions: actions,
      canceable: true
    )
  }
  
  static func focusMapOnLocationAlert(bookmarks: [WeatherInformationDTO], completionHandler: @escaping ((WeatherInformationDTO?) -> Void)) -> UIAlertController {
    var actions = bookmarks.map { bookmark -> UIAlertAction in
      let action = UIAlertAction(title: bookmark.cityName, style: .default, handler: { _ in
        completionHandler(bookmark)
      })
      action.setValue(R.image.locateFavoriteActiveIcon(), forKey: Constants.Keys.KeyValueBindings.kImage)
      return action
    }
    
    let currentLocationAction = UIAlertAction(
      title: R.string.localizable.current_location(),
      style: .default,
      handler: { _ in completionHandler(nil) }
    )
    actions.append(currentLocationAction)
    currentLocationAction.setValue(R.image.locateUserActiveIcon(), forKey: Constants.Keys.KeyValueBindings.kImage)
    
    return UIAlertController(
      title: R.string.localizable.focus_on_location(),
      actions: actions,
      canceable: true
    )
  }
  
  static func preferredBookmarkOptionsAlert(options: [PreferredBookmark], completionHandler: @escaping ((Bool) -> Void)) -> UIAlertController {
    
    let actions = options.map { option -> UIAlertAction in
      let actionIsSelected = PreferencesManager.shared.preferredBookmark.value == option.value
      
      let action = UIAlertAction(title: option.stringValue, style: .default, handler: { _ in
        let previousOption = PreferencesManager.shared.preferredBookmark
        PreferencesManager.shared.preferredBookmark = option
        completionHandler(previousOption.value != option.value)
      })
      action.setValue(actionIsSelected, forKey: Constants.Keys.KeyValueBindings.kChecked)
      return action
    }
    
    return UIAlertController(
      title: R.string.localizable.preferred_bookmark(),
      actions: actions,
      canceable: true
    )
  }
  
  static func preferredAmountOfResultsOptionsAlert(options: [AmountOfResults], completionHandler: @escaping ((Bool) -> Void)) -> UIAlertController {
    let actions = options.map { option -> UIAlertAction in
      let actionIsSelected = PreferencesManager.shared.amountOfResults.value == option.value
      
      let action = UIAlertAction(title: option.stringValue, style: .default, handler: { _ in
        let previousOption = PreferencesManager.shared.amountOfResults
        PreferencesManager.shared.amountOfResults = option
        completionHandler(previousOption.value != option.value)
      })
      action.setValue(actionIsSelected, forKey: Constants.Keys.KeyValueBindings.kChecked)
      return action
    }
    
    return UIAlertController(
      title: R.string.localizable.amount_of_results(),
      actions: actions,
      canceable: true
    )
  }
  
  static func preferredSortingOrientationOptionsAlert(options: [SortingOrientation], completionHandler: @escaping ((Bool) -> Void)) -> UIAlertController {
    let actions = options.map { option -> UIAlertAction in
      let actionIsSelected = PreferencesManager.shared.sortingOrientation.value == option.value
      
      let action = UIAlertAction(title: option.stringValue, style: .default, handler: { _ in
        let previousOption = PreferencesManager.shared.sortingOrientation
        PreferencesManager.shared.sortingOrientation = option
        completionHandler(previousOption.value != option.value)
      })
      action.setValue(actionIsSelected, forKey: Constants.Keys.KeyValueBindings.kChecked)
      return action
    }
    
    return UIAlertController(
      title: R.string.localizable.sorting_orientation(),
      actions: actions,
      canceable: true
    )
  }
  
  static func preferredTemperatureUnitOptionsAlert(options: [TemperatureUnit], completionHandler: @escaping ((Bool) -> Void)) -> UIAlertController {
    let actions = options.map { option -> UIAlertAction in
      let actionIsSelected = PreferencesManager.shared.temperatureUnit.value == option.value
      
      let action = UIAlertAction(title: option.stringValue, style: .default, handler: { _ in
        let previousOption = PreferencesManager.shared.temperatureUnit
        PreferencesManager.shared.temperatureUnit = option
        completionHandler(previousOption.value != option.value)
      })
      action.setValue(actionIsSelected, forKey: Constants.Keys.KeyValueBindings.kChecked)
      return action
    }
    
    return UIAlertController(
      title: R.string.localizable.temperature_unit(),
      actions: actions,
      canceable: true
    )
  }
  
  static func pushNotificationsDisabledAlert() -> UIAlertController {
    let action = UIAlertAction(title: R.string.localizable.settings(), style: .default) { _ -> Void in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
        UIApplication.shared.canOpenURL(settingsUrl) else {
          return
      }
      UIApplication.shared.open(settingsUrl, completionHandler: nil)
    }
    
    return UIAlertController(
      title: R.string.localizable.notifications_disabled(),
      message: R.string.localizable.enable_notifications_alert_text(),
      actions: [action],
      canceable: true
    )
  }
  
  static func dimissableNoticeAlert(title: String?, message: String?) -> UIAlertController {
    let action = UIAlertAction(title: R.string.localizable.dismiss(), style: .cancel, handler: nil)
    return UIAlertController(
      title: title,
      message: message,
      actions: [action]
    )
  }
}

private extension UIAlertController {
  
  convenience init(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [UIAlertAction] = [], tintColor: UIColor = .blue, canceable: Bool = false) {
    self.init(title: title, message: message, preferredStyle: style)
    
    actions.forEach { addAction($0) }
    
    if canceable {
      addAction(
        UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil)
      )
    }
    
    view.tintColor = tintColor
  }
}
