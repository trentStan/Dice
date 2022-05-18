//
//  Indigo.swift
//  navTest
//
//  Created by IACD-022 on 2022/05/05.
//

import UIKit
import FirebaseFirestore

class Indigo: UIViewController {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var dieRes1: UILabel!
    
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var dieRes2: UILabel!
    
    let rollDelay = 2
    
    let db = Firestore.firestore()
    
    
    var random: [UIImage] = []
    var history: [Int] = []
    let diceImages = ["dice1","dice2","dice3","dice4","dice5","dice6"]
    var dice: [UIImage] = []
    @IBOutlet var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in diceImages{
            dice.append(UIImage(named: x)!)
        }
        var randomDie1 = (count: Int.random(in: 0...diceImages.count - 1), name: "")
        randomDie1.name = diceImages[randomDie1.count]
        
        var randomDie2 = (count: Int.random(in: 0...diceImages.count - 1), name: "")
        randomDie2.name = diceImages[randomDie2.count]
        
        imageView1.image = UIImage(named: randomDie1.name)
        imageView2.image = UIImage(named: randomDie2.name)
        
        dieRes1.text = String(randomDie1.count + 1)
        dieRes2.text = String(randomDie2.count + 1)
        let result = randomDie1.count + 1 + randomDie2.count + 1
        // history.append(result)
        total.text = String(result)
        
        
    }
    
    @IBAction func rollDice(_ sender: UIButton) {
        animate()
        sender.isEnabled = false
        var randomDie1 = (count: Int.random(in: 0...diceImages.count - 1), name: "")
        randomDie1.name = diceImages[randomDie1.count]
        
        var randomDie2 = (count: Int.random(in: 0...diceImages.count - 1), name: "")
        randomDie2.name = diceImages[randomDie2.count]
        
        
        
        imageView1.image = UIImage(named: randomDie1.name)
        imageView2.image = UIImage(named: randomDie2.name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let docRef = self.db.collection("Dice")
            docRef.document("Result").getDocument { (document, error) in
                if let data = document, data.exists {
                    
                    var set: [Int]?
                    if data.data()!.count > 0 {
                        set = (data.data()!["History"]! as! [Int])
                    } else{
                        set = []
                    }
                    
                    self.history = set!
                    self.dieRes1.text = String(randomDie1.count + 1)
                    self.dieRes2.text = String(randomDie2.count + 1)
                    self.total.text = String(randomDie1.count + 1 + randomDie2.count + 1)
                    let result = randomDie1.count + 1 + randomDie2.count + 1
                    self.history.append(result)
                    sender.isEnabled = true
                    if self.history.count > 15 {
                        self.history.removeFirst(1)
                    }
                    docRef.document("Result").setData(["History": self.history])
                } else {
                    print("Document does not exist")
                }
            }
            
            
           
            
            
        }
        
        
    }
    
    @IBAction func goToHistory(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "History") as? Orange{
            //vc.history = self.history
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func animate(){
        
        imageView1.animationImages = dice
        imageView1.animationDuration = 1
        imageView1.animationRepeatCount = 2
        
        
        imageView2.animationImages = dice
        imageView2.animationDuration = 1
        imageView2.animationRepeatCount = 2
        
        imageView1.startAnimating()
        imageView2.startAnimating()
        
        
    }
    
}
