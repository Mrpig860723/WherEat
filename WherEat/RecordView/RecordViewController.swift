//
//  RecordViewController.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/5.
//

import UIKit
import Kingfisher

class RecordViewController: UIViewController {

    let mainTableView = UITableView()
    let noDataV = UIView()
    let noDataImgV = UIImageView()
    var saveItemArr: [SaveItemVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        navigationItem.title = "餐廳紀錄"

        mainTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
        
        if UserDefaults.standard.value(forKey: "Item") != nil {
            do {
                saveItemArr = try UserDefaults.standard.getObject(forKey: "Item", castTo: [SaveItemVO].self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        self.view.addSubview(mainTableView)
        
        noDataV.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        noDataV.backgroundColor = .white
        self.view.addSubview(noDataV)
        
        noDataImgV.frame = CGRect(x: UIScreen.main.bounds.midX - 50, y: UIScreen.main.bounds.midY - 50, width: 100, height: 100)
        noDataImgV.image = UIImage(named: "")
        noDataV.addSubview(noDataImgV)
        
        
        if saveItemArr.count == 0 {
            noDataV.isHidden = false
        }else {
            noDataV.isHidden = true
        }
    }

    

}

extension RecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension RecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        cell.selectionStyle = .none
        cell.restImgV.kf.setImage(with: URL(string: saveItemArr[indexPath.row].photo))
        cell.restImgV.layer.cornerRadius = 20
        cell.restImgV.contentMode = .scaleAspectFill
        cell.restNameLb.text = saveItemArr[indexPath.row].name
        cell.dateLb.text = saveItemArr[indexPath.row].date
        return cell
    }


}
