//
//  InfoView.swift
//  Smile4MeiOS
//
//  Created by Weerawut on 23/12/2568 BE.
//

import SwiftUI
import Charts

struct InfoView: View {
    let jokeManager = JokeManager()
    @State private var info: Info?
    @State private var errorMessage = ""
    @State private var fetching = false
    @State private var chartItems: [ChartItem] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                if fetching {
                    ProgressView()
                }
                
                if let info = info {
                    VStack {
                        Text("\(info.jokes.totalCount) jokes")
                            .font(.largeTitle)
                        
                        Chart {
                            ForEach(chartItems) { item in
                                BarMark(x: .value("Language", item.lang), y: .value("Total", item.qty)
                                )
                                .position(by: .value("Type", item.jokeType.rawValue))
                                .foregroundStyle(by: .value("Type", item.jokeType.rawValue))
                                .annotation(position: .top, alignment: .center) {
                                    Text("\(item.qty)")
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    Text(errorMessage)
                }
            }
            .navigationTitle("Jokes Distribution")
        }
        .task {
            await getInfo()
            buildChartInfo()
        }
    }
    
    private func getInfo() async {
        errorMessage = ""
        fetching = true
        defer { fetching = false }
        do {
            let info = try await jokeManager.getInfo()
            withAnimation {
                self.info = info
            }
        } catch {
            errorMessage = "No Jokes Information"
        }
    }
    
    private func buildChartInfo() {
        var chartItems: [ChartItem] = []
        if let info {
            for safeJoke in info.jokes.safeJokes {
                let langName = Language(rawValue: safeJoke.lang)!.name
                let item = ChartItem(lang: langName, qty: safeJoke.count, jokeType: .safe)
                chartItems.append(item)
                
                let langTotal = info.jokes.langCount[safeJoke.lang] ?? 0
                let unsafeCount = langTotal - safeJoke.count
                let unsafeItem = ChartItem(lang: langName, qty: unsafeCount, jokeType: .unsafe)
                chartItems.append(unsafeItem)
            }
        }
        
        self.chartItems = chartItems
    }
 }

#Preview {
    InfoView()
}
