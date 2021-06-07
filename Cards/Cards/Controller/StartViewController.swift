//
//  StartViewController.swift
//  Cards
//
//  Created by Дмитрий Головин on 25.05.2021.
//

import UIKit

class StartViewController: UIViewController {

    lazy var playButton = getPlayButton()
    lazy var settingsButton = getSettingsButton()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(playButton)
        view.addSubview(settingsButton)
    }
    
    // MARK: Создание UI элементов
    
    private func getPlayButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        button.center.x = view.center.x
        button.center.y = view.center.y
        
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        
        return button
    }
    
    private func getSettingsButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: Int(view.center.y + 60), width: 200, height: 50))
        
        button.center.x = view.center.x
        
        button.setTitle("Настройки", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        
        return button
    }
    
    // MARK: Navigation
    
    @objc func startNewGame(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameVC", sender: self)
    }
    
    @objc func goToSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSettings", sender: self)
    }

}
