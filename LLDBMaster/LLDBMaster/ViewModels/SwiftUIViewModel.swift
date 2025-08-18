//
//  SwiftUIViewModel.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

// MARK: - SwiftUI ViewModel
class SwiftUIViewModel: ObservableObject {
    @Published var publishedValue = "초기 Published 값"
    @Published var counter = 0
    
    func updatePublishedValue() {
        publishedValue = "업데이트됨 \(Date().timeIntervalSince1970)"
        print("Published value updated: \(publishedValue)") // breakpoint 설정
    }
    
    func incrementCounter() {
        counter += 1
        print("Counter incremented: \(counter)") // breakpoint 설정
    }
}
