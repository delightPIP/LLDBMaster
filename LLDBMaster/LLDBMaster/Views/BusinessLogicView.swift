//
//  BusinessLogicView.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

// MARK: - 3일차: 비즈니스 로직 디버깅 뷰
struct BusinessLogicView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var networkViewModel = NetworkViewModel()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Text("비즈니스 로직 디버깅")
                    .font(.title)
                
                // ViewModel ↔ View 데이터 흐름
                UserDataSection(viewModel: userViewModel)
                
                // 비동기 작업 디버깅
                NetworkSection(viewModel: networkViewModel)
                
                // 네비게이션 플로우 디버깅
                NavigationSection(navigationPath: $navigationPath)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Business Logic")
            .navigationDestination(for: String.self) { destination in
                DetailView(destination: destination, navigationPath: $navigationPath)
            }
        }
    }
}

struct UserDataSection: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("User Data Flow")
                .font(.headline)
            
            if let user = viewModel.currentUser {
                VStack(alignment: .leading) {
                    Text("이름: \(user.name)")
                    Text("이메일: \(user.email)")
                    Text("상태: \(viewModel.userStatus)")
                }
            } else {
                Text("사용자 정보 없음")
            }
            
            HStack {
                Button("사용자 로드") {
                    viewModel.loadUser()
                }
                .buttonStyle(.borderedProminent)
                
                Button("사용자 업데이트") {
                    viewModel.updateUser()
                }
                .buttonStyle(.bordered)
                
                Button("상태 변경") {
                    viewModel.changeUserStatus()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

struct NetworkSection: View {
    @ObservedObject var viewModel: NetworkViewModel
    
    var body: some View {
        VStack {
            Text("네트워크 & 비동기 작업")
                .font(.headline)
            
            Text("상태: \(viewModel.status)")
            
            if let data = viewModel.fetchedData {
                Text("데이터: \(data)")
                    .font(.caption)
            }
            
            HStack {
                Button("데이터 가져오기") {
                    Task {
                        await viewModel.fetchData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)
                
                Button("취소") {
                    viewModel.cancelRequest()
                }
                .buttonStyle(.bordered)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
}

struct NavigationSection: View {
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Text("네비게이션 플로우")
                .font(.headline)
            
            HStack {
                Button("Detail A") {
                    navigationPath.append("DetailA")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Detail B") {
                    navigationPath.append("DetailB")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Detail C") {
                    navigationPath.append("DetailC")
                }
                .buttonStyle(.borderedProminent)
            }
            
            Button("루트로 돌아가기") {
                navigationPath.removeLast(navigationPath.count)
            }
            .buttonStyle(.bordered)
            .disabled(navigationPath.count == 0)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

struct DetailView: View {
    let destination: String
    @Binding var navigationPath: NavigationPath
    @StateObject private var detailViewModel = DetailViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail: \(destination)")
                .font(.title)
            
            Text("현재 경로 깊이: \(navigationPath.count)")
            
            Text("ViewModel 상태: \(detailViewModel.status)")
            
            Button("더 깊이 이동") {
                navigationPath.append("\(destination)-Sub")
            }
            .buttonStyle(.borderedProminent)
            
            Button("뒤로 가기") {
                navigationPath.removeLast()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle(destination)
        .onAppear {
            detailViewModel.loadData(for: destination)
        }
    }
}
