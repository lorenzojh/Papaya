//
//  ChatView.swift
//  FoodDate
//
//  Created by Lorenzo Hobbs on 7/22/25.
//
import SwiftUI
import Firebase
import FirebaseFirestore

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isFromCurrentUser: Bool
}

struct ChatView: View {
    let userName: String
    let userId: String  // Firebase UID of the person you're chatting with

    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hey, uhh come over ;)", isFromCurrentUser: false),
        ChatMessage(text: "Hey, are you real?", isFromCurrentUser: true)
    ]

    // Block/Report logic
    @State private var showReportSheet = false
    @State private var reportReason = ""
    @State private var showBlockAlert = false
    @State private var isBlocked = false
    @State private var didCheckBlockStatus = false

    var body: some View {
        Group {
            if didCheckBlockStatus {
                if isBlocked {
                    VStack {
                        Spacer()
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                            .padding(.bottom, 16)
                        Text("You cannot message this user.")
                            .font(.headline)
                        Spacer()
                    }
                } else {
                    fullChatView
                }
            } else {
                ProgressView("Checking block status...")
            }
        }
        .onAppear {
            checkIfUserIsBlocked()
            print("Chatting with userId: \(userId)")
            
        }
        .sheet(isPresented: $showReportSheet) {
            reportSheetView
        }
        .alert("User Blocked", isPresented: $showBlockAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This user has been blocked. They will no longer be able to contact you.")
        }
    }

    // MARK: - Full Chat UI
    var fullChatView: some View {
        VStack {
            // Header with username and menu
            HStack {
                Text("Chatting with \(userName)")
                    .font(.headline)
                    .padding(.leading)

                Spacer()

                Menu {
                    Button(role: .destructive) {
                        blockUser(userIdToBlock: userId)
                    } label: {
                        Label("Block User", systemImage: "hand.raised.fill")
                    }

                    Button(role: .destructive) {
                        showReportSheet = true
                    } label: {
                        Label("Report User", systemImage: "exclamationmark.bubble.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .padding(.trailing)
                }
            }
            .padding(.top)

            // Messages
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
                    .onChange(of: messages) { _ in
                        if let last = messages.last {
                            scrollViewProxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // Message input
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

    // MARK: - Report Sheet View
    var reportSheetView: some View {
        VStack(spacing: 20) {
            Text("Why are you reporting this user?")
                .font(.headline)

            TextEditor(text: $reportReason)
                .frame(height: 100)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

            Button("Submit Report") {
                reportUser(reportedUserId: userId)
                showReportSheet = false
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    // MARK: - Firestore: Block User
    func blockUser(userIdToBlock: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(currentUserId).updateData([
            "blockedUsers": FieldValue.arrayUnion([userIdToBlock])
        ]) { error in
            if let error = error {
                print("❌ Failed to block user: \(error.localizedDescription)")
            } else {
                print("✅ User blocked")
                DispatchQueue.main.async {
                    showBlockAlert = true
                }
            }
        }
    }

    // MARK: - Firestore: Report User
    func reportUser(reportedUserId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        let reportData: [String: Any] = [
            "reportedBy": currentUserId,
            "reportedUser": reportedUserId,
            "reason": reportReason,
            "timestamp": Timestamp()
        ]

        db.collection("reports").addDocument(data: reportData) { error in
            if let error = error {
                print("❌ Failed to report user: \(error.localizedDescription)")
            } else {
                print("✅ Report submitted")
            }
        }

        db.collection("users").document(currentUserId).updateData([
            "reportsSent": FieldValue.arrayUnion([reportedUserId])
        ])
    }

    // MARK: - Check if Either User is Blocked
    func checkIfUserIsBlocked() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(currentUserId).getDocument { doc1, _ in
            let youBlockedThem = (doc1?.data()?["blockedUsers"] as? [String] ?? []).contains(userId)

            db.collection("users").document(userId).getDocument { doc2, _ in
                let theyBlockedYou = (doc2?.data()?["blockedUsers"] as? [String] ?? []).contains(currentUserId)

                DispatchQueue.main.async {
                    self.isBlocked = youBlockedThem || theyBlockedYou
                    self.didCheckBlockStatus = true
                    print("Logged in as: \(Auth.auth().currentUser?.uid ?? "none")")

                }
            }
        }
    }
}
