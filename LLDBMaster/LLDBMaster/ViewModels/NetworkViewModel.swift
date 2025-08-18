//
//  NetworkViewModel.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI
import Foundation

class NetworkViewModel: ObservableObject {
    @Published var status = "대기중"
    @Published var fetchedData: String?
    @Published var isLoading = false
    
    private var currentTask: Task<Void, Never>? = nil
    
    @MainActor
    func fetchData() async {
        print("Starting network request...") // breakpoint 설정
        status = "요청중"
        isLoading = true
        fetchedData = nil
        
        currentTask = Task {
            do {
                // 시뮬레이션된 네트워크 지연
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2초
                
                if !Task.isCancelled {
                    await MainActor.run {
                        self.fetchedData = "서버에서 가져온 데이터: \(Date().timeIntervalSince1970)"
                        self.status = "성공"
                        self.isLoading = false
                        print("Network request completed successfully") // breakpoint 설정
                    }
                }
            } catch {
                await MainActor.run {
                    self.status = "실패: \(error.localizedDescription)"
                    self.isLoading = false
                    print("Network request failed: \(error)") // breakpoint 설정
                }
            }
        }
    }
    
    func cancelRequest() {
        print("Cancelling network request...") // breakpoint 설정
        currentTask?.cancel()
        currentTask = nil
        status = "취소됨"
        isLoading = false
    }
}

