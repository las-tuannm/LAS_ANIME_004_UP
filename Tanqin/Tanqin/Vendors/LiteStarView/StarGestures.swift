import UIKit

extension StarView {
    @objc func starGestureTap(recognizer: UITapGestureRecognizer){
        userRating(location: recognizer.location(in: self).x)
    }
    
    @objc func starGesturePanned(recognizer: UIPanGestureRecognizer) {
        userRating(location: recognizer.location(in: self).x)
    }
    
    private func userRating(location:CGFloat){
        var fraction = Float(location / bounds.height)
        if fraction.isLess(than: 0.0) {return}
        if Int(fraction) > starCount {return}
        
        if Int(fraction) != Int(rating){
            hapticFeedback.impactOccurred()
        }
        
        if roundRating{
            fraction = fraction.rounded()
        }
        if fraction > Float(starCount) {
            rating = CGFloat(starCount)
        }else{
            rating = CGFloat(fraction)
        }
        
    }
}
