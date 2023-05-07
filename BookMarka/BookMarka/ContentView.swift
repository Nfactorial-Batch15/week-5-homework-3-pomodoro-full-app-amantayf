//
//  ContentView.swift
//  BookMarka
//
//  Created by Fatima Amantay on 07.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var bookmarks: [Bookmark] = []
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookmarks) { bookmark in
                    NavigationLink(
                        destination: URL(string: bookmark.url)!,
                        label: {
                            Text(bookmark.name)
                        })
                }
                .onDelete(perform: deleteBookmark)
            }
            .navigationBarTitle("Bookmarks")
            .navigationBarItems(trailing: Button(action: {
                addBookmark()
            }, label: {
                Image(systemName: "plus")
            }))
        }
        .onAppear {
            if isFirstLaunch {
                showWelcomeScreen()
                isFirstLaunch = false
            }
        }
    }
    
    func showWelcomeScreen() {
        let welcomeScreen = UIAlertController(title: "Welcome to My Bookmarks", message: "Add your favorite websites and access them easily.", preferredStyle: .alert)
        welcomeScreen.addAction(UIAlertAction(title: "Got it!", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(welcomeScreen, animated: true)
    }
    
    func addBookmark() {
        let addBookmarkAlert = UIAlertController(title: "Add Bookmark", message: nil, preferredStyle: .alert)
        addBookmarkAlert.addTextField { textField in
            textField.placeholder = "Name"
        }
        addBookmarkAlert.addTextField { textField in
            textField.placeholder = "URL"
        }
        addBookmarkAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        addBookmarkAlert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = addBookmarkAlert.textFields?.first?.text,
                  let url = addBookmarkAlert.textFields?.last?.text,
                  !name.isEmpty, !url.isEmpty else {
                      return
                  }
            let bookmark = Bookmark(name: name, url: url)
            bookmarks.append(bookmark)
        })
        UIApplication.shared.windows.first?.rootViewController?.present(addBookmarkAlert, animated: true)
    }
    
    func deleteBookmark(at offsets: IndexSet) {
        bookmarks.remove(atOffsets: offsets)
    }
}

struct Bookmark: Identifiable {
    let id = UUID()
    let name: String
    let url: String
}

