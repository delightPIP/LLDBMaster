//
//  SwiftUIDebuggingView.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

// MARK: - 2일차: SwiftUI 디버깅 뷰
struct SwiftUIDebuggingView: View {
    @StateObject private var viewModel = SwiftUIViewModel()
    @State private var isAnimating = false
    @State private var dragOffset = CGSize.zero
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("SwiftUI 디버깅 실습")
                        .font(.title)
                        .padding()
                    
                    // @State 변수 디버깅
                    StateDebuggingSection(viewModel: viewModel)
                    
                    // 애니메이션 디버깅
                    AnimationDebuggingSection(isAnimating: $isAnimating)
                    
                    // 제스처 디버깅
                    GestureDebuggingSection(dragOffset: $dragOffset)
                    
                    // View 라이프사이클 디버깅
                    LifecycleDebuggingView()
                    
                    Button("Show Sheet") {
                        showSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("SwiftUI Debug")
            .sheet(isPresented: $showSheet) {
                SheetView()
            }
        }
    }
}

struct StateDebuggingSection: View {
    @ObservedObject var viewModel: SwiftUIViewModel
    @State private var localState = "초기값"
    
    var body: some View {
        VStack {
            Text("@State & @Published 디버깅")
                .font(.headline)
            
            Text("Local State: \(localState)")
            Text("Published Value: \(viewModel.publishedValue)")
            Text("Counter: \(viewModel.counter)")
            
            HStack {
                Button("State 변경") {
                    localState = "변경된 값 \(Date().timeIntervalSince1970)"
                }
                
                Button("Published 변경") {
                    viewModel.updatePublishedValue()
                }
                
                Button("Counter 증가") {
                    viewModel.incrementCounter()
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

struct AnimationDebuggingSection: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack {
            Text("애니메이션 디버깅")
                .font(.headline)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .scaleEffect(isAnimating ? 1.5 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.easeInOut(duration: 1.0), value: isAnimating)
            
            Button("애니메이션 토글") {
                isAnimating.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(10)
    }
}

struct GestureDebuggingSection: View {
    @Binding var dragOffset: CGSize
    
    var body: some View {
        VStack {
            Text("제스처 디버깅")
                .font(.headline)
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
                .offset(dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation {
                                dragOffset = .zero
                            }
                        }
                )
            
            Text("Offset: x: \(Int(dragOffset.width)), y: \(Int(dragOffset.height))")
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - View 라이프사이클 디버깅용
struct LifecycleDebuggingView: View {
    @State private var viewId = UUID()
    
    var body: some View {
        VStack {
            Text("View 라이프사이클 디버깅")
                .font(.headline)
            
            LifecycleTrackingView()
                .id(viewId)
            
            Button("View 재생성") {
                viewId = UUID()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
}

struct LifecycleTrackingView: View {
    @State private var internalCounter = 0
    
    var body: some View {
        VStack {
            Text("Internal Counter: \(internalCounter)")
            
            Button("Increment") {
                internalCounter += 1
            }
        }
        .onAppear {
            print("LifecycleTrackingView appeared") // breakpoint 설정
        }
        .onDisappear {
            print("LifecycleTrackingView disappeared") // breakpoint 설정
        }
    }
}

struct SheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sheet View")
                    .font(.title)
                
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Sheet")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            print("Sheet appeared") // breakpoint 설정
        }
    }
}
