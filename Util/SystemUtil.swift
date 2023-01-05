//
//  SystemUtil.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/5.
//

import Foundation
import UIKit

public final class SystemUtil {
    public static let SCREEN_SIZE = UIScreen.main.bounds.size
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
}

public extension UIWindow {
    // xocde 11以後無法作用
    //static let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}
    static var currentWindow: UIWindow? {
        let arrWindow = UIApplication.shared.windows
        for win in arrWindow {
            if win.gestureRecognizers != nil, win.isHidden == false {
                return win
            }
        }
        
        return UIApplication.shared.windows.first
    }
    
    static var topWindow: UIWindow? {
        return UIApplication.shared.windows.last
    }
}

public extension UIScreen {
    static let SIZE: CGSize = UIScreen.main.bounds.size
    static let WIDTH: CGFloat = UIScreen.main.bounds.size.width
    static let HEIGHT: CGFloat = UIScreen.main.bounds.size.height
    
    @available(iOS 11.0, *) static let SAFE_AREA_TOP: CGFloat = UIWindow.currentWindow?.safeAreaInsets.top ?? 0
    @available(iOS 11.0, *) static let SAFE_AREA_BOTTOM: CGFloat = UIWindow.currentWindow?.safeAreaInsets.bottom ?? 0
    
    // 暫存
    @available(iOS 11.0, *) static let WIN0_SAFE_AREA_TOP: CGFloat = UIApplication.shared.windows[0].safeAreaInsets.top
    @available(iOS 11.0, *) static let WIN0_SAFE_AREA_BOTTOM: CGFloat = UIApplication.shared.windows[0].safeAreaInsets.bottom
}

public extension Bundle {
    //Bundle.main.infoDictionary  //取得第三方app bundle
    //Bundle(for: type(of: self)).infoDictionary //取得framework bundle
    //Bundle(identifier: "com.nhi.MHBSdk") //取得framework bundle
    
    var bID: String {
        return object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
    
    var bName: String {
        return object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    var bDisplayName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }

    var bVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    var bBuildVersion: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
}

public func makeAPhoneCall(strPhoneNumber: String) -> Bool {
    var strPhone = strPhoneNumber.replacingOccurrences(of: "#", with: ",")
    strPhone = strPhone.replacingOccurrences(of: "@", with: ",")
    strPhone = strPhone.replacingOccurrences(of: "轉", with: ",")
    strPhone = strPhone.replacingOccurrences(of: "-", with: "")

//    let charSet = NSMutableCharacterSet()
//    charSet.formUnion(with: .whitespaces)
//    charSet.formUnion(with: .punctuationCharacters)
//    charSet.formUnion(with: .symbols)
    
//    let arrayWithNumbers = strPhone.components(separatedBy: charSet as CharacterSet)
//    strPhone = arrayWithNumbers.joined(separator: "")
//    if strPhone == "" {
//        return false
//    }
    
    if let url = URL(string: "telprompt://\(strPhone)"), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    } else {
        return false
    }
}

public extension UIDevice {
    
    func totalDiskSpaceInBytes() -> Int64 {
        do {
            guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
                return 0
            }
            return totalDiskSpaceInBytes
        } catch {
            return 0
        }
    }
    
    func freeDiskSpaceInBytes() -> Int64 {
        do {
            guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as? Int64 else {
                return 0
            }
            return totalDiskSpaceInBytes
        } catch {
            return 0
        }
    }
    
    func usedDiskSpaceInBytes() -> Int64 {
        return totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
    }

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"

            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"

            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Gen"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro 11 Inch 3. Gen"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro 12.9 Inch 3. Gen"
            case "iPad11,1", "iPad11,2":                    return "iPad mini 5th Gen"
            case "iPad11,3", "iPad11,4":                    return "iPad Air 3rd Gen"
                
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
    static let isiPhoneX = UIDevice.modelName.contains("iPhone X") ? true : false
    static let isiPad = UIDevice.modelName.contains("iPad") ? true : false
}
