//
//  TodoListViewController+Extension.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 08.07.2023.
//

import Foundation

extension TodoListViewController {
    func test() {
        let task = Task {
            let url = "https://vk.ru/"
            
            guard let url = URL(string: url) else { return }
            
            let request = URLRequest(url: url)
            
            do {
                let (data, _) = try await URLSession.shared.dataTask(for: request)
                print(data)
            } catch {
                print("Error")
            }
        }
//        task.cancel()
        // Если включить строчку выше, можно проверить работоспособность отмены таска
    }
}
