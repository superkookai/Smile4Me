//
//  ContentView.swift
//  Smile4Me
//
//  Created by Weerawut on 22/12/2568 BE.
//

import SwiftUI

struct JokeContentView: View {
    let jokeManager = JokeManager()
    @State private var joke: Joke?
    @State private var category: Category = .Any
    @State private var language: Language = .en
    @State private var errorMessage = ""
    @State private var fetching = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            ZStack {
                if fetching {
                    ProgressView()
                }
                
                ScrollView {
                    VStack {
                        HStack {
                            Picker("Language", selection: $language) {
                                ForEach(Language.allCases) { ln in
                                    Text(ln.name)
                                        .tag(ln)
                                }
                            }
                            
                            Picker("Category", selection: $category) {
                                ForEach(Category.allCases) { cat in
                                    Text(cat.rawValue)
                                        .tag(cat)
                                }
                            }
                        }
                        
                        Button {
                            Task {
                                await getJoke()
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        JokeView(joke: joke, erroMessage: errorMessage)
                        
                        HStack {
                            Spacer()
                            if let joke {
                                ShareLink(item: joke.fullJoke)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            if let joke {
                                Button("Report Joke") {
                                    let jokeToReport = "\(joke.id)\n\(joke.fullJoke)"
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([.string], owner: nil)
                                    pasteboard.setString(jokeToReport, forType: .string)
                                    guard let url = URL(string: jokeManager.issueUrl)  else { return }
                                    openURL(url)
                                }
                                
                                Text("You can report an unsafe joke. The joke id and content will be on your clipboard.")
                                    .font(.caption)
                                    .lineLimit(nil)
                                    .foregroundStyle(.red)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Smile4Me")
        }
        .task {
            await getJoke()
        }
        .task(id: language) {
            await getJoke()
        }
        .task(id: category) {
            await getJoke()
        }
    }
    
    private func getJoke() async {
        errorMessage = ""
        fetching = true
        defer { fetching = false }
        do {
            let joke = try await jokeManager.getJoke(category: category, language: language)
            withAnimation {
                self.joke = joke
            }
        } catch {
            errorMessage = "No Joke for \(category) - \(language.name)"
        }
    }
}

#Preview {
    JokeContentView()
}
