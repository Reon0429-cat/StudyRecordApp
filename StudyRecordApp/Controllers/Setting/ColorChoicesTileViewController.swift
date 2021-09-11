//
//  ColorChoicesTileViewController.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/30.
//

import UIKit

enum TileColorType: Int {
    case licorice
    case maraschino
    case tangerine
    case lemon
    case spring
    case seaFoam
    case turquoise
    case aqua
    case blueberry
    case grape
    case magenta
    case strawberry
    
    func loadColor(alpha: CGFloat) -> UIColor {
        switch self {
            case .licorice:
                return  UIColor.rgba(red: 0, green: 0, blue: 0, alpha: alpha)
            case .maraschino:
                return UIColor.rgba(red: 255, green: 38, blue: 0, alpha: alpha)
            case .tangerine:
                return UIColor.rgba(red: 255, green: 147, blue: 0, alpha: alpha)
            case .lemon:
                return UIColor.rgba(red: 255, green: 251, blue: 0, alpha: alpha)
            case .spring:
                return UIColor.rgba(red: 0, green: 249, blue: 0, alpha: alpha)
            case .seaFoam:
                return UIColor.rgba(red: 0, green: 250, blue: 146, alpha: alpha)
            case .turquoise:
                return UIColor.rgba(red: 0, green: 253, blue: 255, alpha: alpha)
            case .aqua:
                return UIColor.rgba(red: 0, green: 150, blue: 255, alpha: alpha)
            case .blueberry:
                return UIColor.rgba(red: 4, green: 51, blue: 255, alpha: alpha)
            case .grape:
                return UIColor.rgba(red: 148, green: 55, blue: 255, alpha: alpha)
            case .magenta:
                return UIColor.rgba(red: 255, green: 64, blue: 255, alpha: alpha)
            case .strawberry:
                return UIColor.rgba(red: 255, green: 47, blue: 146, alpha: alpha)
        }
    }
}

// MARK: - ToDo タイルを選択した時のバグを直す
// MARK: - ToDo 同じタイルを選択すると色をなくすようにする

protocol ColorChoicesTileVCDelegate: AnyObject {
    func tileViewDidTapped(selectedView: UIView)
}

final class ColorChoicesTileViewController: UIViewController {
    
    @IBOutlet private weak var themeColorStackView: UIStackView!
    
    weak var delegate: ColorChoicesTileVCDelegate?
    private var tileStackViews: [UIStackView] {
        themeColorStackView.arrangedSubviews.map { $0 as! UIStackView }
    }
    private var selectedTileView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTileViews()
        setObserver()
        
    }
    
}

// MARK: - func
private extension ColorChoicesTileViewController {
    
    func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(findSameColorTileView),
                                               name: .themeColor,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(initTileView),
                                               name: .initTileView,
                                               object: nil)
    }
    
    @objc
    func findSameColorTileView(notification: Notification) {
        let nextSelectedView = notification.userInfo!["selectedView"] as! UIView
        selectedTileView?.layer.cornerRadius = 0
        tileStackViews.forEach { stackView in
            stackView.arrangedSubviews
                .map { $0 as! TileView }
                .forEach { tileView in
                    let sameColor = (tileView.backgroundColor == nextSelectedView.backgroundColor)
                    let sameAlpha = (tileView.alpha == nextSelectedView.alpha)
                    if sameColor && sameAlpha {
                        tileView.cutToCircle()
                        self.selectedTileView = tileView
                    }
                }
        }
    }
    
    @objc
    func initTileView() {
        selectedTileView?.layer.cornerRadius = 0
    }
    
}

// MARK: - TileViewDelegate
extension ColorChoicesTileViewController: TileViewDelegate {
    
    func tileViewDidTapped(selectedView: TileView) {
        delegate?.tileViewDidTapped(selectedView: selectedView)
        UIView.animate(withDuration: 0.1) {
            if self.selectedTileView != selectedView {
                self.selectedTileView?.layer.cornerRadius = 0
            }
        }
        self.selectedTileView = selectedView
    }
    
}

// MARK: - setup
private extension ColorChoicesTileViewController {
    
    func setupTileViews() {
        tileStackViews
            .enumerated()
            .forEach { verticalCount, stackView in
                stackView.arrangedSubviews
                    .map { $0 as! TileView }
                    .enumerated()
                    .forEach { horizontalCount, tileView in
                        tileView.delegate = self
                        let alpha = CGFloat(100 - 10 * horizontalCount)
                        let color = TileColorType(rawValue: verticalCount)?.loadColor(alpha: alpha)
                        tileView.backgroundColor = color
                    }
            }
    }
    
}
