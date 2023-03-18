//
//  ImageView+Extension.swift
//  WaIE
//
//  Created by Anshu Vij on 18/03/23.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
let cacher: OfflineCacher = OfflineCacher(destination: .temporary)

extension UIImageView {
    
    func loadImage(from url: URL) {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if let cachedObject: AstronomyImageData = cacher.load(fileName: Constants.imageFileName),
           let image = UIImage(data: cachedObject.imageData) {
            self.image = image
            return
        }
        DispatchQueue.global().async{
            guard let imageData = try? Data(contentsOf: url) else { return }
            guard let retreivedImage = UIImage(data:imageData) else { return }
            
            imageCache.setObject(retreivedImage, forKey: url.absoluteString as AnyObject)
            
            let customImageData = AstronomyImageData(imageData: imageData)
            cacher.persist(item: customImageData) { url, error in
                if let error = error {
                    print("Object failed to store: \(error)")
                } else {
                    print("Object stored in \(String(describing: url))")
                }
            }
            DispatchQueue.main.async {
                self.image = retreivedImage
            }
        }
    }
}
