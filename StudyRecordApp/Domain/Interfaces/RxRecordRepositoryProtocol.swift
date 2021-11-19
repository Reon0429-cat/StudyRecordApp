//
//  RxRecordRepositoryProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/11/18.
//

import Foundation
import RxSwift

protocol RxRecordRepositoryProtocol {
    func create(record: Record) -> Completable
    func readAll() -> Single<[Record]>
    func read(at index: Int) -> Single<Record>
    func update(record: Record) -> Completable
    func delete(record: Record) -> Completable
    func sort(sourceObject: Record,
              destinationObject: Record) -> Completable
}
