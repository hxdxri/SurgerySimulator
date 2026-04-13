import Foundation

protocol FaceMeshExporting {
    func export(mesh: FaceMesh) throws -> URL
}
