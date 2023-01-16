//
//  RestViewController.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/5.
//

import UIKit

class RestViewController: UIViewController {

    var mainTableview = UITableView()
    let noDataV = UIView()
    let noDataImgV = UIImageView()
    var arrRestaurant: [RestaurantVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        mainTableview.delegate = self
        mainTableview.dataSource = self
        mainTableview.register(UINib(nibName: "RestTableViewCell", bundle: nil), forCellReuseIdentifier: "RestTableViewCell")
        setBackBtn()
        navigationItem.title = "餐廳列表"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainTableview.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        self.view.addSubview(mainTableview)
        
        noDataV.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        noDataV.backgroundColor = .white
        self.view.addSubview(noDataV)
        
        noDataImgV.frame = CGRect(x: UIScreen.main.bounds.midX - 150, y: UIScreen.main.bounds.midY - 150, width: 300, height: 300)
        noDataImgV.image = UIImage(named: "NoData")
        noDataV.addSubview(noDataImgV)
        
        if arrRestaurant.count == 0 {
            noDataV.isHidden = false
        }else {
            noDataV.isHidden = true
        }
    }
}

extension RestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RestMapViewController()
        vc.lat = arrRestaurant[indexPath.row].lat
        vc.lng = arrRestaurant[indexPath.row].lng
        vc.name = arrRestaurant[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRestaurant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestTableViewCell", for: indexPath) as! RestTableViewCell
        cell.selectionStyle = .none
        cell.nameLb.text = arrRestaurant[indexPath.row].name
        cell.ratingLb.text = String(arrRestaurant[indexPath.row].rating)
        cell.vicinityLb.text = arrRestaurant[indexPath.row].vicinity
        return cell
    }
}
