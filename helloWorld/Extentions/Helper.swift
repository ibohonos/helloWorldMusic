//
//  Helper.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 09.07.2020.
//

import Foundation

func setUserDark(_ dark: Bool) -> Void {
    UserDefaults.standard.set(dark, forKey: "UserDark")
}

func getUserDark() -> Bool {
    let isDark = UserDefaults.standard.object(forKey: "UserDark") as? Bool
    
    return isDark == nil ? false : isDark!
}

func getErrorMessage(_ error: APIService.APIError) -> (String, String, Int) {
    var title = "Error"
    var err = ""
    var code = 500
    
    switch error {
    case let .dataError(error):
        err = error.error.message
        code = error.error.code
    case let .appleDataError(error):
        title = error.errors.first?.title ?? title
        err = error.errors.first?.detail ?? err
        code = Int(error.errors.first?.code ?? "500") ?? 500
    case .noResponse:
        err = "No Response"
    case .jsonDecodingError:
        err = "JSON Decode Error"
    default:
        err = error.localizedDescription
    }
    
    return (title, err, code)
}
