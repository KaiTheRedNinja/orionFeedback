//
//  Discussion.swift
//  orionFeedback
//
//  Created by Kai Quan Tay on 12/3/23.
//

import Foundation

/// A struct representing a discussion
struct Discussion: Identifiable {
    var id: Int

    /// The discussion's tags
    var tags: [Tag]
    /// The author of the post
    var author: User
    /// The title of the post
    var title: String
    /// The number of votes the post has
    var votes: Int
    /// The number of comments the post has
    var commentCount: Int
    /// The description of the post
    var description: String?
}
