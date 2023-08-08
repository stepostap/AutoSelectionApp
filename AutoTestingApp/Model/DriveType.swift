//
//  DriveType.swift
//  AutoTestingApp
//
//  Created by Stepan Ostapenko on 07.08.2023.
//

import Foundation

enum DriveType: Int16, CaseIterable {
    case front
    case rear
    case full
}

extension DriveType: CustomStringConvertible {
    var description: String {
        switch self {
        case .front:
            return "Передний привод"
        case .rear:
            return "Задний привод"
        case .full:
            return "Полный привод"
        }
    }
}
