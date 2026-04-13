import UIKit

final class FacePipelineViewController: UIViewController {
    private let renderer = SceneKitFaceMeshRenderer()
    private lazy var captureManager = FaceCaptureManager(session: renderer.session)
    private let controlsView = ControlsView()
    private lazy var pipelineController = FacePipelineController(
        renderer: renderer,
        captureManager: captureManager
    )
    private var simulationState = SimulationState()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureBindings()
        pipelineController.delegate = self
        controlsView.statusText = "Ready to start face capture."
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

        view.addSubview(renderView)
        view.addSubview(controlsView)

        NSLayoutConstraint.activate([
            renderView.topAnchor.constraint(equalTo: view.topAnchor),
            renderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            controlsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            controlsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func configureBindings() {
        controlsView.onNoseProjectionChange = { [weak self] value in
            guard let self = self else { return }
            self.simulationState.noseProjection = value
            self.pipelineController.updateSimulationState(self.simulationState)
        }
    }
}

extension FacePipelineViewController: FacePipelineControllerDelegate {
    func facePipelineController(_ controller: FacePipelineController, didChangeStatus message: String) {
        controlsView.statusText = message
    }
}
