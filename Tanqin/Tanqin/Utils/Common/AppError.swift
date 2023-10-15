//
//  AppError.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//

import Foundation

enum NetworkErrorType: Int, Error {
    case UNAUTHORIZED = 401
    case INVALID_TOKEN = 403
}

enum ErrorType: Int {
    case network = 1
    case firebase = 2
    case app = 3
    case UNAUTHORIZED = 401
    case INVALID_TOKEN = 403
}

struct AppError: Error {
    let code: Int
    let message: String
}
