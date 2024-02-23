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



final class AiutaOnboardingView: Scroll {
    @scrollable
    var contentView = AitaBoardingViewContent()

    let swipeEdge = SwipeEdge()
    let navBar = AiutaNavBar()
    let footer = AitaBoardingViewFooter()

    override func updateLayout() {
        scrollView.contentInset = .init(top: navBar.layout.bottomPin, bottom: footer.layout.topPin)
    }
}

final class AitaBoardingViewContent: Plane {
    let header = Label { it, ds in
        it.font = ds.font.boardingHeader
        it.isMultiline = true
        it.text = "Try on an item of clothing directly on your photo"
    }

    let point1 = Label { it, ds in
        it.font = ds.font.boardingText
        it.text = "1."
    }

    let text1 = Label { it, ds in
        it.font = ds.font.boardingText
        it.isMultiline = true
        it.text = "Enjoy you new good looking style and share it with anyone"
    }

    let image1 = Image { it, ds in
        it.image = ds.image.sdk(.aiutaOnBoard1)
    }

    let point2 = Label { it, ds in
        it.font = ds.font.boardingText
        it.text = "2."
    }

    let text2 = Label { it, ds in
        it.font = ds.font.boardingText
        it.isMultiline = true
        it.text = "Start by uploading photos (no more than 10) with good lighting and a solid background."
    }

    let image2 = Image { it, ds in
        it.image = ds.image.sdk(.aiutaOnBoard2)
    }

    override func updateLayout() {
        header.layout.make { make in
            make.leftRight = 16
            make.top = 16
        }

        point1.layout.make { make in
            make.left = header.layout.left
            make.top = header.layout.bottomPin + 24
        }

        text1.layout.make { make in
            make.left = point1.layout.rightPin + 8
            make.right = header.layout.right
            make.top = point1.layout.top
        }

        image1.layout.make { make in
            make.left = header.layout.left
            make.top = text1.layout.bottomPin + 14
        }

        point2.layout.make { make in
            make.left = header.layout.left
            make.top = image1.layout.bottomPin + 32
        }

        text2.layout.make { make in
            make.left = point2.layout.rightPin + 8
            make.right = header.layout.right
            make.top = point2.layout.top
        }

        image2.layout.make { make in
            make.left = header.layout.left
            make.top = text2.layout.bottomPin + 14
        }

        layout.make { make in
            make.height = image2.layout.bottomPin + 16
        }
    }
}

final class AitaBoardingViewFooter: Plane {
    let go = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.accent
        it.text = "Start"
    }

    override func setup() {
        view.backgroundColor = .white
    }

    override func updateLayout() {
        layout.make { make in
            make.width = layout.boundary.width
            make.height = layout.safe.insets.bottom + 72
            make.bottom = 0
        }

        go.layout.make { make in
            make.leftRight = 16
            make.top = 10
            make.height = 50
            make.radius = 8
        }
    }
}
