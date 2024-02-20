//
// Created by nGrey on 27.02.2023.
//

import UIKit
import Toast
import Resolver

open class ToastBuilder {
    private var title: String
    private var subTitle: String?
    private var displayTime: TimeInterval
    private var attachView: UIView?
    @Injected private var ds: DesignSystem

    public init(_ title: String, subTitle: String? = nil, displayTime: TimeInterval = 1, attachTo attachView: UIView? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.displayTime = displayTime
        self.attachView = attachView
    }

    open var view: ToastView {
        let toastTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: ds.font.default.uiFont() as Any,
            NSAttributedString.Key.kern: ds.font.default.kern,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        let toastSubTitle = NSMutableAttributedString(string: subTitle ?? "", attributes: [
            NSAttributedString.Key.font: ds.font.default.uiFont()?.withSize(10) as Any,
            NSAttributedString.Key.kern: ds.font.default.kern,
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        return AppleToastView(
                child: TextToastView(toastTitle, subtitle: subTitle == nil ? nil : toastSubTitle),
                darkBackgroundColor: .white,
                lightBackgroundColor: .white
        )
    }

    open var configuration: ToastConfiguration {
        ToastConfiguration(
                direction: .top,
                autoHide: true,
                enablePanToClose: false,
                displayTime: displayTime,
                animationTime: 0.2,
                attachTo: attachView
        )
    }
}
