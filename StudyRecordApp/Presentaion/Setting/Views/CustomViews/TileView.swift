//
//  TileView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import UIKit

protocol TileViewDelegate: AnyObject {
    func tileViewDidTapped(selectedView: TileView)
}

final class TileView: UIView {

    weak var delegate: TileViewDelegate?
    enum State {
        case circle
        case square

        mutating func toggle() {
            switch self {
            case .circle: self = .square
            case .square: self = .circle
            }
        }
    }

    private var state: State = .square {
        didSet {
            switch state {
            case .circle:
                self.cutToCircle()
            case .square:
                self.layer.cornerRadius = 0
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
                self.state.toggle()
            }
        })
        delegate?.tileViewDidTapped(selectedView: self)
    }

    func change(color: UIColor) {
        self.backgroundColor = color
    }

    func change(state: State) {
        self.state = state
    }

    func getState() -> State {
        return self.state
    }

}
