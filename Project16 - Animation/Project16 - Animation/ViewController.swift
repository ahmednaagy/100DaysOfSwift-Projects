//
//  ViewController.swift
//  Project16 - Animation
//
//  Created by Ahmed Nagy on 28/03/2021.
//

import UIKit

class ViewController: UIViewController {

    var tapButton: UIButton!
    var imageView: UIImageView!
    var currentAnimation = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 586, y: 384)
        view.addSubview(imageView)
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .orange
        tapButton = UIButton()
        tapButton.setTitle("Tap Here!", for: .normal)
        tapButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        tapButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        tapButton.sizeToFit()
        tapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tapButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

    @objc func buttonTapped() {
        
        tapButton.isHidden = true
//        UIView.animate(withDuration: 1, delay: 0, options: []) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, options: []) {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        } completion: { (finished) in
            self.tapButton.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }

}

