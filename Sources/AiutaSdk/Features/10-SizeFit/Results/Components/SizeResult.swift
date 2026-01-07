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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

final class SizeResult: Plane {
    let tittle = Label { it, ds in
        it.font = ds.fonts.titleM
        it.color = ds.colors.primary
    }

    let summary = Label { it, ds in
        it.font = ds.fonts.subtle
        it.color = ds.colors.secondary
        it.alignment = .center
        it.isMultiline = true
    }

    let stroke = Gradient { it, _ in
        it.colorStops = [
            .init(0x45E4EAFF, 0),
            .init(0x6BE7AFFF, 1),
        ]
        it.direction = .custom(.init(x: -0.25, y: 0.5), .init(x: 1.25, y: 0.5))
        it.view.maxOpacity = 0.7
    }

    let pointer = Pointer()
    let circle = Plane { it, ds in
        it.view.backgroundColor = .clear
        it.view.borderColor = ds.colors.background
        it.view.borderWidth = 3
    }

    var confidence: Int = 0 {
        didSet {
            pointer.title.text = "\(confidence)%"
            updateLayout()
        }
    }

    func grayscale() {
        let stops: [GradientView.ColorStop] = [
            .init(UIColor(red: 0.898, green: 0.898, blue: 0.918, alpha: 1), 0),
            .init(UIColor(red: 0.898, green: 0.898, blue: 0.918, alpha: 1), 1),
        ]
        stroke.colorStops = stops
        pointer.stroke.colorStops = stops
    }

    override func updateLayout() {
        layout.make { make in
            make.leftRight = 45
        }

        tittle.layout.make { make in
            make.left = 0
            make.top = 2
        }

        stroke.layout.make { make in
            make.leftRight = 0
            make.top = tittle.layout.bottomPin + 9
            make.height = 8
            make.radius = make.height / 2
        }

        summary.layout.make { make in
            make.leftRight = 8
            make.top = stroke.layout.bottomPin + 8
        }

        layout.make { make in
            make.height = summary.layout.bottomPin + 32
        }

        pointer.layout.make { make in
            let w = layout.width - tittle.layout.rightPin - 30
            make.left = tittle.layout.rightPin + (w / 100) * clamp(CGFloat(confidence), min: 0, max: 100)
        }

        circle.layout.make { make in
            make.circle = 14
            make.centerY = stroke.layout.centerY
            make.centerX = pointer.layout.centerX
        }
    }

    convenience init(_ builder: (_ it: SizeResult, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

extension SizeResult {
    final class Pointer: Plane {
        let stroke = Gradient { it, _ in
            it.colorStops = [
                .init(0x45E4EAFF, 0),
                .init(0x6BE7AFFF, 1),
            ]
            it.direction = .custom(.init(x: -0.25, y: 0.5), .init(x: 1.25, y: 0.5))
            it.view.maxOpacity = 0.7
        }

        let title = Label { it, ds in
            it.font = ds.fonts.buttonS
            it.color = ds.colors.primary
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 40
                make.height = 30
            }

            stroke.layout.make { make in
                make.inset = 0
            }

            title.layout.make { make in
                make.top = 4
                make.centerX = 0
            }

            let cornerRadius: CGFloat = 6
            let arrowWidth: CGFloat = 8
            let arrowHeight: CGFloat = 6
            let arrowOffsetX: CGFloat = 0

            let w = layout.width
            let h = layout.height

            let arrowW = max(0, min(arrowWidth, w - 2 * cornerRadius))
            let arrowH = max(0, min(arrowHeight, h))
            let halfArrowW = arrowW / 2

            let rect = CGRect(x: 0, y: 0, width: w, height: h - arrowH)

            var arrowCenterX = (w / 2) + arrowOffsetX
            let minX = rect.minX + cornerRadius + halfArrowW
            let maxX = rect.maxX - cornerRadius - halfArrowW
            arrowCenterX = min(max(arrowCenterX, minX), maxX)

            let arrowLeft = CGPoint(x: arrowCenterX - halfArrowW, y: rect.maxY)
            let arrowTip = CGPoint(x: arrowCenterX, y: rect.maxY + arrowH)
            let arrowRight = CGPoint(x: arrowCenterX + halfArrowW, y: rect.maxY)

            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

            path.move(to: arrowLeft)
            path.addLine(to: arrowTip)
            path.addLine(to: arrowRight)
            path.close()

            let maskLayer = CAShapeLayer()
            maskLayer.frame = view.bounds
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }
    }
}
