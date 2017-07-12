//
//  ViewController.swift
//  SimonSays
//
//  Created by MJ Norona on 7/7/17.
//  Copyright © 2017 MJ Norona. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation
import AVFoundation

class ViewController: UIViewController {
    var tilt = [0,0]
    var motionManager = CMMotionManager()
    var forward = false
    var backward = false
    var left = false
    var right = false
    var tilted = [0,0]
    var value = 1
    var currentMove = 0
    var score = 100
    var colors: [UIColor] = [.red, .yellow, .green, .blue]
    
    @IBOutlet weak var progessLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    //score
    @IBOutlet weak var scoreLabel: UILabel!
    
    //boxes
    @IBOutlet weak var leftBox: UIView!
    @IBOutlet weak var downBox: UIView!
    @IBOutlet weak var upBox: UIView!
    @IBOutlet weak var rightBox: UIView!

    
    //arrow images
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    
    //animation
    var location = CGPoint(x: 0, y: 0)
    
    var timer = Timer()

    var down = 40
    var count = 0
    var arrowList :[UIImageView] = []
    var moveList: [Int] = []
    

    var audioPlayer = AVAudioPlayer()
    var song = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progessLabel.text = ""
        scoreLabel.text = "Score: 100"
        // Do any additional setup after loading the view, typically from a nib.
        do {
            song = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "song", ofType: "mp3")!))
            song.prepareToPlay()
        }
        catch{
            print(error)
        }
        song.volume = 0.2
        song.play()
        self.moveList = [3, 2, 1, 4]
        self.arrowList = [upArrow, rightArrow, upArrow, leftArrow, downArrow]
        self.upArrow.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.2, y: CGFloat(self.down))
        self.downArrow.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.4, y: CGFloat(self.down))
        self.leftArrow.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.6, y: CGFloat(self.down))
        self.rightArrow.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.8, y: CGFloat(self.down))
        
        self.upBox.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.2, y: UIScreen.main.bounds.size.height-self.upBox.frame.size.height*0.5)
        self.downBox.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.4, y: UIScreen.main.bounds.size.height-self.upBox.frame.size.height*0.5)
        self.leftBox.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.6, y: UIScreen.main.bounds.size.height-self.upBox.frame.size.height*0.5)
        self.rightBox.center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.8, y: UIScreen.main.bounds.size.height-self.upBox.frame.size.height*0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1074, execute: {
            self.timerF()
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //sounds
        do {
            audioPlayer = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "bell2", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error)
        }
        
        //gyroscope
        motionManager.gyroUpdateInterval = 0.1
        
    
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                if myData.rotationRate.x > 1.5 {
                    if self.forward == false && self.tilt[0] == 0{
                        self.tilt[0] = self.value
                        self.forward = true
                        if self.value == 1 {
                            self.value = 2
                        } else {
                            self.value = 1
                        }
                    }
                    //print("tilted right")
                } else if myData.rotationRate.x < -1.5 {
                    if self.backward == false && self.tilt[1] == 0{
                        self.tilt[1] = self.value
                        self.backward = true
                        if self.value == 1 {
                            self.value = 2
                        } else {
                            self.value = 1
                        }
                    }
                    
                    //print("tilted left")
                } else if (myData.rotationRate.y > 1.5 ) {
                    if self.right == false && self.tilt[0] == 0{
                        self.tilt[0] = self.value
                        self.right = true
                        if self.value == 1 {
                            self.value = 2
                        } else {
                            self.value = 1
                        }
                    }
                    //print("tilted forward")
                } else if (myData.rotationRate.y < -1.5 ) {
                    if self.left == false && self.tilt[1] == 0{
                        self.tilt[1] = self.value
                        self.left = true
                        if self.value == 1 {
                            self.value = 2
                        } else {
                            self.value = 1
                        }
                    }
                   // print("tilted backward")
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1074, execute: {
            let DDR = Timer.scheduledTimer(timeInterval: (0.4409) * 2,target: self, selector: #selector(self.tiltEval), userInfo: nil, repeats: true)
        })
        
        
        
        
    }
    
//    func sayHello()
//    {
//        NSLog("hello World")
//    }
    
    
    func tiltEval(){
        audioPlayer.play()
        var move = 0
        if (self.forward == true && self.backward == true
            && self.tilt[0] == 2 && self.tilt[1] == 1) {
            move = 1
            print("LEFT")
        } else if (self.forward == true && self.backward == true
                && self.tilt[0] == 1 && self.tilt[1] == 2) {
            move = 4
            print("RIGHT")
        } else if (self.right == true && self.left == true
                && self.tilt[0] == 2 && self.tilt[1] == 1){
            move = 2
            print("DOWN")
        } else if (self.right == true && self.left == true
            && self.tilt[0] == 1 && self.tilt[1] == 2){
            move = 3
            print("UP")
        }
        
        
        print("Current rule: \(self.currentMove), Currentmove: \(move)")
        print("Current move: \(move)")
        if currentMove < 3 {
            currentMove += 1
        } else {
            currentMove = 0
        }
        if move == moveList[self.currentMove] {
            self.score += 10
            scoreLabel.text = "Score: \(self.score)"
            self.backgroundView.backgroundColor = randomColorGen()
            progessLabel.text = "Nice!"
            print("Correct!")
        } else {
            self.score -= 5
            scoreLabel.text = "Score: \(self.score)"
            progessLabel.text = "Miss!"
            print("Miss!")
        }
        
        if score == 0 {
            song.stop()
            let alert = UIAlertController(title: "Game Over", message: "You lose!", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
            
            
        }
        self.forward = false
        self.backward = false
        self.right = false
        self.left = false
        self.tilt = [0,0]
        self.value = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerF(){
        timer = Timer.scheduledTimer(withTimeInterval: (0.4409/12.1), repeats: true, block: {_ in
            
            if self.arrowList[self.count] == self.upArrow {
                self.arrowList[self.count].center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.2, y: CGFloat(self.down))
                self.down += 15
                //print(self.down)
                if self.down >= 400 {
                    if self.count < self.arrowList.count-1{
                        self.down = 40
                        self.count += 1
                    }else{
                        self.count = 0
                    }
                }
                
            }else if self.arrowList[self.count] == self.downArrow {
                self.arrowList[self.count].center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.4, y: CGFloat(self.down))
                self.down += 15
                //print(self.down)
                if self.down >= 400 {
                    if self.count < self.arrowList.count-1{
                        self.down = 40
                        self.count += 1
                    }else{
                        self.count = 0
                    }
                }
                
            }else if self.arrowList[self.count] == self.leftArrow {
                self.arrowList[self.count].center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.6, y: CGFloat(self.down))
                self.down += 15
                //print(self.down)
                if self.down >= 400 {
                    if self.count < self.arrowList.count-1{
                        self.down = 40
                        self.count += 1
                    }else{
                        self.count = 0
                    }
                    
                }
                
            }else if self.arrowList[self.count] == self.rightArrow {
                self.arrowList[self.count].center = CGPoint(x: 0 + UIScreen.main.bounds.size.width*0.8, y: CGFloat(self.down))
                self.down += 15
                //print(self.down)
                if self.down >= 400 {
                    if self.count < self.arrowList.count-1{
                        self.down = 40
                        self.count += 1
                    }else{
                        self.count = 0
                    }
                    
                }
                
            }
            
        })
        
    }
    
    func randomColorGen() -> UIColor{
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    
}

