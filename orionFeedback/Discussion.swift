//
//  Discussion.swift
//  orionFeedback
//
//  Created by Kai Quan Tay on 12/3/23.
//

import Foundation

struct Discussion: Identifiable {
    var id: Int

    var tags: [Tag]
    var author: User
    var title: String
    var votes: Int
    var commentCount: Int
    var description: String?
}
