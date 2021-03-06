//
//  CustomButton.swift
//  Сalculator
//
//  Created by Евгений Таракин on 01.11.2021.
//

import UIKit
import SnapKit

protocol CustomButtonDelegate: AnyObject {
    func addNumber(_ stringNumber: CustomButton.TypeButton)
    func addPoint()
    func displayResault()
    func chooseFunctional(_ function: CustomButton.TypeButton)
    func chooseAdditionalFunctional(_ additionalfunction: CustomButton.TypeButton)
}

class CustomButton: UIView {
   
    enum TypeButton: String, CaseIterable {
        case deletionState1 = "AC"
        case deletionState2 = "C"
        
        case percent = "%"
        case invertion = "+/-"
        case division = "/"
        
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case multiplication = "*"

        case four = "4"
        case five = "5"
        case six = "6"
        case substraction = "-"

        case one = "1"
        case two = "2"
        case three = "3"
        case addition = "+"

        case zero = "0"
        case point = ","
        case receive = "="
        
        var backgrondColor: UIColor {
            switch self {
            case .division, .multiplication, .substraction, .addition, .receive:
                return .systemOrange
            case .deletionState1, .deletionState2, .invertion, .percent:
                return .systemGray
            default:
                return .systemGray3
            }
        }
        
        var font: UIFont {
            switch self {
            case .division, .multiplication, .substraction, .addition, .receive:
                return .boldSystemFont(ofSize: 35)
            default:
                return .boldSystemFont(ofSize: 40)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .deletionState1, .deletionState2, .invertion, .percent:
                return .black
            default:
                return .white
            }
        }
    }
    
    // MARK: Проперти СustomButton
    private var typeButton: TypeButton?

    weak var delegate: CustomButtonDelegate?
    
    private let backView: UIView = {
        let view = UIView()
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = nil
        button.backgroundColor = . clear
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Инициализация СustomButton
    init(frame: CGRect, typeButton: TypeButton) {
        super.init(frame: frame)
        self.typeButton = typeButton
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: Добавление constraint'ов
    func commonInit() {
        guard let typeButton = typeButton else { return }
        
        backgroundColor = .white

        text = typeButton.rawValue
        label.font = typeButton.font
        label.textColor = typeButton.textColor
        
        backView.backgroundColor = typeButton.backgrondColor
        
        addSubview(backView)
        addSubview(label)
        addSubview(button)

        backView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 2
        backView.layer.cornerRadius = layer.cornerRadius
        
        clipsToBounds = true
    }
    
    // MARK: Добавление действия СustomButton
    @objc func tapButton() {
        playAnimation()
        
        guard let typeButton = typeButton else { return }
        switch typeButton {
        case .point:
            delegate?.addPoint()
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            delegate?.addNumber(typeButton)
        case .receive:
            delegate?.displayResault()
        case .addition, .substraction, .multiplication, .division:
            delegate?.chooseFunctional(typeButton)
        case .deletionState1, .deletionState2, .invertion, .percent:
            delegate?.chooseAdditionalFunctional(typeButton)
        }
        
    }
    
    // MARK: Анимация при нажатии на CustomButton
    private func playAnimation() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")

        switch typeButton {
        case .division, .multiplication, .substraction, .addition, .receive:
            animation.fromValue = UIColor.systemOrange.cgColor
            animation.toValue = UIColor.systemOrange.withAlphaComponent(0.3).cgColor
        case .deletionState1, .invertion, .percent:
            animation.fromValue = UIColor.systemGray.cgColor
            animation.toValue = UIColor.systemGray.withAlphaComponent(0.7).cgColor
        default:
            animation.fromValue = UIColor.systemGray3.cgColor
            animation.toValue = UIColor.systemGray3.withAlphaComponent(0.7).cgColor
        }

        animation.duration = 0.1
        animation.repeatCount = 1
        backView.layer.add(animation, forKey: "backgroundColor")
    }
    
}
