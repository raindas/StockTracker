//
//  NewsView.swift
//  StockTracker
//
//  Created by President Raindas on 03/07/2021.
//

import SwiftUI

struct NewsView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    let dateController = DateController()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("News")
                    .font(.largeTitle.bold())
                Spacer()
            }.padding(.top)
            // News items
            ScrollView {
                ForEach(viewModel.marketNews, id: \.id) { news in
                    VStack(alignment: .leading) {
                        RemoteImage(url: news.image)
                                    .aspectRatio(contentMode: .fill)
                        Text(news.source).foregroundColor(.secondary)
                        Text(news.headline)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.title2.bold())
                        Text(news.summary)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.headline).foregroundColor(.secondary)
                        HStack {
                            Text(dateController.dateDifferece(timestamp: news.datetime))
                            Divider()
                            Text(news.category)
                            Spacer()
                            Link("Read more", destination: URL(string: news.url)!)
                        }
                    }.padding(.vertical)
                }
            }
        }.padding(.horizontal).onAppear {
            viewModel.fetchNews(type: "general", ticker: "")
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView().environmentObject(ViewModel())
    }
}
