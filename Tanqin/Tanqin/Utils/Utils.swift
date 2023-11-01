//
//  Utils.swift
//  Tanqin
//
//  Created by HaKT on 27/09/2023.
//

import Foundation
import UIKit
import AVFoundation

class Utils {
    
    static func getThumbnailImage(from videoURL: URL, completion: @escaping((UIImage?, URL) -> Void)) {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = CMTime(value: 1, timescale: 100)
        generator.requestedTimeToleranceBefore = CMTime(value: 1, timescale: 100)
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: .zero)]) { _, cgImage, _, _, _ in
            guard let cgImage = cgImage else {
                completion(nil, videoURL)
                return
            }
            completion(UIImage(cgImage: cgImage), videoURL)
        }
    }
    
    static func getThumbnailImage(from videoURL: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = CMTime(value: 1, timescale: 100)
        generator.requestedTimeToleranceBefore = CMTime(value: 1, timescale: 100)
        generator.maximumSize = CGSize(width: 400, height: 400)
        var thumbnailImage: UIImage?
        
        do {
            let cgImage = try generator.copyCGImage(at: CMTime(value: 1, timescale: 100), actualTime: nil)
            thumbnailImage = UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail image: \(error.localizedDescription)")
        }
        
        return thumbnailImage
    }
}

public func readString(fileName: String) -> String? {
    do {
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            let savedText = try String(contentsOf: fileURL)
            return savedText
        }
        return nil
    } catch {
        return nil
    }
}

public func writeString(aString: String, fileName: String) {
    do {
        
        if let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: fileURL.absoluteString){
                FileManager.default.createFile(atPath: fileURL.absoluteString, contents: nil, attributes: nil)
            }
            try aString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    } catch {
        print("\(error)")
    }
}
