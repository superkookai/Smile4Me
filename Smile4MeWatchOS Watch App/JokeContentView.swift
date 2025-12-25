//
//  ContentView.swift
//  Smile4MeWatchOS Watch App
//
//  Created by Weerawut on 25/12/2568 BE.
//

import SwiftUI

struct JokeContentView: View {
    let jokeManager = JokeManager()
    @State private var joke: Joke?
    @State private var fetching = false
    @State private var errorMessage = ""
    @State private var category: Category = .Any
    @State private var language: Language = .en
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Picker("Language", selection: $language) {
                        ForEach(Language.allCases) {
                            Text($0.name)
                                .tag($0)
                        }
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(Category.allCases) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                }
                .frame(height: 40)
                
                VStack {
                    if let joke {
                        JokeView(joke: joke)
                    } else {
                        ContentUnavailableView {
                            Text("😢")
                                .font(.system(size: 50))
                            
                        } description: {
                            Text(errorMessage)
                        }
                    }
                }
                .overlay(content: {
                    if fetching {
                        ProgressView()
                    }
                })
            }
            .navigationTitle("Smile4Me")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await getJoke()
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }

                }
            })
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
            self.joke = nil
            self.errorMessage = "No Joke available for \(category) in \(language.name)."
        }
    }
}

#Preview {
    JokeContentView()
}
