//
//  JokeView.swift
//  Smile4MeWatchOS Watch App
//
//  Created by Weerawut on 25/12/2568 BE.
//

import SwiftUI

struct JokeView: View {
    let joke: Joke
    
    var body: some View {
        HStack(alignment: .top) {
            Text(joke.category.emoji)
                .font(.system(size: 40))
            
            Text(joke.fullJoke)
                .lineLimit(nil)
            
            Spacer()
        }
    }
}

#Preview {
    JokeView(joke: Joke.twopart)
}
