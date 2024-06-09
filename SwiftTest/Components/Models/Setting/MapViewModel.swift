//
//  MapViewModel.swift
//  SwiftTest
//
//  Created by yuta on 2024/06/09.
//
import SwiftUI
import MapKit

class MapViewModel : NSObject, ObservableObject, MKLocalSearchCompleterDelegate{
    /// 位置情報検索クラス
    var completer = MKLocalSearchCompleter()
    /// 場所
    @Published var location = ""
    /// 検索クエリ
    @Published var searchQuery = ""
    /// 位置情報検索結果
    @Published var completions: [MKLocalSearchCompletion] = []
    /// 場所の詳細情報
    @Published var longitude: Double = 0.0
    @Published var latitude: Double = 0.0
    
    override init(){
        super.init()
        // 検索情報初期化
        completer.delegate = self
        
        // 場所のみ(住所を省く)
        completer.resultTypes = .pointOfInterest
    }
    
    /// 住所変更時
    func onSearchLocation() {
        // マップ表示中の目的地と同じなら何もしない
        if searchQuery == location {
            completions = []
            return
        }
        
        // 検索クエリ設定
        searchQuery = location
        
        // 場所が空の時、候補もクリア
        if searchQuery.isEmpty {
            completions = []
        } else {
            if completer.queryFragment != searchQuery {
                completer.queryFragment = searchQuery
            }
        }
    }
    
    /// 検索結果表示
    /// - Parameter completer: 検索結果の場所一覧
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            if self.searchQuery.isEmpty {
                self.completions = .init()
            } else {
                self.completions = completer.results
            }
        }
    }
    
    /// 場所をタップ
    /// - Parameter completion: タップされた場所
    func onLocationTap(_ completion:MKLocalSearchCompletion){
        DispatchQueue.main.async {
            // 場所を選択
            self.location = completion.title
            self.searchQuery = self.location
            
            // 検索
            self.onSearch()
        }
    }
    
    /// 場所の詳細情報を検索
    func onSearch(){
        // 検索結果クリア
        completions = []
        longitude = 0.0
        latitude = 0.0
        
        // 検索条件設定
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.location
        
        // 検索実行
        MKLocalSearch(request: request).start { (response, error) in
            if let error = error {
                print("MKLocalSearch Error:\(error)")
                return
            }
            if let mapItem = response?.mapItems.first {
                DispatchQueue.main.async {
                    self.longitude = mapItem.placemark.coordinate.longitude
                    self.latitude = mapItem.placemark.coordinate.latitude
                }
            }
        }
    }
}
