import SceneKit
import UIKit
import simd

final class FaceCanvasViewController: UIViewController {
    private let snapshot: FaceMeshSnapshot
    private let deformationPipeline = DeformationPipeline(deformations: [NoseAugmentation()])

    private var simulationState: SimulationState
    private var currentMesh: FaceMesh

    private let sceneView = SCNView(frame: .zero)
    private let scene = SCNScene()
    private let meshNode = SCNNode()
    private let cameraNode = SCNNode()

    private let canvasPanel: UIVisualEffectView = {
        let effect: UIBlurEffect
        if #available(iOS 13.0, *) {
            effect = UIBlurEffect(style: .systemChromeMaterialDark)
        } else {
            effect = UIBlurEffect(style: .dark)
        }

        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "3D Snapshot"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Orbit, pan, and zoom to inspect the captured face mesh."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.84, alpha: 1)
        label.numberOfLines = 0
        return label
    }()

    private let deformationLabel: UILabel = {
        let label = UILabel()
        label.text = "Nose Projection"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        return label
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(white: 0.84, alpha: 1)
        label.textAlignment = .right
        return label
    }()

    private lazy var projectionSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = UIColor(red: 0.91, green: 0.59, blue: 0.38, alpha: 1)
        slider.maximumTrackTintColor = UIColor(white: 1, alpha: 0.22)
        slider.addTarget(self, action: #selector(projectionChanged(_:)), for: .valueChanged)
        return slider
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(resetProjection), for: .touchUpInside)
        return button
    }()

    private lazy var exportButtonItem: UIBarButtonItem = {
        UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportMesh))
    }()

    init(snapshot: FaceMeshSnapshot, initialState: SimulationState = SimulationState()) {
        self.snapshot = snapshot
        self.simulationState = initialState
        self.currentMesh = snapshot.mesh
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Canvas"
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = exportButtonItem

        configureScene()
        configureLayout()
        projectionSlider.setValue(simulationState.noseProjection, animated: false)
        applySimulationState()
    }

    private func configureScene() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.backgroundColor = .black
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = false
        sceneView.rendersContinuously = false

        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zNear = 0.001
        cameraNode.camera?.zFar = 10
        scene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode

        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 250
        scene.rootNode.addChildNode(ambientLight)

        let keyLight = SCNNode()
        keyLight.light = SCNLight()
        keyLight.light?.type = .omni
        keyLight.position = SCNVector3(0.18, 0.15, 0.35)
        scene.rootNode.addChildNode(keyLight)

        let fillLight = SCNNode()
        fillLight.light = SCNLight()
        fillLight.light?.type = .omni
        fillLight.light?.intensity = 350
        fillLight.position = SCNVector3(-0.16, -0.08, 0.22)
        scene.rootNode.addChildNode(fillLight)

        scene.rootNode.addChildNode(meshNode)
    }

    private func configureLayout() {
        let topRow = UIStackView(arrangedSubviews: [deformationLabel, percentageLabel, resetButton])
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = 12

        let contentStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, topRow, projectionSlider])
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(sceneView)
        view.addSubview(canvasPanel)
        canvasPanel.contentView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            canvasPanel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            canvasPanel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            canvasPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: canvasPanel.contentView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: canvasPanel.contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: canvasPanel.contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: canvasPanel.contentView.bottomAnchor, constant: -16)
        ])
    }

    private func applySimulationState() {
        let context = DeformationContext(
            state: simulationState,
            landmarks: snapshot.landmarks,
            blendShapes: [:],
            timestamp: snapshot.timestamp
        )

        currentMesh = deformationPipeline.apply(to: snapshot.mesh, context: context)
        percentageLabel.text = "\(Int((simulationState.noseProjection * 100).rounded()))%"
        render(mesh: currentMesh)
    }

    private func render(mesh: FaceMesh) {
        meshNode.geometry = makeGeometry(from: mesh)
        meshNode.geometry?.firstMaterial = makeMaterial()
        updateFraming(for: mesh)
    }

    private func updateFraming(for mesh: FaceMesh) {
        guard let bounds = bounds(for: mesh) else { return }

        let center = (bounds.min + bounds.max) / 2
        let radius = max(
            mesh.vertices.map { simd_length($0 - center) }.max() ?? 0.06,
            0.06
        )

        meshNode.simdPosition = -center
        cameraNode.simdPosition = SIMD3<Float>(0, 0, radius * 2.8)
        cameraNode.look(at: SCNVector3Zero)
    }

    private func bounds(for mesh: FaceMesh) -> (min: SIMD3<Float>, max: SIMD3<Float>)? {
        guard let first = mesh.vertices.first else {
            return nil
        }

        var minPoint = first
        var maxPoint = first

        for vertex in mesh.vertices.dropFirst() {
            minPoint = simd_min(minPoint, vertex)
            maxPoint = simd_max(maxPoint, vertex)
        }

        return (min: minPoint, max: maxPoint)
    }

    private func makeGeometry(from mesh: FaceMesh) -> SCNGeometry {
        let vertexSource = SCNGeometrySource(
            data: data(from: mesh.vertices),
            semantic: .vertex,
            vectorCount: mesh.vertices.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<SIMD3<Float>>.stride
        )

        let normalSource = SCNGeometrySource(
            data: data(from: mesh.normals),
            semantic: .normal,
            vectorCount: mesh.normals.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<SIMD3<Float>>.stride
        )

        let elementIndices = mesh.indices.map(Int32.init)
        let element = SCNGeometryElement(
            data: data(from: elementIndices),
            primitiveType: .triangles,
            primitiveCount: elementIndices.count / 3,
            bytesPerIndex: MemoryLayout<Int32>.size
        )

        return SCNGeometry(sources: [vertexSource, normalSource], elements: [element])
    }

    private func makeMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 0.88, green: 0.74, blue: 0.67, alpha: 1)
        material.lightingModel = .physicallyBased
        material.isDoubleSided = true
        material.metalness.contents = 0.05
        material.roughness.contents = 0.72
        return material
    }

    private func data<T>(from values: [T]) -> Data {
        values.withUnsafeBufferPointer { buffer in
            guard let baseAddress = buffer.baseAddress else {
                return Data()
            }
            return Data(bytes: baseAddress, count: buffer.count * MemoryLayout<T>.stride)
        }
    }

    @objc
    private func projectionChanged(_ sender: UISlider) {
        simulationState.noseProjection = sender.value
        applySimulationState()
    }

    @objc
    private func resetProjection() {
        simulationState = SimulationState()
        projectionSlider.setValue(0, animated: true)
        applySimulationState()
    }

    @objc
    private func exportMesh() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let exporter = OBJFaceMeshExporter(outputDirectory: documents)

        do {
            let url = try exporter.export(mesh: currentMesh)
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let popover = activity.popoverPresentationController {
                popover.barButtonItem = exportButtonItem
            }
            present(activity, animated: true)
        } catch {
            let alert = UIAlertController(
                title: "Export Failed",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
