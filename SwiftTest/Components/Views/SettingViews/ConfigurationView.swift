//
//  ConfigurationView.swift
//  SwiftTest
//
//  Created by yuta on 2024/06/09.
//

import SwiftUI

struct ConfigurationView: View {
    
    @Binding var selectionDate: Date
    @ObservedObject var viewModel: MapViewModel
    
    @State private var currentMinimumDate: Date = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
    
    var body : some View {
        
            ZStack {
                // Background Image
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                List {
                    Section {
                        VStack {
                            Label("目標時間", systemImage: "timer")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                        }
                        DatePicker("", selection: $selectionDate, in: currentMinimumDate..., displayedComponents: .hourAndMinute)
                            .frame(width: 500, height: 60)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .onAppear {
                                updateMinimumDate()
                            }
                            .onChange(of: selectionDate) {
                                updateMinimumDate()
                            }
                    }
                        Section{
                            VStack {
                                Label("目的地", systemImage: "map")
                                    .font(.headline)
                                    .foregroundColor(.accentColor)
                            }
                            MapSelectingView(viewModel: viewModel)
                                .frame(height:400)
                        }
                        
                        
                        
                    }
                    .scrollContentBackground(.hidden)
                    //.background(Color.clear)
                    .padding(EdgeInsets(
                        top: 0,        // 上の余白
                        leading: 10,    // 左の余白
                        bottom: 0,     // 下の余白
                        trailing: 10    // 右の余白
                    ))
                }
                
            }
            
        
        
    private func updateMinimumDate() {
        print("update")
           currentMinimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
       }
}
