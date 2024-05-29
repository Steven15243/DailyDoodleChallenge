import Foundation
import SwiftUI

struct SavedDoodle: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var imageName: String
}

class StorageManager {
    static let shared = StorageManager()

    private let savedDoodlesKey = "savedDoodles"

    func saveDoodle(_ doodle: SavedDoodle, image: UIImage) {
        guard let data = image.pngData() else { return }
        let url = getDocumentsDirectory().appendingPathComponent(doodle.imageName)
        try? data.write(to: url)
        
        var savedDoodles = getSavedDoodles()
        savedDoodles.append(doodle)
        saveDoodles(savedDoodles)
    }

    func loadImage(withName name: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

    func getSavedDoodles() -> [SavedDoodle] {
        if let data = UserDefaults.standard.data(forKey: savedDoodlesKey),
           let doodles = try? JSONDecoder().decode([SavedDoodle].self, from: data) {
            return doodles
        }
        return []
    }

    private func saveDoodles(_ doodles: [SavedDoodle]) {
        if let data = try? JSONEncoder().encode(doodles) {
            UserDefaults.standard.set(data, forKey: savedDoodlesKey)
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
