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

@_spi(Aiuta) import AiutaKit

final class AiutaCollageView: Plane {
    var inputs: Aiuta.Inputs? {
        didSet {
            guard oldValue != inputs else { return }

            guard let inputs else {
                imageViews.indexed.forEach { i, it in
                    guard i == 0 else {
                        it.source = nil
                        it.view.isVisible = false
                        return
                    }

                    it.contentMode = .center
                    it.image = ds.image.sdk(.aiutaPlaceholder)
                    it.view.isVisible = true
                }

                counter.count = 0
                return
            }

            switch inputs {
                case let .capturedImages(capturedImages):
                    imageViews.indexed.forEach { i, it in
                        guard i < capturedImages.count else {
                            it.source = nil
                            it.view.isVisible = false
                            return
                        }

                        it.contentMode = .scaleAspectFill
                        it.image = capturedImages[i]
                        it.view.isVisible = true
                    }
                case let .uploadedImages(uploadedImages):
                    imageViews.indexed.forEach { i, it in
                        guard i < uploadedImages.count else {
                            it.source = nil
                            it.view.isVisible = false
                            return
                        }

                        it.contentMode = .scaleAspectFill
                        it.source = uploadedImages[i]
                        it.view.isVisible = true
                    }
            }

            counter.count = count
            parent?.updateLayoutRecursive()
        }
    }

    var imageViews: [Image] {
        findChildren()
    }

    var desiredQuality: ImageQuality = .hiResImage {
        didSet { imageViews.forEach { $0.desiredQuality = desiredQuality } }
    }

    let counter = CounterView()

    var count: Int {
        guard let inputs else { return 0 }
        switch inputs {
            case let .capturedImages(capturedImages): return capturedImages.count
            case let .uploadedImages(uploadedImages): return uploadedImages.count
        }
    }

    override func setup() {
        view.clipsToBounds = true

        for i in 0 ..< 4 {
            addContent(Image { it, _ in
                it.desiredQuality = desiredQuality
                it.contentMode = .scaleAspectFill
                it.view.clipsToBounds = true
                it.contentMode = .center
                it.image = ds.image.sdk(.aiutaPlaceholder)
                it.view.isVisible = i == 0
                it.view.backgroundColor = ds.color.lightGray
            })
        }

        counter.bringToFront()

        inputs = nil
    }

    override func updateLayout() {
        switch count {
            case 0 ... 1: layout1()
            case 2: layout2()
            case 3: layout3()
            default: layout4()
        }

        counter.layout.make { make in
            make.top = counter.style == .normal ? 12 : 8
            make.left = make.top
        }
    }

    private func layout1() {
        imageViews.indexed.forEach { _, v in
            v.layout.make { make in
                make.inset = 0
            }
        }
    }

    private func layout2() {
        imageViews.indexed.forEach { i, v in
            v.layout.make { make in
                make.top = 0
                make.bottom = 0
                make.left = i == 0 ? 0 : layout.width / 2
                make.right = i == 0 ? layout.width / 2 : 0
            }
        }
    }

    private func layout3() {
        imageViews.indexed.forEach { i, v in
            switch i {
                case 0: v.layout.make { make in
                        make.top = 0
                        make.bottom = 0
                        make.left = 0
                        make.right = layout.width / 2
                    }
                case 1: v.layout.make { make in
                        make.left = layout.width / 2
                        make.right = 0
                        make.top = 0
                        make.bottom = layout.height / 2
                    }
                default: v.layout.make { make in
                        make.left = layout.width / 2
                        make.right = 0
                        make.top = layout.height / 2
                        make.bottom = 0
                    }
            }
        }
    }

    private func layout4() {
        imageViews.indexed.forEach { i, v in
            v.layout.make { make in
                make.width = layout.width / 2
                make.height = layout.height / 2
                make.left = i.isOdd ? 0 : layout.width / 2
                make.top = i < 2 ? 0 : layout.height / 2
            }
        }
    }

    convenience init(_ builder: (_ it: AiutaCollageView, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

extension AiutaCollageView {
    final class CounterView: Plane {
        enum Style: Comparable {
            case none, small, normal
        }

        let blur = Blur { it, _ in
            it.style = .dark
            it.intensity = 0.6
        }

        let label = Label { it, ds in
            it.font = ds.font.secondary
            it.color = .white
        }

        var style: Style = .normal {
            didSet {
                guard oldValue != style else { return }
                updateVisibility()
                parent?.updateLayoutRecursive()
            }
        }

        var count: Int = 0 {
            didSet {
                guard oldValue != count else { return }
                label.text = L.imageSelectorPhotos(count)
                updateVisibility()
            }
        }

        private func updateVisibility() {
            view.isVisible = count > 1 && style > .none
        }

        override func setup() {
            updateVisibility()
        }

        override func updateLayout() {
            label.layout.make { make in
                make.top = style == .normal ? 8 : 6
                make.left = style == .normal ? 16 : 12
            }

            layout.make { make in
                make.width = label.layout.rightPin + label.layout.left
                make.height = label.layout.bottomPin + label.layout.top
                make.radius = 4
            }

            blur.layout.make { make in
                make.inset = 0
            }
        }
    }
}
