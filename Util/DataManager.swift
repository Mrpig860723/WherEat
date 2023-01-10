//
//  DataManager.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/5.
//

import UIKit
import Alamofire

class DataManager: NSObject {

    var location = "25.0376436,121.520085"
    var key = "AIzaSyAnrnbWPavOp3I3LMGPqUa-oj5oKYnKsCg"
    var radius = "1000"
    
    func restaurantList(completedHandle: @escaping (_ completeResult:[RestaurantVO])->(), failHandle: @escaping (_ errMsg: String)->()) {
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location)&type=restaurant&radius=\(radius)&language=zh-TW&key=\(key)"
        let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        AF.request(url, method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON(completionHandler: {response in
            if let json = response.value as? [String:Any],
               let results = json["results"] as? [NSDictionary]{
                var proAry: [RestaurantVO] = []
                for item in results {
                    var vo = RestaurantVO()
                    vo.name = item["name"] as? String ?? ""
                    vo.rating = item["rating"] as? Double ?? 0.0
                    vo.vicinity = item["vicinity"] as? String ?? ""
                    if let geometry = item["geometry"] as? [String:Any],
                       let location = geometry["location"] as? [String:Any]{
                        vo.lat = location["lat"] as? CGFloat ?? 0.00
                        vo.lng = location["lng"] as? CGFloat ?? 0.00
                    }
                    if let photos = item["photos"] as? [NSDictionary],
                       let photo = photos[0] as? [String:Any]{
                        vo.photo = photo["photo_reference"] as? String ?? ""
                    }
                    proAry.append(vo)
                }
               
                completedHandle(proAry)
            }else {
                failHandle("API獲取資料有誤。")
            }
            
        })
    }
    
    func returnPhoto(photo: String) -> String {
        let result = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1024&photoreference=\(photo)&key=\(key)"
        return result
    }
}
