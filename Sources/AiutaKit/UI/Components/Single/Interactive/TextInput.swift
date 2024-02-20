//
//  Created by nGrey on 02.05.2023.
//

import UIKit

open class TextInput: Content<UITextView> {
    public var didChange: Signal<Void> { proxy.didChange }
    public var onReturn: Signal<Void> { proxy.onReturn }

    public var font: FontRef? {
        didSet {
            guard let font else { return }
            view.font = font.uiFont()
            color = font.color
        }
    }

    public var color: UIColor? {
        get { view.textColor }
        set { view.textColor = newValue }
    }

    public var text: String {
        get { view.text }
        set { view.text = newValue }
    }

    public var contentSize: CGSize { view.contentSize }

    private let proxy = TextInputDelegate()

    public convenience init(_ builder: (_ it: TextInput, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    public required init() {
        super.init()
        configure()
    }

    public required init(view: UITextView) {
        super.init(view: view)
        configure()
    }

    private func configure() {
        view.delegate = proxy
    }

    public func becomeFirstResponder() {
        delay(.custom(0.05)) { [view] in
            view.becomeFirstResponder()
        }
    }

    @discardableResult
    public func resignFirstResponder() -> Bool {
        let result = view.isFirstResponder
        view.resignFirstResponder()
        return result
    }

    public var isFirstResponder: Bool {
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
