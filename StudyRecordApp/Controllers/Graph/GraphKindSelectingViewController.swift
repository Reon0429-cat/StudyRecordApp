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
            case .line: return LocalizeKey.Line.localizedString()
            case .bar: return LocalizeKey.Bar.localizedString()
            case .dot: return LocalizeKey.Dot.localizedString()
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

// MARK: - ToDo スイッチを他のものに変える

final class GraphKindSelectingViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var lineShapeStraightButton: UIButton!
    @IBOutlet private weak var lineShapeSmoothButton: UIButton!
    @IBOutlet private weak var fillAreaButton: UIButton!
    @IBOutlet private weak var addDotsButton: UIButton!
    @IBOutlet private weak var dotShapeCircleButton: UIButton!
    @IBOutlet private weak var dotShapeSquareButton: UIButton!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var widthSlider: CustomSlider!
    @IBOutlet private weak var sliderLabel: UILabel!

    private var graphUseCase = GraphUseCase(
        repository: GraphRepository(
            dataStore: RealmGraphDataStore()
        )
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
            lineShapeStraightButton.setImage(radioButtonImage(isFilled: true))
            lineShapeSmoothButton.setImage(radioButtonImage(isFilled: false))
        }
        isSmooth = false
    }
    
    @IBAction func lineShapeSmoothButtonDidTapped(_ sender: Any) {
        if !isSmooth {
            lineShapeStraightButton.setImage(radioButtonImage(isFilled: false))
            lineShapeSmoothButton.setImage(radioButtonImage(isFilled: true))
        }
        isSmooth = true
    }
    
    @IBAction func fillAreaButtonDidTapped(_ sender: Any) {
        fillAreaButton.setImage(radioButtonImage(isFilled: !isFilled))
        isFilled.toggle()
    }
    
    @IBAction func addDotsButtonDidTapped(_ sender: Any) {
        addDotsButton.setImage(radioButtonImage(isFilled: !withDots))
        dotShapeCircleButton.isHidden = withDots
        dotShapeSquareButton.isHidden = withDots
        withDots.toggle()
    }
    
    @IBAction func dotShapeCircleButtonDidTapped(_ sender: Any) {
        if isSquare {
            dotShapeCircleButton.setImage(radioButtonImage(isFilled: true))
            dotShapeSquareButton.setImage(radioButtonImage(isFilled: false))
        }
        isSquare = false
    }
    
    @IBAction func dotShapeSquareButtonDidTapped(_ sender: Any) {
        if !isSquare {
            dotShapeCircleButton.setImage(radioButtonImage(isFilled: false))
            dotShapeSquareButton.setImage(radioButtonImage(isFilled: true))
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
        lineShapeStraightButton.setTitle(LocalizeKey.straight.localizedString())
        lineShapeStraightButton.setImage(radioButtonImage(isFilled: !isSmooth))
    }
    
    func setupLineShapeSmoothButton() {
        lineShapeSmoothButton.setTitle(LocalizeKey.smooth.localizedString())
        lineShapeSmoothButton.setImage(radioButtonImage(isFilled: isSmooth))
    }
    
    func setupFillAreaButton() {
        fillAreaButton.setTitle(LocalizeKey.fill.localizedString())
        fillAreaButton.setImage(radioButtonImage(isFilled: isFilled))
    }
    
    func setupAddDotsButton() {
        addDotsButton.setTitle(LocalizeKey.addDot.localizedString())
        addDotsButton.setImage(radioButtonImage(isFilled: withDots))
    }
    
    func setupDotShapeCircleButton() {
        dotShapeCircleButton.setTitle(LocalizeKey.circleDot.localizedString())
        dotShapeCircleButton.setImage(radioButtonImage(isFilled: !isSquare))
        dotShapeCircleButton.isHidden = !withDots
    }
    
    func setupDotShapeSquareButton() {
        dotShapeSquareButton.setTitle(LocalizeKey.squareDot.localizedString())
        dotShapeSquareButton.setImage(radioButtonImage(isFilled: isSquare))
        dotShapeSquareButton.isHidden = !withDots
    }
    
    func radioButtonImage(isFilled: Bool) -> UIImage {
        let imageName: String = {
            if isFilled {
                return "record.circle"
            }
            return "circle"
        }()
        return UIImage(systemName: imageName)!
    }
    
    func setupSaveButton() {
        saveButton.setTitle(LocalizeKey.save.localizedString())
    }
    
    func setupSlider() {
        widthSlider.value = width
        sliderLabel.text = String(Int(width))
    }
    
}
