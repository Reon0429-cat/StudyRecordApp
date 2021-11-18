//
//  GoalRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation

protocol GoalRepositoryProtocol {
    func create(category: Category)
    func read(at index: Int) -> Category
    func readAll() -> [Category]
    func update(category: Category)
    func delete(category: Category)
    func deleteAllCategory()
    func deleteGoal(indexPath: IndexPath)
    func sortCategory(from sourceIndexPath: IndexPath,
                      to destinationIndexPath: IndexPath)
    func sortGoal(from sourceIndexPath: IndexPath,
                  to destinationIndexPath: IndexPath)
}
