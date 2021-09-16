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
            case .dot: return [.dotShape]
        }
    }
}

enum StackViewSubViewType: CaseIterable {
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
    @IBOutlet private weak var lineShapeStraightLabel: UILabel!
    @IBOutlet private weak var lineShapeSmoothLabel: UILabel!
    @IBOutlet private weak var fillAreaNotLabel: UILabel!
    @IBOutlet private weak var fillAreaLabel: UILabel!
    @IBOutlet private weak var addDotsNotLabel: UILabel!
    @IBOutlet private weak var addDotsLabel: UILabel!
    @IBOutlet private weak var dotShapeCircleLabel: UILabel!
    @IBOutlet private weak var dotShapeSquareLabel: UILabel!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var lineShapeSwitch: CustomSwitch!
    @IBOutlet private weak var fillAreaSwitch: CustomSwitch!
    @IBOutlet private weak var addDotsSwitch: CustomSwitch!
    @IBOutlet private weak var dotShapeSwitch: CustomSwitch!
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
        
        setupLabels()
        setupSaveButton()
        setupSegmentedControl()
        setupStackView()
        setupSlider()
        setupSwitch()
        
    }
    
}

// MARK: - IBAction func
private extension GraphKindSelectingViewController {
    
    @IBAction func segmentedControlDidTapped(_ sender: UISegmentedControl) {
        filterStackView(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let selectedType = SelectedGraphType.allCases[segmentedControl.selectedSegmentIndex]
        let graph = Graph(selectedType: selectedType,
                          line: Line(isSmooth: isSmooth,
                                     isFilled: isFilled,
                                     withDots: withDots),
                          bar: Bar(width: width),
                          dot: Dot(isSquare: isSquare))
        graphUseCase.update(graph: graph)
        NotificationCenter.default.post(name: .graphSaveButtonDidTappped, object: nil)
        dismiss(animated: true)
    }
    
    @IBAction func lineShapeSwitchDidToggled(_ sender: UISwitch) {
        isSmooth = sender.isOn
    }
    
    @IBAction func fillAreaSwitchDidToggled(_ sender: UISwitch) {
        isFilled = sender.isOn
    }
    
    @IBAction func addDotsSwitchDidToggled(_ sender: UISwitch) {
        withDots = sender.isOn
    }
    
    @IBAction func dotShapeSwitchDidToggled(_ sender: UISwitch) {
        isSquare = sender.isOn
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
    
    func setupLabels() {
        lineShapeStraightLabel.text = LocalizeKey.straight.localizedString()
        lineShapeSmoothLabel.text = LocalizeKey.smooth.localizedString()
        fillAreaNotLabel.text = LocalizeKey.notFill.localizedString()
        fillAreaLabel.text = LocalizeKey.fill.localizedString()
        addDotsNotLabel.text = LocalizeKey.addNotDot.localizedString()
        addDotsLabel.text = LocalizeKey.addDot.localizedString()
        dotShapeCircleLabel.text = LocalizeKey.circleDot.localizedString()
        dotShapeSquareLabel.text = LocalizeKey.squareDot.localizedString()
    }
    
    func setupSaveButton() {
        saveButton.setTitle(LocalizeKey.save.localizedString())
    }
    
    func setupSwitch() {
        lineShapeSwitch.isOn = isSmooth
        fillAreaSwitch.isOn = isFilled
        addDotsSwitch.isOn = withDots
        dotShapeSwitch.isOn = isSquare
    }
    
    func setupSlider() {
        widthSlider.value = width
        sliderLabel.text = String(Int(width))
    }
    
}
