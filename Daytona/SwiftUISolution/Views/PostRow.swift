//
//  PostRow.swift
//  Daytona
//
//  Created by Anton Ostrovskii on 9/5/22.
//

import SwiftUI

struct PostRow: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 12) { 
            Text(post.title)
                .font(.system(size: 16.0))
                .bold()
                .foregroundColor(.gray)
            Text(post.body)
                .font(.system(size: 13.0))
                .foregroundColor(.gray)
        }.padding(10.0)
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post(userId: 1, id: 1, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
        PostRow(post: post)
    }
}
