//
//  SortableViewControllerProtocol.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/08.
//

import UIKit

protocol SortableViewControllerProtocol where Self: UIViewController {
    typealias SortableType = UIViewController
        & UITableViewDelegate
        & UITableViewDataSource
        & UITableViewDragDelegate
        & UITableViewDropDelegate
    func _setup<T: SortableType>(tableView: UITableView, vc: T)
    func _tableView(_ tableView: UITableView,
                    heightForRowAt indexPath: IndexPath) -> CGFloat
    func _tableView(_ tableView: UITableView,
                    didSelectRowAt indexPath: IndexPath)
    func _tableView(_ tableView: UITableView,
                    heightForHeaderInSection section: Int) -> CGFloat
    func _tableView(_ tableView: UITableView,
                    viewForHeaderInSection section: Int) -> UIView?
    func _tableView(_ tableView: UITableView,
                    itemsForBeginning session: UIDragSession,
                    at indexPath: IndexPath,
                    title: String) -> [UIDragItem]
    func _tableView(_ tableView: UITableView,
                    dropSessionDidUpdate session: UIDropSession,
                    withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal
}

extension SortableViewControllerProtocol {

    func _setup<T: SortableType>(tableView: UITableView, vc: T) {
        tableView.delegate = vc
        tableView.dataSource = vc
        tableView.dragDelegate = vc
        tableView.dropDelegate = vc
        tableView.dragInteractionEnabled = true
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

}

extension SortableViewControllerProtocol where Self: UITableViewDelegate {

    func _tableView(_ tableView: UITableView,
                    heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}

extension SortableViewControllerProtocol where Self: UITableViewDataSource {

    func _tableView(_ tableView: UITableView,
                    didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func _tableView(_ tableView: UITableView,
                    heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func _tableView(_ tableView: UITableView,
                    viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

}

extension SortableViewControllerProtocol where Self: UITableViewDragDelegate {

    func _tableView(_ tableView: UITableView,
                    itemsForBeginning session: UIDragSession,
                    at indexPath: IndexPath,
                    title: String) -> [UIDragItem] {
        let provider = NSItemProvider(object: title as NSItemProviderWriting)
        return [UIDragItem(itemProvider: provider)]
    }

}

extension SortableViewControllerProtocol where Self: UITableViewDropDelegate {

    func _tableView(_ tableView: UITableView,
                    dropSessionDidUpdate session: UIDropSession,
                    withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move,
                                       intent: .insertAtDestinationIndexPath)
    }

}
