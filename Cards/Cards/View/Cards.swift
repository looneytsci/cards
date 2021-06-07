//
//  Cards.swift
//  Cards
//
//  Created by Дмитрий Головин on 25.05.2021.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set } // Для проверки перевернутых карт
    // completion, выполняется после переворота 2 карт
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    // перевернуть карту
    func flip()
    // перевернут все карты
    func flipAll()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    var cornerRadius = 20
    
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var startTouchPoint: CGPoint!
    
    var color: UIColor!
    private let margin = 10
    lazy var frontSideView: UIView = self.getFrontSideView()
    lazy var backSideView: UIView = self.getBackSideView()
    
    // Загрузка лицевой стороны карты
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(self.bounds.width) - margin * 2, height: Int(self.bounds.height) - margin * 2))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    // загрузка "рубашки" карты
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        return view
    }
    
    // метод переворота одной карты
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop]) { [self] _ in
            self.flipCompletionHandler?(self)
        }
        isFlipped.toggle()
    }
    
    // метод переворота всех карт
    func flipAll() {
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromTop])
        isFlipped.toggle()
    }
    
    // отрисовка карты с обеих сторон
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    // установка рамки для карты
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: Обработка событий
    
    // получаем cgpoint тапа
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        
        startTouchPoint = frame.origin
    }
    
    // двигаем карту за пальцем юзера
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: window) else { return }
        frame.origin.x = touchLocation.x - anchorPoint.x
        frame.origin.y = touchLocation.y - anchorPoint.y
    }
    
    // переворачиваем карту, если было тап, возвращаем карту на место
    // если пользователь свайпом увел карту за рамки
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if frame.origin == startTouchPoint {
            flip()
        }
        
        if frame.origin.x < superview!.safeAreaInsets.left ||
            frame.origin.y < superview!.safeAreaInsets.top + 50 ||
            frame.origin.x > superview!.bounds.width - frame.width ||
            frame.origin.y > superview!.bounds.height - frame.height {
            UIView.animate(withDuration: 0.3) {
                self.frame.origin = self.startTouchPoint
            }
        }
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        setupBorders()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

