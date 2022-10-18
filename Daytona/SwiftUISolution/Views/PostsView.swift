//
//  PostsView.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/5/22.
//

import SwiftUI
import Combine

struct PostsView: View {

    @ObservedObject var postsViewModel: PostsViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(postsViewModel.posts, id: \.id) { post in
                    PostRow(post: post)
                }
            }
        }
        .navigationTitle("postsViewController.title")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { 
            postsViewModel.fetchPosts()
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        let data = try! Data.init(contentsOf: Bundle.main.url(forResource: "mockedPosts", withExtension: "json")!) 
        let postsViewModel = PostsViewModel(dataService: CDataService())
        postsViewModel.posts = try! JSONDecoder().decode([Post].self, from: data)
        return PostsView(postsViewModel: postsViewModel)
    }
}
