//
//  UserViewModel.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI
import Foundation

// MARK: - Business Logic ViewModels
class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var userStatus: String = "초기상태"
    @Published var isLoading = false
    
    struct User {
        let id: UUID
        let name: String
        let email: String
    }
    
    func loadUser() {
        print("Loading user...") // breakpoint 설정
        isLoading = true
        
        // 시뮬레이션된 로딩
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = User(
                id: UUID(),
                name: "홍길동",
                email: "hong@example.com"
            )
            self.userStatus = "로드됨"
            self.isLoading = false
            print("User loaded: \(self.currentUser?.name ?? "nil")") // breakpoint 설정
        }
    }
    
    func updateUser() {
        guard var user = currentUser else { return }
        print("Updating user: \(user.name)") // breakpoint 설정
        
        // 사용자 정보 업데이트 로직
        let updatedUser = User(
            id: user.id,
            name: "\(user.name) (수정됨)",
            email: user.email
        )
        currentUser = updatedUser
        userStatus = "업데이트됨"
        print("User updated: \(updatedUser.name)") // breakpoint 설정
    }
    
    func changeUserStatus() {
        let statuses = ["활성", "비활성", "대기중", "차단됨"]
        userStatus = statuses.randomElement() ?? "알 수 없음"
        print("User status changed to: \(userStatus)") // breakpoint 설정
    }
}
