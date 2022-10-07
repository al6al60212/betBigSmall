//
//  ViewController.swift
//  betBigSmall
//
//  Created by 董禾翊 on 2022/10/5.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var playerMoneyLable: UILabel!
    @IBOutlet weak var betLable: UILabel!
    @IBOutlet weak var bigSmallControl: UISegmentedControl!
    @IBOutlet var diceViews: [UIImageView]!
    @IBOutlet weak var startBetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var player: AVPlayer?
    //骰子點數
    let diceNumbers = Array(1...6)
    //下注金額
    var bet = 0
    //玩家本金
    var playerMoney = 3000
    //骰子總點數
    var diceTotal = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        betLable.text = "下注：\(bet)"
        playerMoneyLable.text = "＄：\(playerMoney)"
    }
    //跳出訊息的Function
    func addAlert(title: String, message: String, btnTitle: String = "OK"){
        let controler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: btnTitle, style: .default)
        controler.addAction(okAction)
        present(controler, animated: true)
    }
    //加入選轉動畫的Function
    func addAnimation(diceImageView: UIImageView){
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi * 4
        rotateAnimation.duration = 0.5
        diceImageView.layer.add(rotateAnimation, forKey: nil)
    }
    //加入音效的Function
    func voice(){
        let url = Bundle.main.url(forResource: "骰子聲", withExtension: "mp3")!
        player = AVPlayer(url: url)
        player?.play()
    }
    
    //確定押注
    @IBAction func startBet(_ sender: Any) {
        //確定下注，玩家本金扣除下注金額
        playerMoney = playerMoney - bet
        //並隱藏押注和取消按鈕
        startBetBtn.alpha = 0
        cancelBtn.alpha = 0
        //顯示玩家剩餘本金
        playerMoneyLable.text = "＄：\(playerMoney)"
    }
    //取消（用於玩家下錯籌碼時）
    @IBAction func cancel(_ sender: Any) {
        bet = 0
        betLable.text = "下注：\(bet)"
    }
    //籌碼按鈕
    @IBAction func chipsBtns(_ sender: UIButton) {
        //判斷本金不得小於下注籌碼
        if bet + sender.tag <= playerMoney{
            bet = bet + sender.tag
            betLable.text = "下注：\(bet)"
        }else{
            //小於時，跳出警告視窗
            addAlert(title: "本金不足！", message: "請重試！")
        }
        
    }
    //All In
    @IBAction func allInBtn(_ sender: UIButton) {
        bet = playerMoney
        betLable.text = "下注：\(bet)"
    }
    
    //開始按鈕
    @IBAction func startBtn(_ sender: Any) {
        var resultTitle = ""
        var resultMessage = ""
        //先判斷是否押注完成，未完成，跳出警告
        if startBetBtn.alpha == 1{
            addAlert(title: "抱歉!", message: "您尚未押注，無法進行遊戲")
        }else{
            voice()
            //迴圈產生隨機點數
            for diceView in diceViews{
                addAnimation(diceImageView: diceView)
                let diceNumber = diceNumbers.randomElement()!
                    diceView.image = UIImage(named: "dice\(diceNumber)")
                        //計算骰子總點數
                        diceTotal += diceNumber
            }
            //玩家賭大的情況
            if bigSmallControl.selectedSegmentIndex == 0 {
                //小於11點判斷為輸
                if diceTotal < 11 {
                    resultTitle = "哎呀！"
                    resultMessage = "\(diceTotal)點小，輸了\(bet)"
                    bet = 0
                }else{
                    //大於等於11判斷為贏
                    resultTitle = "恭喜！"
                    resultMessage = "\(diceTotal)點大，贏了\(bet)"
                    bet *= 2
                }
                
            //玩家賭小的情況
            }else if bigSmallControl.selectedSegmentIndex == 1{
                //小於11點判斷為贏
                if diceTotal < 11 {
                    resultTitle = "恭喜！"
                    resultMessage = "\(diceTotal)點小，贏了\(bet)"
                    bet *= 2
                }else{
                    //大於等於11點判斷為輸
                    resultTitle = "哎呀！"
                    resultMessage = "\(diceTotal)點大，輸了\(bet)"
                    bet = 0
                }
            }
            
            playerMoney += bet
            
            //判斷玩家本金歸零時顯示破產，並重新開始
            if playerMoney == 0 {
                addAlert(title: "GAME OVER", message: "\(resultMessage)!破產了QQ！", btnTitle: "重新開始")
                playerMoney = 3000
            }else{
                addAlert(title: resultTitle, message: resultMessage)
            }
            
            //每局結束，賭金歸零，更新玩家本金，顯示押注和取消按鈕，重計骰子總點數
            bet = 0
            playerMoneyLable.text = "＄：\(playerMoney)"
            betLable.text = "下注：\(bet)"
            startBetBtn.alpha = 1
            cancelBtn.alpha = 1
            diceTotal = 0
        }
        
    }
    
}

