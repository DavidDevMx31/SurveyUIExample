//
//  SurveyViewModelError.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import Foundation

enum SurveyError: LocalizedError {
    case textIsEmpty
    case noSelection
}

extension SurveyError {
    var failureReason: String? {
        switch self {
        case .textIsEmpty:
            return "El texto de comentarios está vacío"
        case .noSelection:
            return "No has seleccionado ninguna opción"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .textIsEmpty:
            return "El texto de comentarios es requerido"
        case .noSelection:
            return "Seleccionar una opción es requerido"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .textIsEmpty:
            return "Agrega tus comentarios"
        case .noSelection:
            return "Selecciona una opción"
        }
    }
}
