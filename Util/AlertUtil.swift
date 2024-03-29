//
//  AlertUtil.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/5.
//

import Foundation
import UIKit

public final class AlertUtil {
    
    public static var strBtnOK = "確認"
    public static var strBtnCancel = "取消"
    
    //MARK: - Toast
    public enum ToastPositionType {
        case bottom
        case top
        case center
    }
    
    public static func showToast(vc: UIViewController,
                                 frameY:CGFloat,
                                 cornerRadius: CGFloat,
                                 message: String,
                                 duration: Double) {
        let lbToast = AlertUtil.createToast(vc: vc, message: message)
        lbToast.layer.cornerRadius = cornerRadius;
        lbToast.frame = CGRect(x: (vc.view.frame.size.width - lbToast.frame.size.width - 25) / 2, y: frameY, width: lbToast.frame.size.width + 25, height: lbToast.frame.size.height + 20)
        
        AlertUtil.toastAnimate(duration: duration, lb: lbToast)
    
    }
    
    public static func showToast(vc: UIViewController,
                                 position: ToastPositionType,
                                 cornerRadius: CGFloat,
                                 message : String,
                                 duration: Double) {
        let lbToast = AlertUtil.createToast(vc: vc, message: message)
        lbToast.layer.cornerRadius = cornerRadius;
        var frameY: CGFloat = 0
        switch position {
        case ToastPositionType.top:
            if #available(iOS 11.0, *) {
                frameY = UIScreen.SAFE_AREA_TOP + 20
            } else {
                frameY = 100
            }
        case ToastPositionType.center:
            frameY = vc.view.frame.size.height/2 - 100
        default: //bottom
            frameY = vc.view.frame.size.height-100
        }
        lbToast.frame = CGRect(x: (vc.view.frame.size.width - lbToast.frame.size.width - 25) / 2 ,
                               y: frameY,
                               width: lbToast.frame.size.width + 25,
                               height: lbToast.frame.size.height + 20)

        AlertUtil.toastAnimate(duration: duration, lb: lbToast)
    }
    
    public static func showToast(vc: UIViewController,
                                 message : String,
                                 duration: Double) {
        let lbToast = AlertUtil.createToast(vc: vc, message: message)
        lbToast.layer.cornerRadius = lbToast.frame.height/2;
        lbToast.frame = CGRect(x: (vc.view.frame.size.width - lbToast.frame.size.width - 25) / 2 ,
                                  y: lbToast.frame.origin.y,
                                  width: lbToast.frame.size.width + 25,
                                  height: lbToast.frame.size.height + 20)

        AlertUtil.toastAnimate(duration: duration, lb: lbToast)
    }
    
    private static func toastAnimate(duration: Double, lb: UILabel){
        var duration = duration
        if duration < 1 {
            duration = 1
        }

        UIView.animate(withDuration: 0.5, delay: duration-0.5, options: .curveEaseOut, animations: {
            lb.alpha = 0.0
        }, completion: {(isCompleted) in
            lb.removeFromSuperview()
        })
    }
    
    private static func createToast(vc: UIViewController,
                                    message: String) -> UILabel {
        let lbToast = UILabel(frame: CGRect(x: 0, y: vc.view.frame.size.height-100, width: UIScreen.main.bounds.width, height: 500))
        vc.view.addSubview(lbToast)
        lbToast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        lbToast.textColor = UIColor.white
        lbToast.textAlignment = .center;
        lbToast.font = UIFont(name: "Montserrat-Light", size: 12.0)
        lbToast.text = message
        lbToast.alpha = 1.0
        lbToast.numberOfLines = 0
        lbToast.clipsToBounds  =  true
        lbToast.sizeToFit()
        
        return lbToast
    }
    
    //MARK: - Alert
    fileprivate static func showMessage(vc: UIViewController,
                                        title: String?,
                                        message: String,
                                        cancelAction: UIAlertAction?,
                                        okAction: UIAlertAction?) -> Void {
        DispatchQueue.main.async{
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.overrideUserInterfaceStyle = .light
            if (cancelAction != nil) {
                alertController.addAction(cancelAction!)
            }
            alertController.addAction(okAction!)
            vc.present(alertController, animated: true, completion: nil)
        }
    }

    public static func showMessage(message: String) -> Void {
        if var topController = UIWindow.currentWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.overrideUserInterfaceStyle = .light
            showMessage(vc: topController, message: message, okHandler: nil)
        }
    }

    public static func showMessage(message: String,
                                   okHandler: ((UIAlertAction?) -> Void)?,
                                   cancelHandler: ((UIAlertAction?) -> Void)?) {
        if var topController = UIWindow.currentWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let cancelAction = UIAlertAction(title: strBtnCancel, style: .cancel, handler: cancelHandler)
            let okAction = UIAlertAction(title: strBtnOK, style: .default, handler: okHandler)
            topController.overrideUserInterfaceStyle = .light
            showMessage(vc: topController, title: nil, message: message, cancelAction: cancelAction, okAction: okAction)
        }
    }

    public static func showMessage(vc: UIViewController,
                                   message: String) -> Void {
        vc.overrideUserInterfaceStyle = .light
        showMessage(vc: vc, message: message, okHandler: nil)
    }
    
    public static func showMessage(vc: UIViewController,
                                   title: String,
                                   message: String,
                                   okHandler: ((UIAlertAction?) -> Void)?,
                                   cancelHandler: ((UIAlertAction?) -> Void)?) {
        let cancelAction = UIAlertAction(title: strBtnCancel, style: .cancel, handler: cancelHandler)
        let okAction = UIAlertAction(title: strBtnOK, style: .default, handler: okHandler)
        vc.overrideUserInterfaceStyle = .light
        showMessage(vc: vc, title: title, message: message, cancelAction: cancelAction, okAction: okAction)
    }

    public static func showMessage(vc: UIViewController,
                                   message: String,
                                   okHandler: ((UIAlertAction?) -> Void)?) {
        let okAction = UIAlertAction(title: strBtnOK, style: .default, handler: okHandler)
        vc.overrideUserInterfaceStyle = .light
        showMessage(vc: vc, title: nil, message: message, cancelAction: nil, okAction: okAction)
    }

    public static func showMessage(vc: UIViewController,
                                   title: String,
                                   message: String,
                                   okTitle: String,
                                   okHandler: ((UIAlertAction?) -> Void)?) {
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        vc.overrideUserInterfaceStyle = .light
        showMessage(vc: vc, title: title, message: message, cancelAction: nil, okAction: okAction)
    }

    public static func showMessage(vc: UIViewController,
                                   title: String,
                                   message: String,
                                   okTitle: String,
                                   okHandler: ((UIAlertAction?) -> Void)?,
                                   cancelTitle: String,
                                   cancelHandler: ((UIAlertAction?) -> Void)?) {
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        vc.overrideUserInterfaceStyle = .light
        showMessage(vc: vc, title: title, message: message, cancelAction: cancelAction, okAction: okAction)
    }
    
    public static func showInputMessage(vc: UIViewController,
                                        title: String,
                                        message: String,
                                        textFieldHandler: ((UITextField?) -> Void)?,
                                        okTitle: String,
                                        okHandler: @escaping ((UIAlertController) -> Void),
                                        cancelTitle: String,
                                        cancelHandler: ((UIAlertAction?) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)

        let okAction = UIAlertAction(title: okTitle, style: .default) { [weak alertController] _ in
            okHandler(alertController!)
        }
        
        alertController.addTextField(configurationHandler: textFieldHandler)
//        alertController.addTextField { textField in
//            textField.placeholder = "Password"
//            textField.isSecureTextEntry = true
//        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
