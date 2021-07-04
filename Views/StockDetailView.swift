//
//  StockDetailView.swift
//  StockTracker
//
//  Created by President Raindas on 02/07/2021.
//

import SwiftUI

struct StockDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var detailScreenModal: Bool
    
    let dateController = DateController()
    
    let open: Double
    let high: Double
    let low: Double
    let current: Double
    let prevClose: Double
    let change: String
    let symbol: String
    let description: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(symbol).font(.largeTitle.bold())
                Text(description).bold().foregroundColor(.secondary)
                Spacer()
                Button(action: {detailScreenModal.toggle()}, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                })
            }.padding(.top)
            
            Divider()
            
            ScrollView {
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Open").foregroundColor(.secondary)
                                Spacer()
                                Text(String(open)).bold()
                            }
                            HStack {
                                Text("High").foregroundColor(.secondary)
                                Spacer()
                                Text(String(high)).bold()
                            }
                            HStack {
                                Text("Low").foregroundColor(.secondary)
                                Spacer()
                                Text(String(low)).bold()
                            }
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Current").foregroundColor(.secondary)
                                Spacer()
                                Text(String(current)).bold()
                            }
                            HStack {
                                Text("Previous close").foregroundColor(.secondary)
                                Spacer()
                                Text(String(prevClose)).bold()
                            }
                            HStack {
                                Text("Change").foregroundColor(.secondary)
                                Spacer()
                                Text(String(change)).bold()
                            }
                        }
                    }
                }
                Divider()
                
                // News
                
                ForEach(viewModel.marketNews, id: \.id) { news in
                    VStack(alignment: .leading) {
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
            viewModel.fetchNews(type: "company", ticker: symbol)
        }
        
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(detailScreenModal: Binding.constant(true), open: 0.0, high: 0.0, low: 0.0, current: 0.0, prevClose: 0.0, change: "--", symbol: "", description: "").environmentObject(ViewModel())
    }
}
