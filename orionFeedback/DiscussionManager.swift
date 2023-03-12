//
//  DiscussionManager.swift
//  orionFeedback
//
//  Created by Kai Quan Tay on 12/3/23.
//

import Foundation

class DiscussionManager: ObservableObject {
    /// The default instance
    static var `default`: DiscussionManager = .init()

    /// An array of the loaded discussions
    @Published
    var discussions: [Discussion] = []

    /// The number of discussions per page
    @Published
    var pageSize: Int = 0

    /// The total number of pages
    @Published
    var totalPages: Int = 0

    /// The total number of results
    @Published
    var totalResults: Int = 0

    private init() {}

    /// Loads a given page
    func loadPage(page: Int) {
        let url = URL(string: "https://orionfeedback.org/api/discussions?page%5Boffset%5D=\(page*pageSize)")!
        var request = URLRequest(url: url)
        request.setValue("done", forHTTPHeaderField: "secondaryTag")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            }

            guard let data, let results = self?.parseResults(jsonData: data) else { return }

            DispatchQueue.main.async {
                self?.discussions.append(contentsOf: results)
            }
        }

        task.resume()
    }

    /// Parses the JSON provided by the API into an array of discussions
    func parseResults(jsonData: Data) -> [Discussion] {
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            print("json data malformed")
            return []
        }

        guard let meta = json["meta"] as? [String: Int],
              let pageSize = meta["pageSize"],
              let totalPages = meta["totalPages"],
              let totalResults = meta["totalResults"]
        else { return [] }
        DispatchQueue.main.async {
            self.pageSize = pageSize
            self.totalPages = totalPages
            self.totalResults = totalResults
        }

        guard let discussionData = json["data"] as? [[String: Any]] else { return [] }
        var discussions: [Discussion] = []
        for discussion in discussionData {
            guard let newDiscussion = parseDiscussion(json: discussion) else { continue }
            discussions.append(newDiscussion)
        }
        return discussions
    }

    /* NOTES:
     links/ and included/ are useless

     meta/pageSize is posts on a page
     meta/totalPages is the total number of pages
     meta/totalResults is the total number of pages
     data/ contains the discussions

     data/id is the post ID
     data/relationships/tags/data contains the tags
     data/relationships/user/data contains the poster's information
     data/attributes/title is the title
     data/votes is the number of votes
     data/commentCount is the number of comments
     data/customMeta/description is the subheadline
     */
    /// Parses a single discussion
    func parseDiscussion(json: [String: Any]) -> Discussion? {
        // get the components of the data
        guard let idString = json["id"] as? String,
              let id = Int(idString),
              let relationships = json["relationships"] as? [String: Any],
              let type = json["type"] as? String, type == "discussions",
              let attributes = json["attributes"] as? [String: Any]
        else { return nil }

        // process the tags
        guard let tagsRaw = relationships["tags"] as? [String: Any],
              let tagsData = tagsRaw["data"] as? [[String: String]]
        else { return nil }
        let tags: [Tag] = tagsData.compactMap { data in
            guard let type = data["type"], type == "tags",
                  let idString = data["id"],
                  let tagID = Int(idString)
            else { return nil }
            return .init(id: tagID)
        }

        // process the author
        guard let userRaw = relationships["user"] as? [String: [String: String]],
              let userData = userRaw["data"],
              userData["type"] == "users",
              let userIDString = userData["id"],
              let userID = Int(userIDString)
        else { return nil }
        let user = User(id: userID)

        // process other attributes
        guard let title = attributes["title"] as? String,
              let votes = attributes["votes"] as? Int,
              let commentCount = attributes["commentCount"] as? Int,
              let customMeta = attributes["customMeta"] as? [String: String]
        else { return nil }

        return .init(id: id,
                     tags: tags,
                     author: user,
                     title: title,
                     votes: votes,
                     commentCount: commentCount,
                     description: customMeta["description"])
    }
}
