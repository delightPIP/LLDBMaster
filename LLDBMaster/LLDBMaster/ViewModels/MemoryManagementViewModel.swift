//
//  MemoryManagementViewModel.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI
import UIKit

// MARK: - Memory Management Classes
class MemoryManagementViewModel: ObservableObject {
    @Published var createdObjectsCount = 0
    @Published var deallocatedObjectsCount = 0
    @Published var activeClosuresCount = 0
    @Published var loadedImagesCount = 0
    
    private var circularObjects: [CircularReferenceA] = []
    private var normalObjects: [NormalObject] = []
    private var closures: [() -> Void] = []
    private var images: [UIImage] = []
    
    func createCircularReference() {
        print("Creating circular reference objects") // breakpoint 설정
        let objA = CircularReferenceA()
        let objB = CircularReferenceB()
        
        objA.referenceB = objB
        objB.referenceA = objA // 순환 참조 생성! 문제가 되는 코드임
        
        circularObjects.append(objA)
        createdObjectsCount += 2
        print("Created circular reference objects: \(createdObjectsCount)") // breakpoint 설정
    }
    
    func createNormalObject() {
        print("Creating normal object") // breakpoint 설정
        let obj = NormalObject()
        normalObjects.append(obj)
        createdObjectsCount += 1
        print("Created normal object: \(createdObjectsCount)") // breakpoint 설정
    }
    
    func forceCleanup() {
        print("Forcing cleanup") // breakpoint 설정
        circularObjects.removeAll()
        normalObjects.removeAll()
        // 순환 참조 객체들은 해제되지 않을 것임!
    }
    
    func createStrongClosure() {
        print("Creating strong closure") // breakpoint 설정
        let closure = {
            // self를 강하게 캡처
            print("Strong closure executed: \(self.activeClosuresCount)")
        }
        closures.append(closure)
        activeClosuresCount += 1
    }
    
    func createWeakClosure() {
        print("Creating weak closure") // breakpoint 설정
        let closure = { [weak self] in
            // self를 약하게 캡처
            print("Weak closure executed: \(self?.activeClosuresCount ?? -1)")
        }
        closures.append(closure)
        activeClosuresCount += 1
    }
    
    func loadLargeImage() {
        print("Loading large image") // breakpoint 설정
        // 시뮬레이션된 대용량 이미지 생성
        let size = CGSize(width: 1000, height: 1000)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.random.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            images.append(image)
            loadedImagesCount += 1
            print("Loaded image: \(loadedImagesCount)") // breakpoint 설정
        }
    }
    
    func clearImageCache() {
        print("Clearing image cache") // breakpoint 설정
        images.removeAll()
        loadedImagesCount = 0
    }
}

// 순환 참조를 만드는 클래스들
class CircularReferenceA {
    var referenceB: CircularReferenceB?
    let id = UUID()
    
    init() {
        print("CircularReferenceA \(id) created") // breakpoint 설정
    }
    
    deinit {
        print("CircularReferenceA \(id) deallocated") // breakpoint 설정
        // 이 deinit은 호출되지 않을 것임!
    }
}

class CircularReferenceB {
    var referenceA: CircularReferenceA?
    let id = UUID()
    
    init() {
        print("CircularReferenceB \(id) created") // breakpoint 설정
    }
    
    deinit {
        print("CircularReferenceB \(id) deallocated") // breakpoint 설정
        // 이 deinit도 호출되지 않을 것임!
    }
}

class NormalObject {
    let id = UUID()
    
    init() {
        print("NormalObject \(id) created") // breakpoint 설정
    }
    
    deinit {
        print("NormalObject \(id) deallocated") // breakpoint 설정
    }
}

class LeakyObject: ObservableObject {
    private var timer: Timer?
    private var strongReferences: [Any] = []
    
    init() {
        print("LeakyObject created") // breakpoint 설정
    }
    
    func startLeakyOperation() {
        // 메모리 누수를 유발하는 타이머
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // 강한 참조로 self 캡처 (메모리 누수!)
            self.strongReferences.append(Date())
            print("Adding strong reference: \(self.strongReferences.count)")
        }
    }
    
    deinit {
        print("LeakyObject deallocated") // breakpoint 설정
        timer?.invalidate()
        // 이 deinit이 호출되지 않으면 메모리 누수!
    }
}
