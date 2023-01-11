//
//  ViewController.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/4.
//

import UIKit
import CoreLocation
import Kingfisher

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

class ViewController: UIViewController {

    var importRestBtn = UIButton()
    var recordBtn = UIButton()
    var restListBtn = UIButton()
    var diceBtn = UIButton()
    var navigateBtn = UIButton()
    var restImgV = UIImageView()
    var restNameV = UIView()
    var restNameImgV = UIImageView()
    var restNameLb = UILabel()
    var loadV = UIView()
    var loadRollV = UIView()
    var activityV = UIActivityIndicatorView()
    var backGroundImg = UIImageView()
    var arrRestaurant :[RestaurantVO] = []
    var ranInt: Int = 0
    var photoUrl: URL!
    var datamgr: DataManager?
    var locationManager: CLLocationManager?
    var tag = false
    var saveItemArr: [SaveItemVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datamgr = DataManager()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        restImgV.contentMode = .scaleAspectFit
        
        if UserDefaults.standard.value(forKey: "Item") != nil {
            do {
                saveItemArr = try UserDefaults.standard.getObject(forKey: "Item", castTo: [SaveItemVO].self)
                print(saveItemArr)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationController?.isNavigationBarHidden = true
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mainBackGround")!)
        backGroundImg.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        backGroundImg.image = UIImage(named: "mainBackGround")
        self.view.addSubview(backGroundImg)
        
        importRestBtn.frame = CGRect(x: UIScreen.WIDTH - 150, y: 44, width: 150, height: 50)
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
        restImgV.image = UIImage(named: "noRestaurant")
        restImgV.layer.borderColor = UIColor.black.cgColor
        restImgV.layer.borderWidth = 5
        restImgV.layer.cornerRadius = 25
        restImgV.backgroundColor = .white
        self.view.addSubview(restImgV)
        
        restNameV.frame = CGRect(x: UIScreen.main.bounds.midX - UIScreen.WIDTH * 2 / 5, y: restImgV.frame.maxY + 25, width: UIScreen.WIDTH * 4 / 5, height: 80)
        self.view.addSubview(restNameV)
        
        restNameImgV.frame = CGRect(x: 0, y: -5, width: restNameV.frame.width, height: restNameV.frame.height)
        restNameImgV.image = UIImage(named: "restBtn")
        self.restNameV.addSubview(restNameImgV)
        
        restNameLb.frame = restNameV.frame
        restNameLb.text = "目前無餐廳"
        restNameLb.textColor = .black
        restNameLb.textAlignment = .center
        restNameLb.adjustsFontSizeToFitWidth = true
        self.view.addSubview(restNameLb)
        
        diceBtn.frame = CGRect(x: restNameV.frame.minX, y: restNameV.frame.maxY + 25 , width: UIScreen.WIDTH / 3, height: 80)
        diceBtn.setTitle("擲骰", for: .normal)
        diceBtn.setTitleColor(.black, for: .normal)
        diceBtn.setBackgroundImage(UIImage(named: "diceBtn"), for: .normal)
        diceBtn.addTarget(self, action: #selector(tabDice), for: .touchUpInside)
        self.view.addSubview(diceBtn)
        
        navigateBtn.frame = CGRect(x: diceBtn.frame.maxX + 20 , y: diceBtn.frame.minY, width: restNameV.frame.width - diceBtn.frame.width - 20, height: diceBtn.frame.height)
        navigateBtn.setTitle("導航", for: .normal)
        navigateBtn.setTitleColor(.black, for: .normal)
        navigateBtn.setBackgroundImage(UIImage(named: "navigateBtn"), for: .normal)
        navigateBtn.addTarget(self, action: #selector(tabNavigate), for: .touchUpInside)
        self.view.addSubview(navigateBtn)
        
        loadRollV.frame = CGRect(x: UIScreen.main.bounds.midX - 50, y: UIScreen.main.bounds.midY - 50, width: 100, height: 100)
        loadRollV.layer.cornerRadius = 25
        loadRollV.backgroundColor = .white
        loadV.addSubview(loadRollV)
        
        activityV.frame = CGRect(x: 0, y: 0, width: loadRollV.frame.width, height: loadRollV.frame.width)
        activityV.style = .large
        activityV.color = .black
        loadRollV.addSubview(activityV)
        
        loadV.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        loadV.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        loadV.isHidden = true
        self.view.addSubview(loadV)
        
        
        
        
        
        if tag {
            restNameLb.text = arrRestaurant[ranInt].name
            restImgV.kf.setImage(with: photoUrl)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 首次使用 向使用者詢問定位自身位置權限
           if CLLocationManager.authorizationStatus()
                == .notDetermined {
               // 取得定位服務授權
               locationManager!.requestWhenInUseAuthorization()

               // 開始定位自身位置
               locationManager!.startUpdatingLocation()
           }
           // 使用者已經拒絕定位自身位置權限
           else if CLLocationManager.authorizationStatus()
                    == .denied {
               // 提示可至[設定]中開啟權限
               AlertUtil.showMessage(vc: self, title: "定位權限已關閉", message: "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", okTitle: "確認", okHandler: nil)
               // 使用者已經同意定位自身位置權限
           }else if CLLocationManager.authorizationStatus()
                    == .authorizedWhenInUse {
               // 開始定位自身位置
               locationManager!.startUpdatingLocation()
           }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager!.stopUpdatingHeading()
    }
    
    @objc func tabImport() {
        
        AlertUtil.showMessage(message: "匯入餐廳會刷新餐廳列表資訊，確定匯入嗎？") { _ in
            self.loadV.isHidden = false
            self.activityV.startAnimating()
            self.datamgr?.restaurantList(completedHandle: { completeResult in
                self.arrRestaurant = completeResult
                print(self.arrRestaurant)
                self.loadV.isHidden = true
                self.activityV.stopAnimating()
                AlertUtil.showMessage(message: "餐廳匯入成功")
            }, failHandle: { errMsg in
                print(errMsg)
            })
        } cancelHandler: {_ in }
    }
    
    @objc func tabRecord() {
        let vc = RecordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabRestList() {
        let vc = RestViewController()
        vc.arrRestaurant = self.arrRestaurant
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tabNavigate() {
        if arrRestaurant.isEmpty {
            AlertUtil.showMessage(vc: self, message: "目前無餐廳資料", okHandler: nil)
        }else {
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(URL(string:
                                                    "comgooglemaps://?daddr=\(arrRestaurant[ranInt].lat),\(arrRestaurant[ranInt].lng)&directionsmode=walking")!)
            } else {
              print("Can't use comgooglemaps://");
            }
        }
    }
    
    @objc func tabDice() {
        if arrRestaurant.isEmpty {
            AlertUtil.showMessage(vc: self, message: "目前無餐廳資料", okHandler: nil)
        }else {
            ranInt = Int.random(in: 0 ... arrRestaurant.count - 1)
            photoUrl = URL(string: datamgr?.returnPhoto(photo: arrRestaurant[ranInt].photo) ?? "")
            restNameLb.text = arrRestaurant[ranInt].name
            restImgV.kf.setImage(with: photoUrl)
            restImgV.contentMode = .scaleToFill
            restImgV.layer.masksToBounds = true
            tag = true
            
            if saveItemArr.count > 19 {
                saveItemArr.removeFirst()
            }
            
            var saveItem = SaveItemVO()
            saveItem.name = arrRestaurant[ranInt].name
            saveItem.photo = datamgr?.returnPhoto(photo: arrRestaurant[ranInt].photo) ?? ""
            saveItem.date = getDate()
            saveItemArr.append(saveItem)
            print(saveItemArr)
            do {
                try UserDefaults.standard.setObject(saveItemArr, forKey: "Item")
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getDate() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_tw")
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
      didUpdateLocations locations: [CLLocation]) {
        let currentLocation :CLLocation =
              locations[0] as CLLocation
     
        //自身
        let myLocation = currentLocation.coordinate
        datamgr?.location = "\(myLocation.latitude),\(myLocation.longitude)"
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
