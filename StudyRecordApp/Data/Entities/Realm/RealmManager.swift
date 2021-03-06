//
//  RealmManager.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/06.
//

import Foundation
import RealmSwift

final class RealmManager {

    private var realm = try! Realm()

    func create<T: Object>(object: T) {
        try! realm.write {
            realm.add(object)
        }
    }

    func update<T: Object>(object: T) {
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }

    func delete<T: Object>(object: T) {
        let identifier = object.value(forKey: .identifier) as! String
        let object = realm.object(ofType: T.self,
                                  forPrimaryKey: identifier) ?? T()
        try! realm.write {
            realm.delete(object)
        }
        setupOrder(type: T.self)
    }

    func deleteAll<T: Object>(type: T.Type) {
        let object = realm.objects(type.self)
        try! realm.write {
            realm.delete(object)
        }
    }

    func readAll<T: Object>(type: T.Type,
                            byKeyPath: String? = .order) -> [T] {
        let objects: Results<T> = {
            if byKeyPath == nil {
                return realm.objects(T.self)
            } else {
                return realm.objects(T.self).sorted(byKeyPath: .order,
                                                    ascending: true)
            }
        }()
        return objects.map { $0 }
    }

    func sort<T: Object>(sourceObject: T,
                         destinationObject: T) {
        let sourceObjectOrder = sourceObject.value(forKey: .order) as! Int
        let destinationObjectOrder = destinationObject.value(forKey: .order) as! Int
        let objects = RealmManager().readAll(type: T.self)
        try! realm.write {
            if sourceObjectOrder < destinationObjectOrder {
                for order in sourceObjectOrder ... destinationObjectOrder {
                    objects[order].setValue(order - 1, forKey: .order)
                }
            } else {
                for order in destinationObjectOrder ... sourceObjectOrder {
                    objects[order].setValue(order + 1, forKey: .order)
                }
            }
            objects[sourceObjectOrder].setValue(destinationObjectOrder, forKey: .order)
        }
    }

    private func setupOrder<T: Object>(type: T.Type) {
        let objects = RealmManager().readAll(type: type)
        objects.enumerated().forEach { index, object in
            try! realm.write {
                object.setValue(index, forKey: .order)
            }
            RealmManager().update(object: object)
        }
    }

    func backup(documentURL: URL) {
        do {
            realm.beginWrite()
            try realm.writeCopy(toFile: documentURL)
            realm.cancelWrite()
        } catch {
            print("DEBUG_PRINT: ", error.localizedDescription)
        }
    }

    func getRealmFileURL() -> URL? {
        guard let fileURL = Realm.Configuration.defaultConfiguration.fileURL else {
            print("DEBUG_PRINT: ",
                  NSError(domain: "Realmのファイルパスが取得できませんでした。",
                          code: -1,
                          userInfo: nil)
            )
            return nil
        }
        return fileURL
    }

    func updateRealm(fileURL: URL) {
        do {
            let configuration = Realm.Configuration(fileURL: fileURL)
            Realm.Configuration.defaultConfiguration = configuration
            let realm = try Realm(configuration: configuration)
            self.realm = realm
        } catch {
            print("DEBUG_PRINT: ", error.localizedDescription)
        }
    }

}

extension RealmManager: Compatible {}

extension Base where T == RealmManager {

    func deleteList<T: Object>(objects: List<T>, at index: Int) {
        let realm = try! Realm()
        try! realm.write {
            objects.remove(at: index)
            objects.enumerated().forEach { index, object in
                object.setValue(index, forKey: .order)
            }
        }
    }

    func sortList<T: Object>(objects: List<T>,
                             sourceObject: T,
                             destinationObject: T) {
        let sourceObjectOrder = sourceObject.value(forKey: .order) as! Int
        let destinationObjectOrder = destinationObject.value(forKey: .order) as! Int
        let realm = try! Realm()
        try! realm.write {
            if sourceObjectOrder < destinationObjectOrder {
                for order in sourceObjectOrder ... destinationObjectOrder {
                    objects[order].setValue(order - 1, forKey: .order)
                }
            } else {
                for order in destinationObjectOrder ... sourceObjectOrder {
                    objects[order].setValue(order + 1, forKey: .order)
                }
            }
            objects[sourceObjectOrder].setValue(destinationObjectOrder, forKey: .order)
            objects.remove(at: sourceObjectOrder)
            objects.insert(sourceObject, at: destinationObjectOrder)
        }
    }

}

private extension String {

    enum Constant: String {
        case order
        case identifier
    }

    static var order: String {
        return Constant.order.rawValue
    }

    static var identifier: String {
        return Constant.identifier.rawValue
    }

}
