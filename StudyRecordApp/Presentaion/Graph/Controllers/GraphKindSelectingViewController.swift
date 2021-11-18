//
//  GraphKindSelectingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import UIKit

enum SelectedGraphType: Int, CaseIterable {
    case line
    case bar
    case dot

    var title: String {
        switch self {
        case .line: return L10n.line
        case .bar: return L10n.bar
        case .dot: return L10n.dot
        }
    }

    var stackViewSubViewTypes: [StackViewSubViewType] {
        switch self {
        case .line: return [.lineShape, .fillArea, .addDots, .dotShape]
        case .bar: return [.width]
        case .dot: return [.addDots, .dotShape]
        }
    }
}

enum StackViewSubViewType: Int, CaseIterable {
    case lineShape
    case fillArea
    case addDots
    case dotShape
    case width
}

final class GraphKindSelectingViewController: UIViewController {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var lineShapeStraightButton: RadioButton!
    @IBOutlet private weak var lineShapeSmoothButton: RadioButton!
    @IBOutlet private weak var fillAreaButton: RadioButton!
    @IBOutlet private weak var addDotsButton: RadioButton!
    @IBOutlet private weak var dotShapeCircleButton: RadioButton!
    @IBOutlet private weak var dotShapeSquareButton: RadioButton!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var widthSlider: CustomSlider!
    @IBOutlet private weak var sliderLabel: UILabel!

    private let graphUseCase = GraphUseCase(
        repository: GraphRepository()
    )
    private var isSmooth: Bool = false
    private var isFilled: Bool = false
    private var withDots: Bool = true
    private var isSquare: Bool = false
    private var width: Float = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        isSmooth = graphUseCase.graph.line.isSmooth
        isFilled = graphUseCase.graph.line.isFilled
        withDots = graphUseCase.graph.line.withDots
        isSquare = graphUseCase.graph.dot.isSquare
        width = graphUseCase.graph.bar.width

        setupSaveButton()
        setupLineShapeStraightButton()
        setupLineShapeSmoothButton()
        setupFillAreaButton()
        setupAddDotsButton()
        setupDotShapeCircleButton()
        setupDotShapeSquareButton()
        setupSegmentedControl()
        setupStackView()
        setupSlider()

    }

}

// MARK: - IBAction func
private extension GraphKindSelectingViewController {

    @IBAction func segmentedControlDidTapped(_ sender: UISegmentedControl) {
        filterStackView(index: sender.selectedSegmentIndex)
    }

    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let selectedType = SelectedGraphType.allCases[segmentedControl.selectedSegmentIndex]
        let newGraph = Graph(selectedType: selectedType,
                             line: Line(isSmooth: isSmooth,
                                        isFilled: isFilled,
                                        withDots: withDots),
                             bar: Bar(width: width),
                             dot: Dot(isSquare: isSquare),
                             identifier: graphUseCase.graph.identifier)
        NotificationCenter.default.post(name: .graphSaveButtonDidTappped,
                                        object: nil,
                                        userInfo: ["isChanged": newGraph != graphUseCase.graph])
        graphUseCase.update(graph: newGraph)
        dismiss(animated: true)
    }

    @IBAction func lineShapeStraightButtonDidTapped(_ sender: Any) {
        if isSmooth {
            lineShapeStraightButton.setImage(isFilled: true)
            lineShapeSmoothButton.setImage(isFilled: false)
        }
        isSmooth = false
    }

    @IBAction func lineShapeSmoothButtonDidTapped(_ sender: Any) {
        if !isSmooth {
            lineShapeStraightButton.setImage(isFilled: false)
            lineShapeSmoothButton.setImage(isFilled: true)

        }
        isSmooth = true
    }

    @IBAction func fillAreaButtonDidTapped(_ sender: Any) {
        fillAreaButton.setImage(isFilled: !isFilled)
        isFilled.toggle()
    }

    @IBAction func addDotsButtonDidTapped(_ sender: Any) {
        addDotsButton.setImage(isFilled: !withDots)
        dotShapeCircleButton.isHidden = withDots
        dotShapeSquareButton.isHidden = withDots
        withDots.toggle()
    }

    @IBAction func dotShapeCircleButtonDidTapped(_ sender: Any) {
        if isSquare {
            dotShapeCircleButton.setImage(isFilled: true)
            dotShapeSquareButton.setImage(isFilled: false)
        }
        isSquare = false
    }

    @IBAction func dotShapeSquareButtonDidTapped(_ sender: Any) {
        if !isSquare {
            dotShapeCircleButton.setImage(isFilled: false)
            dotShapeSquareButton.setImage(isFilled: true)
        }
        isSquare = true
    }

    @IBAction func widthSliderValueDidChanged(_ sender: UISlider) {
        width = sender.value
        sliderLabel.text = String(Int(width))
    }

}

// MARK: - func
private extension GraphKindSelectingViewController {

    func filterStackView(index: Int) {
        let graphType = SelectedGraphType.allCases[index]
        StackViewSubViewType.allCases.enumerated().forEach { index, stackViewSubViewType in
            if graphType.stackViewSubViewTypes.contains(stackViewSubViewType) {
                stackView.arrangedSubviews[index].isHidden = false
            } else {
                stackView.arrangedSubviews[index].isHidden = true
            }
        }
    }

}

// MARK: - HalfModalPresenterDelegate
extension GraphKindSelectingViewController: HalfModalPresenterDelegate {

    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }

}

// MARK: - setup
private extension GraphKindSelectingViewController {

    func setupSegmentedControl() {
        let titles = SelectedGraphType.allCases.map { $0.title }
        let index = graphUseCase.graph.selectedType.rawValue
        segmentedControl.create(titles, selectedIndex: index)
    }

    func setupStackView() {
        let index = graphUseCase.graph.selectedType.rawValue
        filterStackView(index: index)
        segmentedControl.selectedSegmentIndex = index
    }

    func setupLineShapeStraightButton() {
        lineShapeStraightButton.setTitle(L10n.straight)
        lineShapeStraightButton.setImage(isFilled: !isSmooth)
    }

    func setupLineShapeSmoothButton() {
        lineShapeSmoothButton.setTitle(L10n.smooth)
        lineShapeSmoothButton.setImage(isFilled: isSmooth)
    }

    func setupFillAreaButton() {
        fillAreaButton.setTitle(L10n.fill)
        fillAreaButton.setImage(isFilled: isFilled)
    }

    func setupAddDotsButton() {
        addDotsButton.setTitle(L10n.addDot)
        addDotsButton.setImage(isFilled: withDots)
    }

    func setupDotShapeCircleButton() {
        dotShapeCircleButton.setTitle(L10n.circleDot)
        dotShapeCircleButton.setImage(isFilled: !isSquare)
        dotShapeCircleButton.isHidden = !withDots
    }

    func setupDotShapeSquareButton() {
        dotShapeSquareButton.setTitle(L10n.squareDot)
        dotShapeSquareButton.setImage(isFilled: isSquare)
        dotShapeSquareButton.isHidden = !withDots
    }

    func setupSaveButton() {
        saveButton.setTitle(L10n.save)
    }

    func setupSlider() {
        widthSlider.value = width
        sliderLabel.text = String(Int(width))
    }

}
