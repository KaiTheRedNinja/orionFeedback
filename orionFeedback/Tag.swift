//
//  Tag.swift
//  orionFeedback
//
//  Created by Kai Quan Tay on 12/3/23.
//

import Foundation

/// A struct representing a tag
struct Tag: Identifiable {
    /// Possible values (non-exhaustive list):
    /// - `3`: Feature suggestion
    ///     - `18`: Desktop feature suggestion
    /// - `2`: Bug reports
    ///     - `4`: Desktop bugs
    ///     - `5`: Mobile bugs
    ///     - `28`: Website bugs
    ///     - `6`: Extension bugs
    var id: Int

    /// A string description of the tag
    var description: String {
        switch id {
        case 3: return "Feature suggestion"
        case 18: return "Desktop feature suggestion"
        case 2: return "Bug reports"
        case 4: return "Desktop bugs"
        case 5: return "Mobile bugs"
        case 28: return "Website bugs"
        case 6: return "Extension bugs"
        default: return "Unknown"
        }
    }
}
