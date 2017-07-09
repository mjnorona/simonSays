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
    @IBOutlet weak var redBox: UIView!
    var motionManager = CMMotionManager()
    var forward = false
    var backward = false
    var left = false
    var right = false
    var tilted = [0,0]
    var value = 1
    
    
    

    var audioPlayer = AVAudioPlayer()
    var song = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    print("tilted right")
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
                    
                    print("tilted left")
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
                    print("tilted forward")
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
                    print("tilted backward")
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.11, execute: {
            let DDR = Timer.scheduledTimer(timeInterval: 0.44047788,target: self, selector: #selector(self.tiltEval), userInfo: nil, repeats: true)
        })
        
        
        
        
    }
    
    func sayHello()
    {
        NSLog("hello World")
    }
    
    
    func tiltEval(){
        
        if (self.forward == true && self.backward == true
            && self.tilt[0] == 2 && self.tilt[1] == 1) {
            print("LEFT")
        } else if (self.forward == true && self.backward == true
                && self.tilt[0] == 1 && self.tilt[1] == 2) {
            print("RIGHT")
        } else if (self.right == true && self.left == true
                && self.tilt[0] == 2 && self.tilt[1] == 1){
            print("BACKWARD")
        } else if (self.right == true && self.left == true
            && self.tilt[0] == 1 && self.tilt[1] == 2){
            print("FORWARD")
        } else {
            print("not tilted")
        }
        audioPlayer.play()
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

    
}

