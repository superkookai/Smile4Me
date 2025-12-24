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
    #if os(iOS)
    @Environment(Router.self) var router
    #endif
    
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
                        .buttonStyle(.bordered)
                        
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
#if os(iOS)
                        if let joke {
                            TranslationView(joke: joke)
                        }

#endif
                        
                        HStack(alignment: .top) {
                            if let joke {
                                Button("Report Joke", role: .destructive) {
                                    let jokeToReport = "\(joke.id)\n\(joke.fullJoke)"
                                    
#if os(macOS)
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([.string], owner: nil)
                                    pasteboard.setString(jokeToReport, forType: .string)
#else
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string = jokeToReport
#endif
                                    
                                    guard let url = URL(string: jokeManager.issueUrl)  else { return }
                                    openURL(url)
                                }
                                .buttonStyle(.bordered)
                                
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
        .firstOnAppear(perform: {
            Task { await getJoke() }
        })
        .onChange(of: language) {
            Task { await getJoke() }
        }
        .onChange(of: category) {
            Task { await getJoke() }
        }
        #if os(iOS)
        .onChange(of: router.components) { _, componentsString in
            if let componentsString,
               let id = componentsString.components(separatedBy: "-").first, let langauge = componentsString.components(separatedBy: "-").last {
                let category = componentsString.components(separatedBy: "-")[1]
                Task {
                    if let joke = try? await jokeManager.getLinkJoke(category: category, language: langauge, id: id) {
                        self.joke = joke
                        router.components = nil
                    }
                }
            }
        }
        #endif
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
    #if os(iOS)
        .environment(Router())
    #endif
}

struct FirstOnAppearModifier: ViewModifier {
    @State private var hasPerformAction = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasPerformAction {
                    hasPerformAction = true
                    action?()
                }
            }
    }
}

extension View {
    func firstOnAppear(perform action: (() -> Void)? = nil) -> some View {
        modifier(FirstOnAppearModifier(action: action))
    }
}
