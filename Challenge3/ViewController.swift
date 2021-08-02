//
//  ViewController.swift
//  Challenge3
//
//  Created by Luca Hummel on 19/07/21.
//

import UIKit

class ViewController: UIViewController {
    var allWords = [String]()
    var currentQuestion = [String]()
    var textArray = [String]()
    var tentativasLabel: UILabel!
    var tentativas: Int = 0 {
        didSet {
            tentativasLabel.text = "Tentativas: \(tentativas)"
        }
    }
    
    var showText = ""
    
    var word: UILabel!
    var letterButtons = [UIButton]()
    var alfabeto = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var alfabetoUsado = [String]()
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        word = UILabel()
        word.translatesAutoresizingMaskIntoConstraints = false
        word.text = "PALAVRA"
        word.font = UIFont.systemFont(ofSize: 24)
        word.numberOfLines = 0
        view.addSubview(word)
        
        tentativasLabel = UILabel()
        tentativasLabel.translatesAutoresizingMaskIntoConstraints = false
        tentativasLabel.text = "Tentativas: \(tentativas)"
        tentativasLabel.font = UIFont.systemFont(ofSize: 24)
        tentativasLabel.numberOfLines = 0
        view.addSubview(tentativasLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            tentativasLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tentativasLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            word.topAnchor.constraint(equalTo: tentativasLabel.bottomAnchor, constant: 100),
            word.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: word.bottomAnchor, constant: 300),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
        let width = 50
        let height = 50
        var contagem = 0
        
        for row in 0..<4{
            for column in 0..<7 {
                if contagem == 26 {
                    break
                }
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle(alfabeto[contagem], for: .normal)
                letterButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

                let frame = CGRect(x: column * width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                contagem += 1
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    func loadLevel(action: UIAlertAction! = nil) {
        textArray.removeAll()
        currentQuestion.removeAll()
        word.text = ""
        tentativas = 0


        
        for i in letterButtons {
            i.isHidden = false
            alfabetoUsado.removeAll()
        }
        
        if let fileURL = Bundle.main.url(forResource: "listaPalavras", withExtension: "txt") {
            if let palavraQuestion = try? String(contentsOf: fileURL) {
                allWords = palavraQuestion.components(separatedBy: "\n")
                allWords.shuffle()
                
                for caracter in allWords[Int.random(in: 0..<allWords.count)] {
                    currentQuestion.append(String(caracter))
                    print(currentQuestion)
                    showText += "?"
                    textArray.append("?")
                }
                word.text = showText
            }
        }
    }
    
    func upLevel() {
        if textArray.joined() == currentQuestion.joined() {
            let ac = UIAlertController(title: "Você Conseguiu!", message: "Pronto para a próxima fase?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loadLevel(action:)))
            present(ac, animated: true)
        } else if tentativas == 7 {
            let ac = UIAlertController(title: "Você Perdeu!", message: "A palavra era \(currentQuestion.joined())", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loadLevel(action:)))
            present(ac, animated: true)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
        if currentQuestion.contains(buttonTitle) {
            alfabetoUsado.append(buttonTitle)
            for i in 0..<currentQuestion.count {
                if currentQuestion[i] == buttonTitle {
                    textArray[i] = buttonTitle
                }
            }
        } else {
            tentativas += 1
        }
        word.text = textArray.joined()
        sender.isHidden = true
        upLevel()
    }


}

