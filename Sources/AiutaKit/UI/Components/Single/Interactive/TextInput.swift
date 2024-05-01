// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

@_spi(Aiuta) open class TextInput: Content<UITextView> {
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
