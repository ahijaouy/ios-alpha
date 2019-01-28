//
//  ViewController.swift
//  ios-alpha
//
//  Created by Andre Hijaouy on 1/16/19.
//  Copyright © 2019 Mobile Apps & Services. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let lowerBound = 1
    let upperBound = 100
    var numberToGuess: Int!
    var numberOfGuesses = 0
    
    @IBOutlet weak var mylabel: UILabel!
    @IBOutlet weak var myfield: UITextField!
    @IBAction func submitButton(_ sender: Any) {
        if let guess = myfield.text {
            if let guessInt = Int(guess) {
                numberOfGuesses = numberOfGuesses + 1
                validateGuess(guessInt)
            }
        }
    }
    
    func validateGuess(_ guess: Int) {
        if guess < lowerBound || guess > upperBound {
            showBoundsAlert()
        } else if guess < numberToGuess {
            mylabel.text = "Higher! ⬆️"
        } else if guess > numberToGuess {
            mylabel.text = "Lower! ⬇️"
        } else {
            // You win yay!
            showWinAlert()
            mylabel.text = "Guess the Number" // reset the label before restart game
            numberOfGuesses = 0
            generateRandomNumber()
        }
        myfield.text = "" // reset textField after guess so you don't have to delete previous guess
    }
    
    
    func generateRandomNumber() {
        numberToGuess = Int(arc4random_uniform(100)) + 1
    }
    
    func showBoundsAlert() {
        let alert = UIAlertController(title: "Hey!", message: "Your guess should be between 1 and 100!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWinAlert() {
        let alert = UIAlertController(title: "Congrats! 🎉", message: "You won with a total of \(numberOfGuesses) guesses", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomNumber()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

