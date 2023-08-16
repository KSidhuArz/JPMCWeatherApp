import Foundation
import UIKit

/*saving image in cache with image and url key*/
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    /*check if image already downloaded if yes then fetching image from cache otherwise downloading image and saving in cache*/
    func loadWeatherImage(from url:URL, completion: @escaping() -> ()){
        if let cacheIconImage = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.image = cacheIconImage
            }
            completion()
            return
        } else {
            getImageData(from: url) { data, urlResponse, error in
                if let imageData = data{
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                        if let iconImage = self.image {
                            imageCache.setObject(iconImage, forKey: url.absoluteString as NSString)
                        } else {
                            imageCache.setObject(UIImage(named: "no_Image")!, forKey: url.absoluteString as NSString)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = UIImage(named: "no_Image")
                    }
                }
                completion()
            }
        }
    }
}
