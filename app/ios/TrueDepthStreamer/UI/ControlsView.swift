import UIKit

final class ControlsView: UIView {
    var onNoseProjectionChange: ((Float) -> Void)?

    var statusText: String = "" {
        didSet {
            statusLabel.text = statusText
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Surgery Simulator"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()

    private let pipelineLabel: UILabel = {
        let label = UILabel()
        label.text = "Capture -> Model -> Simulate -> Render"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(white: 0.82, alpha: 1)
        return label
    }()

    private let deformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Nose Projection"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0.76, alpha: 1)
        return label
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.minimumTrackTintColor = UIColor(red: 0.20, green: 0.82, blue: 0.78, alpha: 1)
        slider.maximumTrackTintColor = UIColor(white: 1, alpha: 0.24)
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        return slider
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        return button
    }()

    private let panelView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.layer.cornerRadius = 18
        blurView.clipsToBounds = true
        return blurView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        backgroundColor = .clear
        addSubview(panelView)

        panelView.translatesAutoresizingMaskIntoConstraints = false

        let topRow = UIStackView(arrangedSubviews: [deformationLabel, resetButton])
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.distribution = .equalSpacing

        let contentStack = UIStackView(arrangedSubviews: [titleLabel, pipelineLabel, topRow, slider, statusLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        panelView.contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            panelView.topAnchor.constraint(equalTo: topAnchor),
            panelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            panelView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: panelView.contentView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: panelView.contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: panelView.contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: panelView.contentView.bottomAnchor, constant: -16)
        ])
    }

    @objc
    private func sliderChanged(_ sender: UISlider) {
        onNoseProjectionChange?(sender.value)
    }

    @objc
    private func resetTapped() {
        slider.setValue(0, animated: true)
        onNoseProjectionChange?(0)
    }
}
