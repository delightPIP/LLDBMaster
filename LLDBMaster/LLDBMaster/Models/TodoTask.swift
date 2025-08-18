//
//  TodoTask.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//


import SwiftData
import Foundation

@Model
class TodoTask {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    
    // 관계형 데이터 - User와의 관계
    @Relationship(inverse: \User.assignedTasks)
    var assignedUser: User?
    
    init(title: String, isCompleted: Bool, createdAt: Date, updatedAt: Date) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}