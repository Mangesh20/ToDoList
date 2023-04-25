//
//  CircularProgressView.swift
//  ToDoList
//
//  Created by mangesht on 21/04/23.
//

import Foundation
import UIKit


enum ProgressType {
    case delete
    case done
    
    var color: UIColor {
        switch self {
        case .delete:
            return UIColor(red: 0.85, green: 0.22, blue: 0.16, alpha: 1.0) // Dark red
        case .done:
            return UIColor(red: 0.12, green: 0.63, blue: 0.33, alpha: 1.0) // Dark green
        }
    }
}

class CircularProgressView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    private let progressAnimationKey = "progressAnimationKey"
    
    private var imageIcon = UIImageView()
    
    var isDone: Bool = true {
        didSet {
            shapeLayer.strokeColor = isDone ? ProgressType.done.color.cgColor : ProgressType.delete.color.cgColor
            let imageName = isDone ? "checkmark.circle" : "trash"
            imageIcon.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
            imageIcon.tintColor = isDone ? ProgressType.done.color : ProgressType.delete.color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        
        // Add blur effect view as subview
        addSubview(visualEffectView)
        visualEffectView.alpha = 0.7
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return effectView
    }()
    
    private func setupLayers() {
        let lineWidth: CGFloat = 4
        let center = CGPoint(x: 40, y: bounds.midY)
        let radius: CGFloat = 30 //min(bounds.width, bounds.height) / 2 - lineWidth / 2
        
        // Create progress path
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -.pi / 2, endAngle: .pi * 2 - .pi / 2, clockwise: true)
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .butt
        shapeLayer.strokeEnd = 0
        
        imageIcon.image = UIImage(systemName: "checkmark.circle")
        imageIcon.contentMode = .scaleAspectFit
        addSubview(imageIcon)
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            imageIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageIcon.heightAnchor.constraint(equalToConstant: 40),
            imageIcon.widthAnchor.constraint(equalToConstant: 40)
        ])
        // Add layers
        layer.addSublayer(shapeLayer)
    }
    
    func setProgress(_ progress: CGFloat) {
        if progress == 1 {
            // Show checkmark when progress is complete
            showCheckmark()
        } else {
            // Hide checkmark if progress is not complete
            //     hideCheckmark()
        }
        
        // Animate progress
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.2
        animation.fromValue = shapeLayer.strokeEnd
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.strokeEnd = progress
        shapeLayer.add(animation, forKey: progressAnimationKey)
    }
    
    func showCheckmark() {
        shapeLayer.isHidden = false
        imageIcon.isHidden = false
        visualEffectView.isHidden = false
        
    }
    
    func hideCheckmark() {
        //        checkmarkLayer.isHidden = true
        //        checkmarkLayer.removeAllAnimations()
    }
    
    func reset() {
        shapeLayer.strokeEnd = 0.0
        imageIcon.isHidden = true
        visualEffectView.isHidden = true
    }
    
}
