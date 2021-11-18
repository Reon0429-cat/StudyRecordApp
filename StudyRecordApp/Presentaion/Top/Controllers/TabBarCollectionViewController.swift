//
//  TabBarCollectionViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/07.
//

import UIKit

protocol TabBarCollectionVCDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
}

final class TabBarCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    weak var delegate: TabBarCollectionVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

    }

    func scroll(at item: Int) {
        collectionView.scrollToItem(at: IndexPath(item: item,
                                                  section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
    }

}

// MARK: - UICollectionViewDelegate
extension TabBarCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView,
                                 didSelectItemAt: indexPath)
    }

}

// MARK: - UICollectionViewDataSource
extension TabBarCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return ScreenType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCustomCell(with: ScreenTransitionCollectionViewCell.self,
                                                            indexPath: indexPath)
        let screenType = ScreenType.allCases[indexPath.row]
        cell.configure(title: screenType.title)
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension TabBarCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 15
        let verticalSpace: CGFloat = 15
        let width = collectionView.frame.size.width / 2 - horizontalSpace * 2
        let height = collectionView.frame.size.height - verticalSpace * 2
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

}

// MARK: - setup
private extension TabBarCollectionViewController {

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCustomCell(ScreenTransitionCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
    }

}
