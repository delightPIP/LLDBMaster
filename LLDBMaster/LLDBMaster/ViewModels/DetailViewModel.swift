//
//  DetailViewModel.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI
import Foundation

class DetailViewModel: ObservableObject {
    @Published var status = "초기화"
    @Published var data: [String] = []
    
    func loadData(for destination: String) {
        print("Loading data for destination: \(destination)") // breakpoint 설정
        status = "로딩중"
        
        // 시뮬레이션된 데이터 로딩
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.data = [
                "\(destination) 데이터 1",
                "\(destination) 데이터 2",
                "\(destination) 데이터 3"
            ]
            self.status = "로드됨 (\(self.data.count)개 항목)"
            print("Data loaded for \(destination): \(self.data.count) items") // breakpoint 설정
        }
    }
}
