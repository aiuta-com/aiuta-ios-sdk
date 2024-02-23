//
//  Created by nGrey on 02.05.2023.
//

import UIKit

class TextInput: Content<UITextView> {
    var didChange: Signal<Void> { proxy.didChange }
    var onReturn: Signal<Void> { proxy.onReturn }

    var font: FontRef? {
        didSet {
            guard let font else { return }
            view.font = font.uiFont()
            color = font.color
        }
    }

    var color: UIColor? {
        get { view.textColor }
        set { view.textColor = newValue }
    }

    var text: String {
        get { view.text }
        set { view.text = newValue }
    }

    var contentSize: CGSize { view.contentSize }

    private let proxy = TextInputDelegate()

    convenience init(_ builder: (_ it: TextInput, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    required init() {
        super.init()
        configure()
    }

    required init(view: UITextView) {
        super.init(view: view)
        configure()
    }

    private func configure() {
        view.delegate = proxy
    }

    func becomeFirstResponder() {
        delay(.custom(0.05)) { [view] in
            view.becomeFirstResponder()
        }
    }

    @discardableResult
    func resignFirstResponder() -> Bool {
        let result = view.isFirstResponder
        view.resignFirstResponder()
        return result
    }

    var isFirstResponder: Bool {
        view.isFirstResponder
    }
}

private final class TextInputDelegate: NSObject, UITextViewDelegate {
    let didChange = Signal<Void>()
    let onReturn = Signal<Void>()

    func textViewDidChange(_ textView: UITextView) {
        didChange.fire()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !onReturn.observers.isEmpty else { return true }
        if text == "\n" {
            onReturn.fire()
            return false
        }
        return true
    }
}
