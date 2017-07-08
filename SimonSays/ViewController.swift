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

class ViewController: UIViewController {
    var tilt = [0,0]
    @IBOutlet weak var redBox: UIView!
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.gyroUpdateInterval = 0.3

        
        var value = 1
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let myData = data {
                
                if myData.rotationRate.x > 2{//forward motion
                    if value == 1 {
                        self.tilt[0] = value
                        value = 2
                    } else {
                        self.tilt[0] = value
                        value = 1
                        print ("You tilted forward")
                        print("current tilt: \(self.tilt)")
                    }

                }
                else if myData.rotationRate.x < -2 { //backward motion
                    if value == 1 {
                        
                        self.tilt[1] = value
                        value = 2
                    } else {
                        self.tilt[1] = value
                        value = 1
                        print ("You tilted back")
                        print("current tilt: \(self.tilt)")
                    }
                }
                
                print(self.tilt)
            }
        }
        
        let helloWorldTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.tiltEval), userInfo: nil, repeats: true)
        
        
        
    }
    
    func sayHello()
    {
        NSLog("hello World")
    }
    
    
    func tiltEval(){
        if self.tilt[0] == 1 && self.tilt[1]  == 2 {
            print(2)
        } else if self.tilt[0] == 2 && self.tilt[1] == 1 {
            print(1)
        } else {
            print(3)
        }
        self.tilt = [0,0]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

