//
//  SimpleDebugTestView.swift
//  LLDBMaster
//
//  Created by taeni on 8/20/25.
//

import SwiftUI

// MARK: - 디버깅용 간단 테스트 뷰
struct SimpleDebugTestView: View {
    @State private var status = "준비"
    @State private var savedImages: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("ImageFileManager 디버깅")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("상태: \(status)")
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(spacing: 16) {
                    Button("단일 이미지 저장 테스트") {
                        testSaveSingleImage()
                    }
                    .buttonStyle(DebugButtonStyle(color: .blue))
                    
                    Button("여러 이미지 저장 테스트") {
                        testSaveMultipleImages()
                    }
                    .buttonStyle(DebugButtonStyle(color: .green))
                    
                    Button("이미지 로드 테스트") {
                        testLoadImage()
                    }
                    .buttonStyle(DebugButtonStyle(color: .orange))
                    
                    Button("이미지 삭제 테스트") {
                        testDeleteImage()
                    }
                    .buttonStyle(DebugButtonStyle(color: .red))
                    
                    Button("캐시 테스트") {
                        testCachePerformance()
                    }
                    .buttonStyle(DebugButtonStyle(color: .purple))
                }
                
                if !savedImages.isEmpty {
                    VStack(alignment: .leading) {
                        Text("저장된 이미지들:")
                            .font(.headline)
                        
                        ScrollView {
                            ForEach(savedImages, id: \.self) { imageName in
                                Text("📁 \(imageName)")
                                    .font(.caption)
                                    .monospaced()
                            }
                        }
                        .frame(maxHeight: 150)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Debug Test")
        }
    }
    
    // b SimpleDebugTestView.testSaveSingleImage
    private func testSaveSingleImage() {
        print("🔍 단일 이미지 저장 테스트 시작")
        status = "단일 이미지 저장 중..."
        
        Task {
            do {
                // ImageFileManager.saveImage 호출
                let testImage = createDebugImage(text: "Test Image", color: .blue)
                let fileName = try await ImageFileManager.shared.saveImage(testImage, fileName: "debug_single.jpg")
                
                await MainActor.run {
                    status = "단일 이미지 저장 성공: \(fileName)"
                    savedImages.append(fileName)
                }
                
            } catch {
                await MainActor.run {
                    status = "단일 이미지 저장 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // b SimpleDebugTestView.testSaveMultipleImages
    private func testSaveMultipleImages() {
        print("🔍 여러 이미지 저장 테스트 시작")
        status = "여러 이미지 저장 중..."
        
        Task {
            do {
                for i in 1...3 {
                    // ImageFileManager.saveImage 여러 번 호출
                    let testImage = createDebugImage(text: "Image \(i)", color: [.red, .green, .blue][i-1])
                    let fileName = try await ImageFileManager.shared.saveImage(testImage, fileName: "debug_multi_\(i).jpg")
                    
                    await MainActor.run {
                        savedImages.append(fileName)
                    }
                }
                
                await MainActor.run {
                    status = "여러 이미지 저장 완료 (3개)"
                }
                
            } catch {
                await MainActor.run {
                    status = "여러 이미지 저장 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // b SimpleDebugTestView.testLoadImage
    private func testLoadImage() {
        print("🔍 이미지 로드 테스트 시작")
        status = "이미지 로드 중..."
        
        Task {
            // ImageFileManager.loadImage 호출
            if let fileName = savedImages.first {
                let image = await ImageFileManager.shared.loadImage(fileName: fileName)
                
                await MainActor.run {
                    if image != nil {
                        status = "이미지 로드 성공: \(fileName)"
                    } else {
                        status = "이미지 로드 실패: \(fileName)"
                    }
                }
            } else {
                await MainActor.run {
                    status = "로드할 이미지가 없습니다"
                }
            }
        }
    }
    
    // b SimpleDebugTestView.testDeleteImage
    private func testDeleteImage() {
        print("🔍 이미지 삭제 테스트 시작")
        status = "이미지 삭제 중..."
        
        Task {
            do {
                if let fileName = savedImages.first {
                    // ImageFileManager.deleteFile 호출
                    try await ImageFileManager.shared.deleteFile(fileName: fileName)
                    
                    await MainActor.run {
                        status = "이미지 삭제 성공: \(fileName)"
                        savedImages.removeFirst()
                    }
                } else {
                    await MainActor.run {
                        status = "삭제할 이미지가 없습니다"
                    }
                }
            } catch {
                await MainActor.run {
                    status = "이미지 삭제 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // b SimpleDebugTestView.testCachePerformance
    private func testCachePerformance() {
        print("🔍 캐시 성능 테스트 시작")
        status = "캐시 성능 테스트 중..."
        
        Task {
            if let fileName = savedImages.first {
                // 캐시 클리어
                ImageFileManager.shared.clearCache()
                
                let startTime = Date()
                
                // 첫 번째 로드 (캐시 미스)
                let _ = await ImageFileManager.shared.loadImage(fileName: fileName)
                let firstLoadTime = Date().timeIntervalSince(startTime)
                
                let secondStartTime = Date()
                
                // 두 번째 로드 (캐시 히트)
                let _ = await ImageFileManager.shared.loadImage(fileName: fileName)
                let secondLoadTime = Date().timeIntervalSince(secondStartTime)
                
                await MainActor.run {
                    let improvement = firstLoadTime / secondLoadTime
                    status = "캐시 테스트 완료 - 성능 향상: \(String(format: "%.1f", improvement))배"
                }
            } else {
                await MainActor.run {
                    status = "테스트할 이미지가 없습니다"
                }
            }
        }
    }
    
    // 디버깅용 이미지 생성
    private func createDebugImage(text: String, color: UIColor) -> UIImage {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // 배경색
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // 테두리
            UIColor.black.setStroke()
            context.stroke(CGRect(origin: .zero, size: size))
            
            // 텍스트
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
            
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}

// 버튼 스타일
struct DebugButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/*

기본 함수 디버깅:
1. (lldb) b ImageFileManager.saveImage
   → "단일 이미지 저장 테스트" 또는 "여러 이미지 저장 테스트" 버튼 탭

2. (lldb) b ImageFileManager.loadImage  
   → "이미지 로드 테스트" 버튼 탭

3. (lldb) b ImageFileManager.deleteFile
   → "이미지 삭제 테스트" 버튼 탭

테스트 함수 디버깅:
1. (lldb) b SimpleDebugTestView.testSaveSingleImage
   → 함수 호출 과정 확인

2. (lldb) b SimpleDebugTestView.testCachePerformance
   → 성능 측정 과정 확인

사용법:
1. 앱에 이 뷰 추가
2. 브레이크포인트 설정
3. 버튼 탭
4. 디버깅 시작! 

팁:
- 먼저 "단일 이미지 저장 테스트"로 이미지 생성
- 그 다음 "이미지 로드 테스트"로 로드 확인  
- "캐시 테스트"로 성능 차이 확인
- "이미지 삭제 테스트"로 정리
*/
