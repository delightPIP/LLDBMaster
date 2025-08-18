//
//  ContentView.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 1일차: 기본 LLDB 실습용
            BasicDebuggingView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Basic")
                }
                .tag(0)
            
            // 2일차: SwiftUI 디버깅
            SwiftUIDebuggingView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("SwiftUI")
                }
                .tag(1)
            
            // 3일차: 비즈니스 로직 디버깅
            BusinessLogicView()
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Business")
                }
                .tag(2)
            
            // 4-5일차: 메모리 관리
            MemoryManagementView()
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Memory")
                }
                .tag(3)
            
            // 6일차: 데이터 관리
            DataManagementView()
                .tabItem {
                    Image(systemName: "5.circle")
                    Text("Data")
                }
                .tag(4)
        }
        .environmentObject(appViewModel)
    }
}
