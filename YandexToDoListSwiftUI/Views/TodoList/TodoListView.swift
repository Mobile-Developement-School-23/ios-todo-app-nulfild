//
//  TodoListView.swift
//  YandexToDoListSwiftUI
//
//  Created by Герман Кунин on 22.07.2023.
//

import SwiftUI


@MainActor
let navBarAppearence = UINavigationBarAppearance()

@MainActor
struct TodoListView: View {
    @State private var isShowingCompeted = false
    @State var showInfoModalView: Bool = false
    
    //    init() {
    //        navBarAppearence.configureWithOpaqueBackground()
    //        navBarAppearence.backgroundColor = UIColor(Color.backPrimary ?? Color(uiColor: UIColor()))
    //        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.black]
    //        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    //
    //        UINavigationBar.appearance().standardAppearance = navBarAppearence
    //        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
    //    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section {
                        ForEach(todoItems, id: \.id) { todoItem in
                            if isShowingCompeted || !todoItem.isCompleted {
                                TodoListCellView(todoItem: todoItem, isCompleted: todoItem.isCompleted)
                            }
                        }
                    } header: {
                        header
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle(" ᅠ   Мои дела")
                .background(Color.backPrimary)
                
                VStack {
                    Spacer()
                    Button {
                        showInfoModalView = true
                    } label: {
                        Image("creatureButton")
                    }
                }
            }
            .padding(.top, -10)
        }
    }
    
    private var header: some View {
        HStack {
            Text("Выполнено — \(todoItems.filter { $0.isCompleted }.count)")
                .font(.subheadline)
            Spacer()
            Button {
                isShowingCompeted.toggle()
            } label: {
                isShowingCompeted ? Text("Скрыть") : Text("Показать")
            }
            .bold()
        }
        .textCase(.none)
        .padding(.bottom, 5)
        .padding(.leading, -1.5)
    }
    
    private var todoItems: [TodoItem] = [
        TodoItem(
            text: "Hello",
            importance: .low
        ),
        TodoItem(
            text: "Demo 20 July",
            importance: .normal,
            isCompleted: true
        ),
        TodoItem(
            text: "One two three",
            importance: .normal
        ),
        TodoItem(
            text: "Первая строка \nВторая безумно длиииииннннннннннннная строка конец :)",
            importance: .normal
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .important,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
        TodoItem(
            text: "Здесь могла быть ваша реклама",
            importance: .normal,
            deadline: Date()
        ),
    ]
    
    
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}


