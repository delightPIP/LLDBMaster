//
//  User.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftData
import Foundation

@Model
class User {
    var name: String
    var email: String
    var createdAt: Date
    
    // 관계형 데이터 - Task와의 관계
    @Relationship
    var assignedTasks: [TodoTask] = []
    
    init(name: String, email: String, createdAt: Date) {
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }
}
