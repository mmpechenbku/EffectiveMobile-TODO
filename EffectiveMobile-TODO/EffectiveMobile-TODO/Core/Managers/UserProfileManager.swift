//
//  UserProfileManager.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 15.04.2025.
//

import UIKit

final class UserProfileManager {
    private enum Keys {
        static let apiDataLoadedKey = "apiDataLoaded"
    }

    func isApiDataAlreadyLoaded() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.apiDataLoadedKey)
    }

    func setApiDataLoadingState(isLoaded: Bool) {
        UserDefaults.standard.setValue(isLoaded, forKey: Keys.apiDataLoadedKey)
    }
}
