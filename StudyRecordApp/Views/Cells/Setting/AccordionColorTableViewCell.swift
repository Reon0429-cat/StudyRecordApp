//
//  AccordionColorTableViewCell.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/11.
//

import UIKit

final class AccordionColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var leftTileView: ThemeColorTileView!
    @IBOutlet private weak var centerTileView: ThemeColorTileView!
    @IBOutlet private weak var rightTileView: ThemeColorTileView!
    
    var onTapEvent: ((UIView) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        leftTileView.layer.cornerRadius = 0
        centerTileView.layer.cornerRadius = 0
        rightTileView.layer.cornerRadius = 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftTileView.delegate = self
        centerTileView.delegate = self
        rightTileView.delegate = self
        
    }
    
    func configure(colors: [UIColor],
                   onTapEvent: @escaping ((UIView) -> Void)) {
        self.onTapEvent = onTapEvent
        leftTileView.backgroundColor = colors[0]
        centerTileView.backgroundColor = colors[1]
        rightTileView.backgroundColor = colors[2]
    }
    
}

extension AccordionColorTableViewCell: ThemeColorTileViewDelegate {
    
    func tileViewDidTapped(selectedView: UIView) {
        onTapEvent?(selectedView)
    }
    
}
