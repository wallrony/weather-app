//
//  InfraErrors.swift
//  weather-app
//
//  Created by Rony on 10/11/22.
//

import Foundation

private protocol error: LocalizedError {
    var message: String { get }
    
    init(message: String)
}

struct DomainError: error {
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    static func unexpectedError() -> DomainError {
        return DomainError(message: "An unexpected error occurred. Please contact the support.")
    }
}
