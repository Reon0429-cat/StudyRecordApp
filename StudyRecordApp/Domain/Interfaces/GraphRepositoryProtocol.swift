//
//  GraphRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation

protocol GraphRepositoryProtocol {
    func create(graph: Graph)
    func readAll() -> [Graph]
    func update(graph: Graph)
}
