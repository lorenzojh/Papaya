//
//  MessagesView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 7/22/25.
//

import SwiftUI

struct ChatPreview: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let lastMessage: String
}
struct ChatRow: View {
    let chat: ChatPreview

    var body: some View {
        HStack {
            Image(chat.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name)
                    .font(.headline)

                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct MessagesView: View {
    let chats = [
        ChatPreview(name: "Katie", imageName:"katie", lastMessage: "Hey, uhh come over ;)" )]
    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatView(userName: chat.name)){
                    ChatRow(chat: chat)
                }
            }
            .navigationTitle("Messages")
        }
    }
}
