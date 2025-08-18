//
//  BasicDebuggingView.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI

// MARK: - 1일차: 기본 LLDB 디버깅 뷰
struct BasicDebuggingView: View {
    @State private var counter = 0
    @State private var numbers: [Int] = []
    @State private var userName = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("LLDB 기본 디버깅 실습")
                    .font(.title)
                    .padding()
                
                // 간단한 카운터 (breakpoint 설정용)
                VStack {
                    Text("Counter: \(counter)")
                        .font(.headline)
                    
                    HStack {
                        Button("증가") {
                            incrementCounter() // 여기에 breakpoint 설정
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("감소") {
                            decrementCounter() // 여기에 breakpoint 설정
                        }
                        .buttonStyle(.bordered)
                        
                        Button("리셋") {
                            resetCounter() // 여기에 breakpoint 설정
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // 배열 조작 (LLDB에서 배열 내용 확인용)
                VStack {
                    Text("Numbers: \(numbers.map(String.init).joined(separator: ", "))")
                    
                    Button("랜덤 숫자 추가") {
                        addRandomNumber() // 여기에 breakpoint 설정
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("배열 클리어") {
                        clearNumbers() // 여기에 breakpoint 설정
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // 문자열 조작
                VStack {
                    TextField("이름을 입력하세요", text: $userName)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("처리하기") {
                        processUserName() // 여기에 breakpoint 설정
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Basic LLDB")
        }
    }
    
    // MARK: - LLDB 실습용 메서드들
    private func incrementCounter() {
        counter += 1 // po counter, expr counter = 10 등 실습
        print("Counter incremented to: \(counter)")
    }
    
    private func decrementCounter() {
        counter -= 1 // po counter, expr counter = 0 등 실습
        print("Counter decremented to: \(counter)")
    }
    
    private func resetCounter() {
        counter = 0 // po counter 실습
        print("Counter reset")
    }
    
    private func addRandomNumber() {
        let randomNumber = Int.random(in: 1...100)
        numbers.append(randomNumber) // po numbers, expr numbers.append(999) 등 실습
        print("Added number: \(randomNumber)")
    }
    
    private func clearNumbers() {
        numbers.removeAll() // po numbers.count 실습
        print("Numbers cleared")
    }
    
    private func processUserName() {
        print("Processing user name: \(userName)") // po userName, expr userName = "LLDB Master" 등 실습
        // 의도적으로 복잡한 로직 추가 (스텝 오버/인투 실습용)
        let processedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        let capitalizedName = processedName.capitalized
        print("Processed name: \(capitalizedName)")
    }
}
