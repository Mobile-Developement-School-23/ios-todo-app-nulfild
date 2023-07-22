//
//  TodoListCellView.swift
//  YandexToDoListSwiftUI
//
//  Created by Герман Кунин on 22.07.2023.
//

import SwiftUI

struct TodoListCellView: View {
    @State var todoItem: TodoItem
    @State var isCompleted = false
    
    var body: some View {
        HStack {
            Button {
                isCompleted.toggle()
                todoItem = TodoItem(
                    id: todoItem.id,
                    text: todoItem.text,
                    importance: todoItem.importance,
                    deadline: todoItem.deadline,
                    isCompleted: isCompleted,
                    createDate: todoItem.createDate,
                    editDate: todoItem.editDate
                )
            } label: {
                if isCompleted {
                    Image("doneButtonOn")
                } else {
                    if todoItem.importance == .important {
                        Image("doneButtonImportant")
                    } else {
                        Image("doneButton")
                    }
                }
            }
            .padding(.trailing, 7)
            .padding(.leading, -3)
            
            HStack(alignment: .center, spacing: 6) {
                Text("")
                if todoItem.importance != .normal {
                    Image("\(todoItem.importance)")
                        .frame(width: 10, height: 16)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(todoItem.text)
                        .lineLimit(3)
                        .font(.subhead)
                    
                    if let deadline = todoItem.deadline {
                        HStack(spacing: 2) {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.gray)
                            
                            Text(deadline.toStringWithoutYear)
                                .font(.footnote)
                                .foregroundColor(.labelTertiary)
                        }
                    }
                }
            }
            .padding(.leading, -5)
            Spacer()
            Image("arrow")
        }
        .padding(.top, 7)
        .padding(.bottom, 7)
    }
}

struct TodoListCellView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListCellView(todoItem: TodoItem(
            text: "test",
            importance: .important
        ))
    }
}
