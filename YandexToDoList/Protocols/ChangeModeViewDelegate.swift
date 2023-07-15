//
//  ChangeModeViewDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.07.2023.
//

import Foundation

protocol ChangeModeViewDelegate: AnyObject {
    @MainActor
    func sqlButtonDidTapped()
    @MainActor
    func coreDataButtonDidTapped()
}
