//
//  UIImage+Extension.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


extension UIImage {
    
    enum AssetIdentifier: String {
        case name = "name"
      }
    
    convenience init?(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }    
}

extension UIImage {
    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}

enum ImageQuality: CGFloat {
    case lowest = 0.0
    case low = 0.25
    case medium = 0.5
    case high = 0.75
    case highest = 1.0
}

extension UIImage {
    
    enum IDImage: String {
        case imageFront = "image_front.jpg"
        case imageBack = "image_back.jpg"
    }
    
    func compressedData(_ quality: ImageQuality) -> Data? {
        return jpegData(compressionQuality: quality.rawValue)
    }
    
    static func saveImageInDocumentDirectory(image: UIImage?, fileName: String) {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else { return }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image?.jpegData(compressionQuality: 1) {
            try? imageData.write(to: fileURL, options: .atomic)
            return
        } else if image == nil {
            try? FileManager.default.removeItem(at: fileURL)
        }
        return
    }

    static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else { return nil }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
}
