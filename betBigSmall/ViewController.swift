//
//  ViewController.swift
//  betBigSmall
//
//  Created by 董禾翊 on 2022/10/5.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerMoneyLable: UILabel!
    @IBOutlet weak var betLable: UILabel!
    @IBOutlet weak var bigSmallControl: UISegmentedControl!
    @IBOutlet var diceViews: [UIImageView]!
    @IBOutlet weak var startBetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
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
            let controler = UIAlertController(title: "本金不足！", message: "請重試！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            controler.addAction(okAction)
            present(controler, animated: true)
        }
        
    }
    //開始按鈕
    @IBAction func startBtn(_ sender: Any) {
        //先判斷是否押注完成，未完成，跳出警告
        if startBetBtn.alpha == 1{
            let controller = UIAlertController(title: "抱歉!", message: "您尚未押注，無法進行遊戲", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            controller.addAction(okAction)
            present(controller, animated: true)
        }else{
            for index in 0...2{
                        let diceNumber = diceNumbers.randomElement()!
                        diceViews[index].image = UIImage(named: "dice\(diceNumber)")
                
                        diceTotal += diceNumber
                    }
                    if bigSmallControl.selectedSegmentIndex == 0 {
                        if diceTotal < 11 {
                            let controller = UIAlertController(title: "哎呀！", message: "\(diceTotal)點小，輸了\(bet)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default)
                            controller.addAction(okAction)
                            present(controller, animated: true)
                            bet = 0
                        }else{
                            let controller = UIAlertController(title: "恭喜！", message: "\(diceTotal)點大，贏了\(bet)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default)
                            controller.addAction(okAction)
                            present(controller, animated: true)
                            bet *= 2
                        }
                    }else if bigSmallControl.selectedSegmentIndex == 1{
                        if diceTotal < 11 {
                            let controller = UIAlertController(title: "恭喜！", message: "\(diceTotal)點小，贏了\(bet)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default)
                            controller.addAction(okAction)
                            present(controller, animated: true)
                            bet *= 2
                        }else{
                            let controller = UIAlertController(title: "哎呀！", message: "\(diceTotal)點大，輸了\(bet)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default)
                            controller.addAction(okAction)
                            present(controller, animated: true)
                            bet = 0
                        }
                    }
                    playerMoney += bet
                    bet = 0
                    playerMoneyLable.text = "＄：\(playerMoney)"
                    betLable.text = "下注：\(bet)"
                    startBetBtn.alpha = 1
                    cancelBtn.alpha = 1
                    diceTotal = 0
        }
        
    }
    
}

