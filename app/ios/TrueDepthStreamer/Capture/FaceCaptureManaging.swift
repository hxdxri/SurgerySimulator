import ARKit

enum FaceCaptureStatus: Equatable {
    case idle
    case running
    case paused
    case interrupted
    case interruptedEnded
    case unsupported
    case failed(String)

    var message: String {
        switch self {
        case .idle:
            return "Capture idle."
        case .running:
            return "Tracking live face mesh."
        case .paused:
            return "Capture paused."
        case .interrupted:
            return "Capture interrupted."
        case .interruptedEnded:
            return "Capture interruption ended. Restarting session."
        case .unsupported:
            return "AR face tracking is not supported on this device."
        case .failed(let reason):
            return "Capture failed: \(reason)"
        }
    }
}

protocol FaceCaptureManagerDelegate: AnyObject {
    func faceCaptureManager(_ manager: FaceCaptureManaging, didChange status: FaceCaptureStatus)
    func faceCaptureManager(_ manager: FaceCaptureManaging, didFailWith error: Error)
}

protocol FaceFrameConsumer: AnyObject {
    func consume(_ frame: FaceFrame)
}

protocol FaceCaptureManaging: AnyObject {
    var delegate: FaceCaptureManagerDelegate? { get set }
    var frameConsumer: FaceFrameConsumer? { get set }
    func start()
    func pause()
}
