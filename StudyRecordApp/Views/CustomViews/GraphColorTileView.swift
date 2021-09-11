//
//  GraphColorTileView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

protocol GraphColorTileViewDelegate: AnyObject {
    func tileViewDidTapped(selectedView: TileView)
    func findSameColor(selectedView: TileView)
}

final class GraphColorTileView: UIView {
    
    @IBOutlet private weak var tileStackView: UIStackView!
    
    private var tileStackViews: [UIStackView] {
        tileStackView.arrangedSubviews.map { $0 as! UIStackView }
    }
    weak var delegate: GraphColorTileViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadNib()
        setupTileViews()
        
    }
    
    private func setupTileViews() {
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
    
    private func loadNib() {
        guard let view = UINib(nibName: String(describing: type(of: self)),
                               bundle: nil
        ).instantiate(withOwner: self,
                      options: nil)
        .first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}

extension GraphColorTileView: TileViewDelegate {
    
    func tileViewDidTapped(selectedView: TileView) {
        delegate?.tileViewDidTapped(selectedView: selectedView)
    }
    
}
