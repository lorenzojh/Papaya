//
//  ChatView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 7/22/25.
//

import SwiftUI

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isFromCurrentUser: Bool
}

struct ChatView: View {
    let userName: String
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hey, uhh come over ;)", isFromCurrentUser: false),
        ChatMessage(text: "Hey, are you real?", isFromCurrentUser: true)
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isFromCurrentUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue.opacity(0.7))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .foregroundColor(.black)
                                        .cornerRadius(12)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                    
                    // Auto-scroll to the latest message
                    .onChange(of: messages) { _ in
                        if let last = messages.last {
                            scrollViewProxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Button(action: {
                    guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    messages.append(ChatMessage(text: messageText, isFromCurrentUser: true))
                    messageText = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
        }
    }
}
