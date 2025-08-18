//
//  Date+.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
