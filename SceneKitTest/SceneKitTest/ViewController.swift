//
//  ViewController.swift
//  SceneKitTest
//
//  Created by Alex on 9/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import WebKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let API_KEY = "ba3ee3150714a055100f2aacbb61fab3"

    var nodesAdded = false
    var lastZPos: Float = 0.0
    var titleLabel: UILabel = UILabel()
//    var billSwitch: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        

        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        self.sceneView.scene = scene
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        //Creating the title label
        titleLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 150, y: 30, width: 300, height: 20))
        
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20.0)
        titleLabel.text = "Select Action"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        
    
        //Creating the balance button
        let balanceButton = UIButton(type: .custom)
        //self.view.frame.maxY
        balanceButton.frame = CGRect(x: 15, y: self.view.frame.maxY - 82, width: 68, height: 68)
        balanceButton.setImage(UIImage(named: "Balances"), for: .normal)
        balanceButton.setImage(UIImage(named: "Balances Selected"), for: .selected)
        balanceButton.addTarget(self, action: #selector(ViewController.showBalance), for: .touchUpInside)
        
        view.addSubview(balanceButton)
        
        //tbillSwitcher
//        billSwitch = UIButton(type: .custom)
//        billSwitch.frame = CGRect(x: self.view.frame.maxX - 135, y: self.view.frame.minY + 80, width: 120, height: 50)
//        billSwitch.setImage(UIImage(named: "NessBux1"), for: .normal)
//
//        view.addSubview(billSwitch)
        
        
        
        //Creating the purchases button
        let purchasesButton = UIButton(type: .custom)
    
        purchasesButton.frame = CGRect(x: 112, y: self.view.frame.maxY - 82, width: 68, height: 68)
        purchasesButton.setImage(UIImage(named: "Purchases"), for: .normal)
        purchasesButton.setImage(UIImage(named: "Purchases Selected"), for: .selected)
        purchasesButton.addTarget(self, action: #selector(ViewController.showPurchases), for: .touchUpInside)
        
        view.addSubview(purchasesButton)
        
        //Creating the compare button
        let compareButton = UIButton(type: .custom)
        
        compareButton.frame = CGRect(x:209, y: self.view.frame.maxY - 82, width: 68, height: 68)
        compareButton.setImage(UIImage(named: "Compare"), for: .normal)
        compareButton.setImage(UIImage(named: "Compare Selected"), for: .selected)
        compareButton.addTarget(self, action: #selector(ViewController.showCompare), for: .touchUpInside)
        
        view.addSubview(compareButton)
        
    }
    
    @objc
    func showBalance() {
        if nodesAdded {
            //remove all of them
            self.removeChildrenNodes()
            nodesAdded = false
            self.titleLabel.text = "Please Select Action"
//            self.billSwitch.isHidden = true
        } else {
            nodesAdded = true
//            self.billSwitch.isHidden = false
            //        print("---------- SHOW BALANCE ----------")
            //Creating the table
            let rectGeo = SCNBox(width: 0.3, height: 0.75, length: 0.05, chamferRadius: 0.0) //length was 0.6, height was 0.06
            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0) // Dark Brown Table UIColor(red: 0.30, green: 0.17, blue: 0.14, alpha: 1.0)
            let rect = SCNNode(geometry: rectGeo)
            
            rect.eulerAngles.x = -.pi / 2
            //rect.eulerAngles.y = -.pi / 5
            
            rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
            sceneView.scene.rootNode.addChildNode(rect)
            
            //End of adding and creating the table
            _ = getAccountNames(completion: { (output: [String]) in
                print("There are \(output.count) accounts.")
                print("Account Name: \(output[0])")
                print("Account Balance: \(output[1])")
                
                let acctBalanace = Double(output[1])
                self.addMoneyForAmount(amt: acctBalanace!, title: "")
                //            self.addMoneyForAmount(amt: 21, title: "")
                
            })
        }

    }
    
    @objc
    func showPurchases() {
        if nodesAdded {
            //remove all of them
            self.removeChildrenNodes()
            nodesAdded = false
            self.titleLabel.text = "Select Action"
        } else {
            nodesAdded = true
            
//            self.billSwitch.isHidden = true
            
            self.titleLabel.text = "Last Two Purchases"
            
            //Creating the table
            let rectGeo = SCNBox(width: 0.3, height: 0.75, length: 0.05, chamferRadius: 0.0) //length was 0.6, height was 0.06
            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0) // Dark Brown Table UIColor(red: 0.30, green: 0.17, blue: 0.14, alpha: 1.0)
            let rect = SCNNode(geometry: rectGeo)
            
            rect.eulerAngles.x = -.pi / 2
            //rect.eulerAngles.y = -.pi / 5
            
            rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
            sceneView.scene.rootNode.addChildNode(rect)
            
            _ = getPurchases(completion: { (output: [Double]) in
                print("There are \(output.count) purchases in the account.")
                print("Total amount spent: \(output.reduce(0, +))")
                
                //grab output
                let amountOfPurchase1 = output[3]
                let amountOfPurchase2 = output[4]

                print("amt1 = \(amountOfPurchase1) \namt2 = \(amountOfPurchase2)")

                
                self.addMoneyForAmount(amt: amountOfPurchase1, title: "")
                self.addMoneyForAmount(amt: amountOfPurchase2, title: "2P")
//                self.addMoneyForAmount(amt: amountOfPurchase3, title: "2P")
                //loop throught the purchases and then output the results
                
                //show the last two purchases
            })

        }
        
        
    }
    
    @objc
    func showCompare() {
        if nodesAdded {
            //remove all of them
            self.removeChildrenNodes()
            nodesAdded = false
            self.titleLabel.text = "Select Action"
        } else {
            nodesAdded = true
            
//            billSwitch.isHidden = true
            
            self.titleLabel.text = "Deposits vs. Withdrawls"
            
            //Creating the table
            let rectGeo = SCNBox(width: 0.3, height: 0.75, length: 0.05, chamferRadius: 0.0) //length was 0.6, height was 0.06
            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0) // Dark Brown Table UIColor(red: 0.30, green: 0.17, blue: 0.14, alpha: 1.0)
            let rect = SCNNode(geometry: rectGeo)
            
            rect.eulerAngles.x = -.pi / 2
            //rect.eulerAngles.y = -.pi / 5
            
            rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
            sceneView.scene.rootNode.addChildNode(rect)
            
            _ = getWithdrawls(completion: { (totalWithdrawlAmt: Double) in
                print("Total Amount of withdrawls is: $\(totalWithdrawlAmt)")
                
                //draw the orange bills with the table
                self.addOrangeMoneyForAmount(amt: totalWithdrawlAmt)
            })
            
            _ = getDeposits(completion: { (totalDepositAmt: Double) in
                print("Total Amount of deposits is: $\(totalDepositAmt)")
                
                //draw the green bills normally
                self.addMoneyForAmount(amt: totalDepositAmt, title: "")
            })
        }
    
        
        
        
    }
    
    
    
    func addMoneyForAmount(amt: Double, title:String) {
        //figuring out how much cash to stack
        var dollars = Int(amt)
        let purchaseCashIndicator:Double = Double(dollars) + 0.5
        
        if (Double(dollars) >= purchaseCashIndicator) {
            dollars += 1
        }
        var highestYPos:Float = 0.00
        var zPos:Float = -0.25
        if title == "2P" {

            zPos += lastZPos

            print("zPos with 2P: \(zPos)")
        }
        var yPos = -0.070
        var numDollar = 0
        for dollar in stride(from: 0, to: dollars, by: 1) {
    
            //z & y position to vary
            if dollar % 200 == 0 {
                numDollar += 200
                
                if dollar == 0 {
                    zPos = -0.25
                    if title == "2P" {
                        zPos += -0.15
//                        zPos += -0.15
                    }
                    numDollar = 0
                }
                
            } else {
                yPos = -0.070 + (Double((dollar - numDollar)) * 0.00130) //was 0.0130
            }
        
//            let yPos = -0.070 + (Double(dollar) * 0.0130)
            
            //end of stack or last dollar
            if ((dollar % 200 == 0) && (dollar != 0)) || (dollar == dollars - 1)  {
                print("Top of the stack!")
                let moneyScene = SCNScene(named: "NessieBucks.dae", inDirectory: "art.scnassets")
                let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
                moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
                //y: was -0.070
                moneyNode?.simdWorldPosition = simd_float3(x: 0.0 - 0.03, y: Float(yPos), z: Float(zPos + 0.014)) //was -0.5 //z was -0.35
                sceneView.scene.rootNode.addChildNode(moneyNode!)
                zPos -= 0.05 //was 0.125
                yPos = -0.070
                
                //zPos will be shifted -0.15
                lastZPos = zPos

            } else {
                let moneyGeo = SCNBox(width: 0.0267, height: 0.06, length: 0.0009, chamferRadius: 0.0) //width was 0.05 //not height  //length was 0.01
                //width 0.1     height 0.06
                moneyGeo.firstMaterial?.diffuse.contents = UIColor(red:0.35, green:0.53, blue:0.46, alpha:1.00) //UIColor(red: 0.20, green: 0.26, blue: 0.16, alpha: 1.0)
                let moneyNode = SCNNode(geometry: moneyGeo)
    
                moneyNode.eulerAngles.x = -.pi / 2
                moneyNode.eulerAngles.y = -.pi / 2
                
                moneyNode.simdWorldPosition = simd_float3(x: 0.0, y: Float(yPos), z: Float(zPos)) //was -0.5 //z was -0.35
                sceneView.scene.rootNode.addChildNode(moneyNode)
            }
            
            
            highestYPos = Float(yPos)
        }
        

        //eventually we will add the purchase title over top the cash
    }
    
    
    func addOrangeMoneyForAmount(amt: Double) {
        //figuring out how much cash to stack
        var dollars = Int(amt)
        let purchaseCashIndicator:Double = Double(dollars) + 0.5
        
        if (Double(dollars) >= purchaseCashIndicator) {
            dollars += 1
        }
        var highestYPos:Float = 0.00
        var zPos:Float = -0.45 //was -0.25
        var yPos = -0.070
        var numDollar = 0
        for dollar in stride(from: 0, to: dollars, by: 1) {
            //            let moneyScene = SCNScene(named: "", inDirectory: "art.scnassets")
            //            let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
            //            moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
            //            let moneyGeo = SCNBox(width: 0.1, height: 0.06, length: 0.01, chamferRadius: 0.0) //width was 0.05
            //            moneyGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.20, green: 0.26, blue: 0.16, alpha: 1.0)
            //            let moneyNode = SCNNode(geometry: moneyGeo)
            
            //            moneyNode?.eulerAngles.x = -.pi / 2
            
            
            //z & y position to vary
            if dollar % 200 == 0 {
                numDollar += 200
                
                if dollar == 0 {
                    zPos = -0.45 //was -0.25
                    numDollar = 0
                }
                
            } else {
                yPos = -0.070 + (Double((dollar - numDollar)) * 0.00130) //was 0.0130
            }
            
            //            let yPos = -0.070 + (Double(dollar) * 0.0130)
            
            //end of stack or last dollar
            if ((dollar % 200 == 0) && (dollar != 0)) || (dollar == dollars - 1)  {
                print("Top of the stack!")
                let moneyScene = SCNScene(named: "NessieOrange.dae", inDirectory: "art.scnassets") //change the nessie bucks to the orange one
                let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
                moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
                //y: was -0.070
                moneyNode?.simdWorldPosition = simd_float3(x: 0.0 - 0.03, y: Float(yPos), z: Float(zPos + 0.014)) //was -0.5 //z was -0.35
                sceneView.scene.rootNode.addChildNode(moneyNode!)
                zPos -= 0.05 //was 0.125
                yPos = -0.070
                
                //zPos will be shifted -0.15
                lastZPos = zPos
                
            } else {
                let moneyGeo = SCNBox(width: 0.0267, height: 0.06, length: 0.0009, chamferRadius: 0.0) //width was 0.05 //not height  //length was 0.01
                //width 0.1     height 0.06
                //change to the orange color
                moneyGeo.firstMaterial?.diffuse.contents = UIColor(red:0.95, green:0.61, blue:0.29, alpha:1.00) //UIColor(red: 0.20, green: 0.26, blue: 0.16, alpha: 1.0)
                let moneyNode = SCNNode(geometry: moneyGeo)
                
                moneyNode.eulerAngles.x = -.pi / 2
                moneyNode.eulerAngles.y = -.pi / 2
                
                moneyNode.simdWorldPosition = simd_float3(x: 0.0, y: Float(yPos), z: Float(zPos)) //was -0.5 //z was -0.35
                sceneView.scene.rootNode.addChildNode(moneyNode)
            }
            
            
            highestYPos = Float(yPos)
        }
    }
//
//    func add100MoneyForAmount(amt: Double) {
//        //figuring out how much cash to stack
//        var dollars = Int(amt)
//        let purchaseCashIndicator:Double = Double(dollars) + 0.5
//
//        if (Double(dollars) >= purchaseCashIndicator) {
//            dollars += 1
//        }
//        var highestYPos:Float = 0.00
//        var zPos:Float = -0.25
//
//        var yPos = -0.070
//        var numDollar = 0
//
//        let amt100bills = amt / 100
//
//
//
//        for dollar in stride(from: 0, to: amt100bills, by: 1) {
//
//            let moneyScene = SCNScene(named: "Nessie100", inDirectory: "art.scnassets")
//            let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
//            moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
//            //y: was -0.070
//            moneyNode?.simdWorldPosition = simd_float3(x: 0.0 - 0.03, y: Float(yPos), z: Float(zPos + 0.014)) //was -0.5 //z was -0.35
//            sceneView.scene.rootNode.addChildNode(moneyNode!)
//            zPos -= 0.05 //was 0.125
//            yPos = -0.070
//
////            yPos = -0.070 + (Double((dollar - amt100bills)) * 0.00130) //was 0.0130
//
////            //z & y position to vary
////            if dollar % 200 == 0 {
////                numDollar += 200
////
////                if dollar == 0 {
////                    zPos = -0.25
////                    numDollar = 0
////                }
////
////            } else {
////                yPos = -0.070 + (Double((dollar)) * 0.00130) //was 0.0130
////            }
////
////            //            let yPos = -0.070 + (Double(dollar) * 0.0130)
//
//            //end of stack or last dollar
//
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    /** NESSIE API WRAPPER **/
    func getAccountNames(completion: @escaping (_ accountNames: [String]) -> Void) -> [String] {
        let url = URL(string: "http://api.reimaginebanking.com/customers/59bc89a8a73e4942cdafdcdd/accounts?key=" + API_KEY)
        
        var output = [String]()
        
        
        let task = URLSession.shared.dataTask(with: url!){
            (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    // now you have a top-level json dictionary
                    for account in json {
                        for key in account {
                            if (key.key == "nickname") {
                                output.append(key.value as! String)
                            } else if (key.key == "balance") {
                                let balance = key.value as! Double
                                output.append("\(balance)")
                            }
                        }
                    }
                }
                completion(output)
            } catch let error as NSError {
                print("error: \(error)")
                completion([String]())
            }
        }
        task.resume()
        return output
    }
    
    func getPurchases(completion: @escaping (_ purchaseTotal: [Double]) -> Void) -> [Double] {
        let url = URL(string: "http://api.reimaginebanking.com/accounts/59bc89aaa73e4942cdafdce1/purchases?key=" + API_KEY)
        
        var outputAmount = [Double]()
        
        let task = URLSession.shared.dataTask(with: url!){
            (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    // now you have a top-level json dictionary
                    for purchase in json {
                        for key in purchase {
                            if(key.key == "amount") {
                                let value = key.value
                                outputAmount.append(value as! Double)
                            }
                        }
                    }
                }
                completion(outputAmount)
            } catch let error as NSError {
                print("error: \(error)")
                completion(outputAmount)
            }
        }
        task.resume()
        return outputAmount
    }
    
    func getWithdrawls(completion: @escaping (_ totalWithdrawlAmt: Double) -> Void) -> Double {
        let url = URL(string: "http://api.reimaginebanking.com/accounts/59bc89aaa73e4942cdafdce1/withdrawals?key=" + API_KEY)
        
        var totalAmt = 0.0
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    for obj in json {
                        for key in obj {
                            if(key.key == "amount") {
                                let amt = key.value as! Double
                                totalAmt += amt
                            }
                        }
                    }
                }
                completion(totalAmt)
            } catch let error as NSError {
                print("error: \(error)")
                completion(0.0)
            }
        }
        task.resume()
        return totalAmt
    }
    
    func getDeposits(completion: @escaping (_ totalDepositAmt: Double) -> Void) -> Double {
        let url = URL(string: "http://api.reimaginebanking.com/accounts/59bc89aaa73e4942cdafdce1/deposits?key=" + API_KEY)
        
        var totalAmt = 0.0
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    for obj in json {
                        for key in obj {
                            if(key.key == "amount") {
                                let amt = key.value as! Double
                                totalAmt += amt
                            }
                        }
                    }
                }
                completion(totalAmt)
            } catch let error as NSError {
                print("error: \(error)")
                completion(0.0)
            }
        }
        task.resume()
        return totalAmt
    }
    
    
    /** END NESSIE API WRAPPER **/
    
    
    func removeChildrenNodes() {
        let children = self.sceneView.scene.rootNode.childNodes
        for child in children {
            child.removeFromParentNode()
        }
    }
}
