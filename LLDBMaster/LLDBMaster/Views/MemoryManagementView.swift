//
//  MemoryManagementView.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

// MARK: - 4-5일차: 메모리 관리 디버깅 뷰
struct MemoryManagementView: View {
    @StateObject private var memoryViewModel = MemoryManagementViewModel()
    @State private var showLeakyView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("메모리 관리 디버깅")
                        .font(.title)
                    
                    // 강한 참조 사이클 테스트
                    StrongReferenceCycleSection(viewModel: memoryViewModel)
                    
                    // 클로저 캡처 테스트
                    ClosureCaptureSection(viewModel: memoryViewModel)
                    
                    // 이미지 메모리 관리
                    ImageMemorySection(viewModel: memoryViewModel)
                    
                    // 메모리 누수 시뮬레이션
                    MemoryLeakSection(showLeakyView: $showLeakyView)
                }
                .padding()
            }
            .navigationTitle("Memory Debug")
            .sheet(isPresented: $showLeakyView) {
                LeakyView()
            }
        }
    }
}

struct StrongReferenceCycleSection: View {
    @ObservedObject var viewModel: MemoryManagementViewModel
    
    var body: some View {
        VStack {
            Text("강한 참조 사이클 테스트")
                .font(.headline)
            
            Text("생성된 객체 수: \(viewModel.createdObjectsCount)")
            Text("해제된 객체 수: \(viewModel.deallocatedObjectsCount)")
            
            HStack {
                Button("순환 참조 객체 생성") {
                    viewModel.createCircularReference()
                }
                .buttonStyle(.borderedProminent)
                
                Button("정상 객체 생성") {
                    viewModel.createNormalObject()
                }
                .buttonStyle(.bordered)
            }
            
            Button("강제 메모리 정리") {
                viewModel.forceCleanup()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ClosureCaptureSection: View {
    @ObservedObject var viewModel: MemoryManagementViewModel
    
    var body: some View {
        VStack {
            Text("클로저 캡처 테스트")
                .font(.headline)
            
            Text("활성 클로저 수: \(viewModel.activeClosuresCount)")
            
            HStack {
                Button("Strong 캡처") {
                    viewModel.createStrongClosure()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Weak 캡처") {
                    viewModel.createWeakClosure()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ImageMemorySection: View {
    @ObservedObject var viewModel: MemoryManagementViewModel
    
    var body: some View {
        VStack {
            Text("이미지 메모리 관리")
                .font(.headline)
            
            Text("로드된 이미지 수: \(viewModel.loadedImagesCount)")
            
            HStack {
                Button("대용량 이미지 로드") {
                    viewModel.loadLargeImage()
                }
                .buttonStyle(.borderedProminent)
                
                Button("이미지 캐시 정리") {
                    viewModel.clearImageCache()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
}

struct MemoryLeakSection: View {
    @Binding var showLeakyView: Bool
    
    var body: some View {
        VStack {
            Text("메모리 누수 시뮬레이션")
                .font(.headline)
            
            Button("누수 가능성 있는 뷰 열기") {
                showLeakyView = true
            }
            .buttonStyle(.borderedProminent)
            
            Text("이 뷰를 여러 번 열고 닫으면서\nInstruments로 메모리 사용량을 관찰하세요")
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(10)
    }
}

// 메모리 누수를 시뮬레이션하는 뷰
struct LeakyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var leakyObject = LeakyObject()
    
    var body: some View {
        VStack {
            Text("Leaky View")
                .font(.title)
            
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            leakyObject.startLeakyOperation()
        }
    }
}
