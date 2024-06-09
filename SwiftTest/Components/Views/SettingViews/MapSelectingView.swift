//
//  LocationManager.swift
//  SwiftTest
//
//  Created by yuta on 2024/06/07.
//

import SwiftUI
import MapKit

struct MapSelectingView: View {
    /// ViewModel
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack {
            HStack {
                // 場所入力欄
                TextField("", text: $viewModel.location)
                    .padding(5)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primary.opacity(0.6), lineWidth: 0.3))
                    .onChange(of: viewModel.location) { newValue in
                        viewModel.onSearchLocation()
                    }
                
                // 検索ボタン
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .onTapGesture {
                        viewModel.onSearch()
                    }
            }
            
            if viewModel.completions.count > 0 {
                // 検索候補
                List(viewModel.completions , id: \.self) { completion in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(completion.title)
                            Text(completion.subtitle)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        viewModel.onLocationTap(completion)
                    }
                    .foregroundColor(.blue)
                }
                .scrollContentBackground(.hidden)
            } else if viewModel.location != "" {
                HStack {
                    // 場所の詳細情報
                    //                    Text(String(viewModel.longitude))
                    //                    Spacer()
                    //                    Text(String(viewModel.latitude))
                    List{
                            HStack {
                                Label(viewModel.location, systemImage: "pin")
                                    .font(.headline)
                                    .foregroundColor(.accentColor)
                                
                                Spacer()
                                
                                }
                                .contentShape(Rectangle())
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .scrollContentBackground(.hidden)
                }
            }
            Spacer()
        }
        .padding()
    }
}
//
//#Preview {
//    MapView()
//}
