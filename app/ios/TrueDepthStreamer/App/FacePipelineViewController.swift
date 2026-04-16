import UIKit

final class FacePipelineViewController: UIViewController {
    private let renderer = SceneKitFaceMeshRenderer()
    private lazy var captureManager = FaceCaptureManager(session: renderer.session)
    private let controlsView = ControlsView()
    private let renderScrimView = UIView()
    private let runtimeGuidanceView = RuntimeGuidanceView()
    private lazy var pipelineController = FacePipelineController(
        renderer: renderer,
        captureManager: captureManager
    )
    private var simulationState = SimulationState()

    private let inspectSnapshotButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Inspect 3D Snapshot", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
        btn.accessibilityIdentifier = "inspect-snapshot-button"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureBindings()
        inspectSnapshotButton.addTarget(self, action: #selector(openSnapshotCanvas), for: .touchUpInside)
        pipelineController.delegate = self
        controlsView.statusText = "Ready to start face capture."
        controlsView.setControlsEnabled(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pipelineController.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        pipelineController.pause()
        super.viewWillDisappear(animated)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    private func configureViewHierarchy() {
        view.backgroundColor = .black

        let renderView = renderer.view
        renderView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        renderScrimView.translatesAutoresizingMaskIntoConstraints = false
        renderScrimView.backgroundColor = UIColor(white: 0, alpha: 0.48)
        renderScrimView.isHidden = true
        runtimeGuidanceView.translatesAutoresizingMaskIntoConstraints = false
        runtimeGuidanceView.isHidden = true

        view.addSubview(renderView)
        view.addSubview(renderScrimView)
        view.addSubview(runtimeGuidanceView)
        view.addSubview(controlsView)
        view.addSubview(inspectSnapshotButton)

        NSLayoutConstraint.activate([
            renderView.topAnchor.constraint(equalTo: view.topAnchor),
            renderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            renderScrimView.topAnchor.constraint(equalTo: view.topAnchor),
            renderScrimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderScrimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderScrimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            runtimeGuidanceView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            runtimeGuidanceView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            runtimeGuidanceView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),

            controlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            controlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            inspectSnapshotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inspectSnapshotButton.bottomAnchor.constraint(equalTo: controlsView.topAnchor, constant: -22)
        ])
    }

    private func configureBindings() {
        controlsView.onNoseProjectionChange = { [weak self] value in
            guard let self = self else { return }
            self.simulationState.noseProjection = value
            self.pipelineController.updateSimulationState(self.simulationState)
        }
    }

    func applyCaptureStatus(_ status: FaceCaptureStatus) {
        switch status {
        case .unsupported:
            controlsView.setControlsEnabled(false)
            controlsView.setGuidance(
                title: "TrueDepth hardware required",
                message: "The simulator is only for launch, UI, and CI smoke coverage. Use a physical iPhone or iPad with a front-facing TrueDepth camera to validate live capture and rendering.",
                tone: .warning
            )
            runtimeGuidanceView.configure(
                title: "TrueDepth Hardware Required",
                message: "Face tracking is unavailable here, so the renderer stays in its empty state. This is expected on the simulator and on hardware without a front-facing TrueDepth sensor.",
                checklist: [
                    "Run the app on a physical iPhone or iPad with TrueDepth hardware.",
                    "Grant camera permission when prompted.",
                    "Use this simulator build only to verify launch, controls, and unsupported-state UX."
                ],
                accentColor: UIColor(red: 0.96, green: 0.76, blue: 0.32, alpha: 1)
            )
            runtimeGuidanceView.isHidden = false
            renderScrimView.isHidden = false
            inspectSnapshotButton.isEnabled = false
            inspectSnapshotButton.alpha = 0.48
        case .failed(let reason):
            controlsView.setControlsEnabled(false)
            controlsView.setGuidance(
                title: "Capture unavailable",
                message: "The AR session failed to start or continue. Check hardware support, camera permission, and current device conditions before retrying.",
                tone: .error
            )
            runtimeGuidanceView.configure(
                title: "Capture Session Failed",
                message: reason,
                checklist: [
                    "Confirm the app is running on supported TrueDepth hardware.",
                    "Check camera permission in Settings.",
                    "Relaunch the app and retry the session."
                ],
                accentColor: UIColor(red: 1, green: 0.45, blue: 0.45, alpha: 1)
            )
            runtimeGuidanceView.isHidden = false
            renderScrimView.isHidden = false
            inspectSnapshotButton.isEnabled = false
            inspectSnapshotButton.alpha = 0.48
        default:
            controlsView.setControlsEnabled(true)
            controlsView.setGuidance(title: nil, message: nil, tone: .info)
            runtimeGuidanceView.isHidden = true
            renderScrimView.isHidden = true
            inspectSnapshotButton.isEnabled = true
            inspectSnapshotButton.alpha = 1.0
        }
    }

    @objc private func openSnapshotCanvas() {
        guard let snapshot = pipelineController.latestSnapshot, !snapshot.mesh.isEmpty else {
            presentAlert(
                title: "No snapshot available",
                message: "Wait for live tracking to lock onto your face, then open the 3D canvas."
            )
            return
        }

        let canvas = FaceCanvasViewController(
            snapshot: snapshot,
            initialState: simulationState
        )

        if let navigationController = navigationController {
            navigationController.pushViewController(canvas, animated: true)
        } else {
            let wrapped = UINavigationController(rootViewController: canvas)
            wrapped.modalPresentationStyle = .fullScreen
            present(wrapped, animated: true)
        }
    }

    /// Utility to show alerts
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension FacePipelineViewController: FacePipelineControllerDelegate {
    func facePipelineController(_ controller: FacePipelineController, didChangeStatus message: String) {
        controlsView.statusText = message
    }

    func facePipelineController(_ controller: FacePipelineController, didUpdateCaptureStatus status: FaceCaptureStatus) {
        applyCaptureStatus(status)
    }
}

private final class RuntimeGuidanceView: UIVisualEffectView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textColor = .white
        label.accessibilityIdentifier = "runtime-guidance-title"
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0.9, alpha: 1)
        label.accessibilityIdentifier = "runtime-guidance-message"
        return label
    }()

    private let checklistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 0.83, alpha: 1)
        label.accessibilityIdentifier = "runtime-guidance-checklist"
        return label
    }()

    private let accentBar = UIView()

    init() {
        let effect: UIBlurEffect
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemChromeMaterialDark)
        } else {
            effect = UIBlurEffect(style: .dark)
        }
        super.init(effect: effect)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func configure(title: String, message: String, checklist: [String], accentColor: UIColor) {
        titleLabel.text = title
        messageLabel.text = message
        checklistLabel.text = checklist.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n")
        accentBar.backgroundColor = accentColor
    }

    private func configureView() {
        layer.cornerRadius = 24
        clipsToBounds = true
        accessibilityIdentifier = "runtime-guidance-card"

        accentBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        checklistLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(accentBar)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(checklistLabel)

        NSLayoutConstraint.activate([
            accentBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            accentBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            accentBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accentBar.heightAnchor.constraint(equalToConstant: 4),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            checklistLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            checklistLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            checklistLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            checklistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
