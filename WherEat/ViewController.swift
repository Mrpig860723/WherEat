//
//  ViewController.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/4.
//

import UIKit

class ViewController: UIViewController {

    var importRestBtn = UIButton()
    var recordBtn = UIButton()
    var restListBtn = UIButton()
    var diceBtn = UIButton()
    var navigateBtn = UIButton()
    var restImgV = UIImageView()
    var restNameV = UIView()
    var restNameLb = UILabel()
    
    var arrRestaurant :[RestaurantVO] = []
    var ranInt: Int = 0
    var datamgr: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datamgr = DataManager()

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        importRestBtn.frame = CGRect(x: UIScreen.SIZE.width - 150, y: UIScreen.SAFE_AREA_TOP, width: 150, height: 80)
        importRestBtn.setTitle("匯入附近餐廳", for: .normal)
        importRestBtn.setTitleColor(.black, for: .normal)
        importRestBtn.titleLabel?.font.withSize(20)
        importRestBtn.addTarget(self , action: #selector(tabImport), for: .touchUpInside)
        self.view.addSubview(importRestBtn)
        
        recordBtn.frame = CGRect(x: 0, y: UIScreen.SIZE.height - 100 , width: 100, height: 50)
        recordBtn.setTitle("紀錄", for: .normal)
        recordBtn.setTitleColor(.red, for: .normal)
        recordBtn.addTarget(self, action: #selector(tabRecord), for: .touchUpInside)
        self.view.addSubview(recordBtn)
        
        restListBtn.frame = CGRect(x: UIScreen.SIZE.width - 100, y: UIScreen.SIZE.height - 100, width: 100, height: 50)
        restListBtn.setTitle("餐廳列表", for: .normal)
        restListBtn.setTitleColor(.black, for: .normal)
        restListBtn.addTarget(self, action: #selector(tabRestList), for: .touchUpInside)
        self.view.addSubview(restListBtn)
        
        restImgV.frame = CGRect(x: UIScreen.main.bounds.midX - UIScreen.WIDTH * 2 / 5, y: UIScreen.main.bounds.midY - UIScreen.HEIGHT / 4 , width: UIScreen.WIDTH * 4 / 5, height: UIScreen.HEIGHT / 4)
        restImgV.image = UIImage(named: "")
        self.view.addSubview(restImgV)
        
        navigateBtn.frame = restImgV.frame
        navigateBtn.titleLabel?.text = ""
        navigateBtn.addTarget(self, action: #selector(tabNavigate), for: .touchUpInside)
        self.view.addSubview(navigateBtn)
        
        restNameV.frame = CGRect(x: UIScreen.main.bounds.midX - UIScreen.WIDTH / 3, y: restImgV.frame.maxY + 25, width: UIScreen.WIDTH * 2 / 3, height: 50)
        restNameV.backgroundColor = .green
        restNameV.layer.cornerRadius = 25
        self.view.addSubview(restNameV)
        
        restNameLb.frame = restNameV.frame
        restNameLb.text = "目前無餐廳"
        restNameLb.textColor = .black
        restNameLb.textAlignment = .center
        restNameLb.adjustsFontSizeToFitWidth = true
        self.view.addSubview(restNameLb)
        
        diceBtn.frame = CGRect(x: UIScreen.main.bounds.midX - UIScreen.WIDTH / 6, y: restNameV.frame.maxY + 25 , width: UIScreen.WIDTH / 3, height: 50)
        diceBtn.setTitle("擲骰", for: .normal)
        diceBtn.setTitleColor(.black, for: .normal)
        diceBtn.backgroundColor = .green
        diceBtn.layer.cornerRadius = 25
        diceBtn.addTarget(self, action: #selector(tabDice), for: .touchUpInside)
        self.view.addSubview(diceBtn)
        
        
        
        
        
    }
    
    @objc func tabImport() {
        datamgr?.restaurantList(completedHandle: { completeResult in
            self.arrRestaurant = completeResult
            print(self.arrRestaurant)
        }, failHandle: { errMsg in
            print(errMsg)
        })
    }
    
    @objc func tabRecord() {
        let vc = RecordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabRestList() {
        let vc = RestViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabNavigate() {
        if arrRestaurant.isEmpty {
            AlertUtil.showMessage(vc: self, message: "目前無餐廳資料", okHandler: nil)
        }else {
            let vc = NavigateViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func tabDice() {
        if arrRestaurant.isEmpty {
            AlertUtil.showMessage(vc: self, message: "目前無餐廳資料", okHandler: nil)
        }else {
            ranInt = Int.random(in: 0 ... arrRestaurant.count - 1)
            restNameLb.text = arrRestaurant[ranInt].name
            
        }
    }

}

