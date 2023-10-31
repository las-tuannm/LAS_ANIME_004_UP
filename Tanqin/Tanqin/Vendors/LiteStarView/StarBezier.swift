import UIKit

func starBezier(superView:UIView,x:CGFloat) -> UIBezierPath{
    
    let numberOfPoints: CGFloat = 5 // Number of points
    let starRatio: CGFloat = 0.5 // How deep should the innerRadius be
    let steps: CGFloat = numberOfPoints * 2
    
    // Calculate Radius
    let outerRadius: CGFloat = min(superView.frame.height, superView.frame.width) / 2
    let innerRadius: CGFloat = outerRadius * starRatio
    
    // Start with first position on top
    var currentAngle = -CGFloat.pi / 2
    // Calculate how much we need to move with each star corner
    let angleAdjustment = CGFloat.pi * CGFloat(2) / CGFloat(steps)
    
    var firstPoint:CGPoint?
    let center = CGPoint(x: x, y: superView.bounds.midY)
    
    let bezierPath = UIBezierPath()
    
    for i in 0..<Int(steps) {
        // divisable evenly use innerRadius other use outerRadius
        let radius = i % 2 == 0 ? outerRadius : innerRadius
        // get x,y position of star point
        let x = radius * cos(currentAngle) + center.x
        let y = radius * sin(currentAngle) + center.y
        
        if i == 0 {
            // only move once to first position
            bezierPath.move(to: CGPoint(x: x, y: y))
            firstPoint = CGPoint(x:x,y:y) // keep track of firstPoint
        }else{
            // add line to next position
            bezierPath.addLine(to: CGPoint(x: x, y: y))
        }
        
        if i == Int(steps - 1){
            // complete bezier using first position
            bezierPath.addLine(to: firstPoint!)
        }
        // update currentAngle
        currentAngle += angleAdjustment
    }
    bezierPath.close()
    return bezierPath
}
