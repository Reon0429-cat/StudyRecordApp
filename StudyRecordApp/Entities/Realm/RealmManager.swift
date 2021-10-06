//
//  RealmManager.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/06.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    private static let realm = try! Realm()
    
    static func create<T: Object>(object: T) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func update<T: Object>(object: T) {
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    static func delete<T: Object>(object: T, identifier: String) {
        let object = realm.object(ofType: T.self,
                                  forPrimaryKey: identifier) ?? T()
        try! realm.write {
            realm.delete(object)
        }
    }
    
    static func readAll<T: Object>(type: T.Type) -> [T] {
        let objects = realm.objects(T.self).sorted(byKeyPath: .order,
                                                   ascending: true)
        return objects.map { $0 }
    }
    
    static func setupOrder<T: Object>(type: T.Type) {
        let objects = RealmManager.readAll(type: type)
        objects.enumerated().forEach { index, object in
            try! realm.write {
                object.setValue(index, forKey: .order)
            }
            RealmManager.update(object: object)
        }
    }
    
    static func sort<T: Object>(sourceObject: T,
                                destinationObject: T) {
        let sourceObjectOrder = sourceObject.value(forKey: .order) as! Int
        let destinationObjectOrder = destinationObject.value(forKey: .order) as! Int
        let objects = RealmManager.readAll(type: T.self)
        try! realm.write {
            if sourceObjectOrder < destinationObjectOrder {
                for order in sourceObjectOrder...destinationObjectOrder {
                    objects[order].setValue(order - 1, forKey: .order)
                }
            } else {
                for order in destinationObjectOrder...sourceObjectOrder {
                    objects[order].setValue(order + 1, forKey: .order)
                }
            }
            objects[sourceObjectOrder].setValue(destinationObjectOrder, forKey: .order)
        }
    }
    
}

private extension String {
    
    static var order: String {
        return "order"
    }
    
}
