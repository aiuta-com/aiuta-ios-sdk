//
//  Created by nGrey on 23.11.2023.
//

import UIKit

open class ResultBulletin<T>: PlainBulletin {
    let onResult = Signal<T>()

    open var defaultResult: T { fatalError() }

    override func setupInternal() {
        willDismiss.subscribe(with: self) { [unowned self] in
            if onResult.fireCount == 0 {
                onResult.fire(defaultResult)
            }
        }
    }

    public func returnResult(_ result: T) {
        onResult.fire(result)
        delay(.moment) { [weak self] in
            self?.dismiss()
        }
    }

    public func assignResult(_ result: T, with signal: Signal<Void>) {
        signal.subscribe(with: self) { [unowned self] in
            returnResult(result)
        }
    }
}
