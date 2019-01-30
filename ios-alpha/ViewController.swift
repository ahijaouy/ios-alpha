//
//  ViewController.swift
//  ios-alpha
//
//  Created by Andre Hijaouy on 1/16/19.
//  Copyright © 2019 Mobile Apps & Services. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UITableViewDataSource  {
    let lowerBound = 1
    let upperBound = 100
    var numberToGuess: Int!
    var numberOfGuesses = 0
    var leaders = ["Andre", "Devany", "Vinu", "Rhea", "Alex"]
    var db: Firestore!
    var leaderboardRef: CollectionReference!
    var data: [String] = []
    
    @IBOutlet weak var mylabel: UILabel!
    @IBOutlet weak var myfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomNumber()
        
        initFirebase()
        loadLeaderboard()
        
//        for i in 0...5 {
//            data.append("\(i)")
//        }
        
        tableView.dataSource = self
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        tableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = data[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    func initFirebase() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func loadLeaderboard() {
        leaderboardRef = db.collection("leaderboard")
        leaderboardRef.order(by: "score").limit(to: 5).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let nickname = document.data()["nickname"]!
                    let score = document.data()["score"]!
//                    self.data.append("temp")
                    self.data.append("\(nickname): \(score)")
                }
                print(self.data)
                
            }
        }
        
//        tableView.reloadData()
        
        
    }
    
    // Make an API call to create a new entry in leader board
    func addToLeaderboard(_ nickname: String, score: Int) {
        var ref: DocumentReference? = nil
        ref = db.collection("leaderboard").addDocument(data: [
            "nickname": nickname,
            "score": score
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
    }
    
    // handle submit button
    @IBAction func submitButton(_ sender: Any) {
        if let guess = myfield.text {
            if let guessInt = Int(guess) {
                numberOfGuesses = numberOfGuesses + 1
                validateGuess(guessInt)
            }
        }
    }
    
    // takes a guess and takes proper action
    func validateGuess(_ guess: Int) {
        if guess < lowerBound || guess > upperBound {
            showBoundsAlert()
        } else if guess < numberToGuess {
            mylabel.text = "Higher! ⬆️"
        } else if guess > numberToGuess {
            mylabel.text = "Lower! ⬇️"
        } else {
            // You win yay!
            showWinAlert(numberOfGuesses)
            mylabel.text = "Guess the Number"
            numberOfGuesses = 0
            generateRandomNumber()
        }
        myfield.text = ""
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
    
    func showWinAlert(_ score: Int) {
        let alert = UIAlertController(title: "Congrats! 🎉", message: "You won with a total of \(numberOfGuesses) guesses. Please enter a nickname for the leaderboard", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play again", style: .default) {
            (alertaction) in
            let textfield = alert.textFields![0] as UITextField
            let nickname: String = textfield.text!
            self.addToLeaderboard(nickname, score: score)
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nickname"
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    



}

