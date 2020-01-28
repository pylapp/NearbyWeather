//
//  GlobalFunctions.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 29.01.20.
//  Copyright © 2020 Erik Maximilian Martens. All rights reserved.
//

import Foundation

func printDebugMessage(string: String) {
  guard !BuildEnvironment.isReleaseEvironment() else {
    return
  }
  print("💥  \(string)")
}
