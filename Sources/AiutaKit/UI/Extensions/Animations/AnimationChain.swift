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

@_spi(Aiuta) public final class UIViewAnimationChain {
    public final class Loop {
        private(set) var isValid = true
        private var head: UIViewAnimationChain

        fileprivate init(chain: UIViewAnimationChain) {
            head = chain
            each { node in
                node.animationLoop = self
            }
        }

        deinit {
            each { node in
                node.next = nil
            }
        }

        fileprivate func invalidate() {
            isValid = false
            each { node in
                node.animationLoop = nil
                if node.next === head {
                    node.next = nil
                }
            }
        }

        private func each(_ closure: (UIViewAnimationChain) -> Void) {
            var node: UIViewAnimationChain? = head
            var next: UIViewAnimationChain?
            while node != nil {
                next = node?.next
                closure(node!)
                node = next
                if node === head {
                    break
                }
            }
        }
    }

    private var next: UIViewAnimationChain?
    private var root: UIViewAnimationChain?
    private var animationBlock: () -> Void
    private var animationDelay: AsyncDelayTime = .instant
    private var animationDuration: AsyncDelayTime = .quarterOfSecond
    private var animationOptions: UIView.AnimationOptions = []
    private var completionBlock: (() -> Void)?
    private var completionDelay: AsyncDelayTime = .instant
    private weak var animationLoop: Loop?

    init(animation: @escaping () -> Void) {
        animationBlock = animation
    }

    convenience fileprivate init(animation: @escaping () -> Void,
                                 duration: AsyncDelayTime? = nil,
                                 delay: AsyncDelayTime? = nil,
                                 options: UIView.AnimationOptions? = nil,
                                 root: UIViewAnimationChain? = nil
    ) {
        self.init(animation: animation)
        if let duration = duration {
            animationDuration = duration
        }
        if let delay = delay {
            animationDelay = delay
        }
        if let options = options {
            animationOptions = options
        }
        self.root = root
    }

    func next(duration: AsyncDelayTime? = nil,
              after delay: AsyncDelayTime? = nil,
              options: UIView.AnimationOptions? = nil,
              animation: @escaping () -> Void
    ) -> UIViewAnimationChain {
        let chain = UIViewAnimationChain(
                animation: animation,
                duration: duration,
                delay: delay,
                options: options,
                root: root ?? self
        )
        next = chain
        root = nil
        return chain
    }

    func completion(after delay: AsyncDelayTime? = nil,
                    work: @escaping () -> Void
    ) -> UIViewAnimationChain {
        completionDelay = delay ?? .instant
        completionBlock = work
        return self
    }

    func run() {
        let performer = root ?? self
        root = nil
        performer.animate()
    }

    func loop() -> UIViewAnimationChain.Loop {
        next = root ?? self
        run()
        return Loop(chain: next!)
    }

    private func animate() {
        if animationDuration == .instant {
            animationBlock()
            completion()
            return
        }
        UIView.animate(
                withDuration: animationDuration.seconds,
                delay: animationDelay.seconds,
                options: animationOptions,
                animations: animationBlock,
                completion: completion
        )
    }

    private func completion(isFinished: Bool = true) {
        if !isFinished {
            animationLoop?.invalidate()
        }
        if completionDelay == .instant {
            completionInternal()
            return
        }
        delay(completionDelay) {
            self.completionInternal()
        }
    }

    private func completionInternal() {
        completionBlock?()
        next?.animate()
    }
}
