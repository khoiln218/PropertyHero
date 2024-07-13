//
//  UINavigationBar+.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/17/23.
//

import UIKit

class UINavigationBarGradientView: UIView {

    private weak var gradientLayer: CAGradientLayer!

    convenience init(colors: [UIColor], angle: Double = 0.0, locations: [NSNumber] = [0, 1]) {
        self.init(frame: .zero)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        set(colors: colors, angle: angle, locations: locations)
        backgroundColor = .clear
    }

    func set(colors: [UIColor], angle: Double = 0.0, locations: [NSNumber] = [0, 1]) {
        let x: Double! = angle / 360.0
        let a = pow(sinf(Float(2.0 * Double.pi * ((x + 0.75) / 2.0))),2.0);
            let b = pow(sinf(Float(2*Double.pi*((x+0.0)/2))),2);
            let c = pow(sinf(Float(2*Double.pi*((x+0.25)/2))),2);
            let d = pow(sinf(Float(2*Double.pi*((x+0.5)/2))),2);
            
        self.gradientLayer.endPoint = CGPoint(x: CGFloat(c),y: CGFloat(d))
        self.gradientLayer.startPoint = CGPoint(x: CGFloat(a),y:CGFloat(b))
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
    }

    func setupConstraints() {
        guard let parentView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
        parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientLayer else { return }
        gradientLayer.frame = frame
        superview?.addSubview(self)
    }
}

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor],
                               angle: Double = 0.0,
                               locations: [NSNumber] = [0, 1]) {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else {
            let gradientView = UINavigationBarGradientView(colors: colors, angle: angle, locations: locations)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        gradientView.set(colors: colors, angle: angle, locations: locations)
    }
    
    func removeGradientBackground() {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else { return }
        gradientView.removeFromSuperview()
    }
}
