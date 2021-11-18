//
//  RecordRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation

protocol RecordRepositoryProtocol {
    func create(record: Record)
    func read(at index: Int) -> Record
    func readAll() -> [Record]
    func update(record: Record)
    func delete(record: Record)
    func sort(from sourceIndexPath: IndexPath,
              to destinationIndexPath: IndexPath)
}
