//
//  AppViewModel.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

// MARK: - App-wide ViewModel
class AppViewModel: ObservableObject {
    @Published var globalState = "앱 전역 상태"
    
    func updateGlobalState() {
        globalState = "업데이트됨 \(Date().timeIntervalSince1970)"
        print("Global state updated: \(globalState)") // breakpoint 설정
    }
}
