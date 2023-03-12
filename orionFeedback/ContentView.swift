//
//  ContentView.swift
//  orionFeedback
//
//  Created by Kai Quan Tay on 12/3/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var manager: DiscussionManager = .default

    @State
    var page: Int = 0

    var body: some View {
        ScrollView {
            if (page*manager.pageSize) >= manager.discussions.count {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Loading...")
                        Spacer()
                    }
                    Spacer()
                }
            }
            VStack {
                ForEach(0..<20, id: \.self) { index in
                    if (page*manager.pageSize + index) < manager.discussions.count {
                        groupBoxFor(index: index)
                    }
                }

                HStack {
                    if page-3 > 0 {
                        buttonFor(pageNumber: 0)
                        Text("...")
                    }

                    ForEach([-2, -1, 0, 1, 2], id: \.self) { offset in
                        if page+offset >= 0 && page+offset < manager.totalPages-1 {
                            buttonFor(pageNumber: page+offset)
                        }
                    }

                    if manager.totalPages-1 - 3 > page {
                        buttonFor(pageNumber: manager.totalPages-1)
                        Text("...")
                    }
                }
            }
            .padding(10)
        }
        .onAppear {
            manager.loadPage(page: page)
        }
        .onChange(of: page) { _ in
            manager.loadPage(page: page)
        }
    }

    @ViewBuilder
    func groupBoxFor(index: Int) -> some View {
        let discussion = manager.discussions[page*manager.pageSize + index]
        GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text(discussion.title)
                    if let description = discussion.description {
                        Text(description)
                            .font(.subheadline)
                    }
                    HStack {
                        Image(systemName: "arrowtriangle.up.square.fill")
                        Text(String(discussion.votes))
                        Spacer().frame(width: 20)
                        Image(systemName: "bubble.left")
                        Text(String(discussion.commentCount))
                    }
                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    func buttonFor(pageNumber: Int) -> some View {
        if page == pageNumber {
            Button {} label: {
                Text("\(pageNumber+1)")
            }
            .buttonStyle(.borderedProminent)
        } else {
            Button {
                page = pageNumber
            } label: {
                Text("\(pageNumber+1)")
            }
            .buttonStyle(.bordered)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
