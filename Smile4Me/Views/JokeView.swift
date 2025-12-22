//
//  JokeView.swift
//  Smile4Me
//
//  Created by Weerawut on 22/12/2568 BE.
//

import SwiftUI

struct JokeView: View {
    let joke: Joke?
    let erroMessage: String
    @State private var deliveryRedacted = true
    
    var body: some View {
        VStack(alignment: .leading) {
            if !erroMessage.isEmpty {
                ContentUnavailableView {
                    Text("😢")
                        .font(.system(size: 100))
                } description: {
                    Text(erroMessage)
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
            } else if let joke {
                HStack(alignment: .top) {
                    Text(joke.category.emoji)
                        .font(.system(size: 60))
                    VStack(alignment: .leading) {
                        switch joke.type {
                        case .single:
                            Text(joke.joke ?? "")
                        case .twopart:
                            Text(joke.setup ?? "")
                            
                            Divider()
                            
                            HStack {
                                Text(joke.delivery ?? "")
                                    .redacted(reason: deliveryRedacted ? .placeholder : [])
                                
                                Button {
                                    withAnimation {
                                        deliveryRedacted.toggle()
                                    }
                                } label: {
                                    Image(systemName: deliveryRedacted ? "eye" : "eye.slash")
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
        }
        .font(.title2)
        .task(id: joke) {
            deliveryRedacted = true
        }
    }
}

#Preview("No Joke") {
    JokeView(joke: nil, erroMessage: "No Joke for Programming - fr")
}

#Preview("Single Joke") {
    JokeView(joke: Joke.single, erroMessage: "")
}

#Preview("TwoPart Joke") {
    JokeView(joke: Joke.twopart, erroMessage: "")
}
