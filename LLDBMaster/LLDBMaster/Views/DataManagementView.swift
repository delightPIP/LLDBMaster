//
//  DataManagementView.swift
//  LLDBMaster
//
//  Created by taeni on 8/18/25.
//

import SwiftUI
import SwiftData

// MARK: - 6일차: 데이터 관리 디버깅 뷰
struct DataManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TodoTask]
    @Query private var users: [User]
    @State private var showAddTaskSheet = false
    @State private var showAddUserSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Break point, View 로드 시 데이터 상태 확인
                // (lldb) po tasks.count
                // (lldb) po users.count
                Text("SwiftData 디버깅")
                    .font(.title)
                    .padding()
                
                TasksSection(
                    tasks: tasks,
                    modelContext: modelContext,
                    showAddTaskSheet: $showAddTaskSheet
                )
                
                UsersSection(
                    users: users,
                    modelContext: modelContext,
                    showAddUserSheet: $showAddUserSheet
                )
                
                RelationshipSection(tasks: tasks, users: users, modelContext: modelContext)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Data Debug")
            .sheet(isPresented: $showAddTaskSheet) {
                AddTaskView(users: users)
            }
            .sheet(isPresented: $showAddUserSheet) {
                AddUserView()
            }
        }
    }
}

struct TasksSection: View {
    let tasks: [TodoTask]
    let modelContext: ModelContext
    @Binding var showAddTaskSheet: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Tasks (\(tasks.count))")
                    .font(.headline)
                
                Spacer()
                
                Button("추가") {
                    showAddTaskSheet = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            if tasks.isEmpty {
                Text("작업이 없습니다")
                    .foregroundColor(.gray)
            } else {
                LazyVStack {
                    ForEach(tasks) { task in
                        TaskRowView(task: task, modelContext: modelContext)
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

struct TaskRowView: View {
    let task: TodoTask
    let modelContext: ModelContext
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                Text("생성일: \(task.createdAt, formatter: dateFormatter)")
                    .font(.caption)
                if let assignee = task.assignedUser {
                    Text("담당자: \(assignee.name)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button(task.isCompleted ? "완료됨" : "진행중") {
                toggleTaskCompletion(task)
            }
            .buttonStyle(.bordered)
            .foregroundColor(task.isCompleted ? .green : .orange)
            
            Button("삭제") {
                deleteTask(task)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
        .padding(.vertical, 4)
    }
    
    private func toggleTaskCompletion(_ task: TodoTask) {
        print("Toggling task completion: \(task.title)") // breakpoint 설정
        task.isCompleted.toggle()
        task.updatedAt = Date()
        
        do {
            try modelContext.save()
            print("Task updated successfully") // breakpoint 설정
        } catch {
            print("Failed to update task: \(error)") // breakpoint 설정
        }
    }
    
    private func deleteTask(_ task: TodoTask) {
        print("Deleting task: \(task.title)") // breakpoint 설정
        modelContext.delete(task)
        
        do {
            try modelContext.save()
            print("Task deleted successfully") // breakpoint 설정
        } catch {
            print("Failed to delete task: \(error)") // breakpoint 설정
        }
    }
}

struct UsersSection: View {
    let users: [User]
    let modelContext: ModelContext
    @Binding var showAddUserSheet: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Users (\(users.count))")
                    .font(.headline)
                
                Spacer()
                
                Button("추가") {
                    showAddUserSheet = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            if users.isEmpty {
                Text("사용자가 없습니다")
                    .foregroundColor(.gray)
            } else {
                LazyVStack {
                    ForEach(users) { user in
                        UserRowView(user: user, modelContext: modelContext)
                    }
                }
                .frame(maxHeight: 150)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
}

struct UserRowView: View {
    let user: User
    let modelContext: ModelContext
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.caption)
                Text("작업 수: \(user.assignedTasks.count)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button("삭제") {
                deleteUser(user)
            }
            .buttonStyle(.bordered)
            .foregroundColor(.red)
        }
        .padding(.vertical, 4)
    }
    
    private func deleteUser(_ user: User) {
        print("Deleting user: \(user.name)") // breakpoint 설정
        
        // 사용자와 연결된 작업들의 관계 해제
        for task in user.assignedTasks {
            task.assignedUser = nil
        }
        
        modelContext.delete(user)
        
        do {
            try modelContext.save()
            print("User deleted successfully") // breakpoint 설정
        } catch {
            print("Failed to delete user: \(error)") // breakpoint 설정
        }
    }
}

struct RelationshipSection: View {
    let tasks: [TodoTask]
    let users: [User]
    let modelContext: ModelContext
    
    var body: some View {
        VStack {
            Text("관계형 데이터 디버깅")
                .font(.headline)
            
            HStack {
                Button("랜덤 할당") {
                    assignRandomTasks()
                }
                .buttonStyle(.borderedProminent)
                
                Button("모든 할당 해제") {
                    unassignAllTasks()
                }
                .buttonStyle(.bordered)
            }
            
            // 통계 표시
            VStack(alignment: .leading, spacing: 4) {
                Text("할당된 작업: \(tasks.filter { $0.assignedUser != nil }.count)")
                Text("미할당 작업: \(tasks.filter { $0.assignedUser == nil }.count)")
                Text("완료된 작업: \(tasks.filter { $0.isCompleted }.count)")
            }
            .font(.caption)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func assignRandomTasks() {
        print("Assigning random tasks") // breakpoint 설정
        
        let unassignedTasks = tasks.filter { $0.assignedUser == nil }
        
        for task in unassignedTasks {
            if let randomUser = users.randomElement() {
                print("Assigning task '\(task.title)' to user '\(randomUser.name)'") // breakpoint 설정
                task.assignedUser = randomUser
                task.updatedAt = Date()
            }
        }
        
        do {
            try modelContext.save()
            print("Random assignment completed") // breakpoint 설정
        } catch {
            print("Failed to assign tasks: \(error)") // breakpoint 설정
        }
    }
    
    private func unassignAllTasks() {
        print("Unassigning all tasks") // breakpoint 설정
        
        for task in tasks {
            if task.assignedUser != nil {
                print("Unassigning task: \(task.title)") // breakpoint 설정
                task.assignedUser = nil
                task.updatedAt = Date()
            }
        }
        
        do {
            try modelContext.save()
            print("All tasks unassigned") // breakpoint 설정
        } catch {
            print("Failed to unassign tasks: \(error)") // breakpoint 설정
        }
    }
}

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let users: [User]
    
    @State private var title = ""
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("작업 제목", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Picker("담당자", selection: $selectedUser) {
                    Text("미할당").tag(nil as User?)
                    ForEach(users) { user in
                        Text(user.name).tag(user as User?)
                    }
                }
                .pickerStyle(.menu)
                
                Spacer()
            }
            .padding()
            .navigationTitle("새 작업")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        addTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        print("Adding new task: \(title)") // breakpoint 설정
        
        let newTask = TodoTask(
            title: title,
            isCompleted: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        newTask.assignedUser = selectedUser
        
        modelContext.insert(newTask)
        
        do {
            try modelContext.save()
            print("Task added successfully: \(newTask.title)") // breakpoint 설정
            dismiss()
        } catch {
            print("Failed to add task: \(error)") // breakpoint 설정
        }
    }
}

struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("이름", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("이메일", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                
                Spacer()
            }
            .padding()
            .navigationTitle("새 사용자")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        addUser()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }
    
    private func addUser() {
        print("Adding new user: \(name)") // breakpoint 설정
        
        let newUser = User(
            name: name,
            email: email,
            createdAt: Date()
        )
        
        modelContext.insert(newUser)
        
        do {
            try modelContext.save()
            print("User added successfully: \(newUser.name)") // breakpoint 설정
            dismiss()
        } catch {
            print("Failed to add user: \(error)") // breakpoint 설정
        }
    }
}

// MARK: - Utilities
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
