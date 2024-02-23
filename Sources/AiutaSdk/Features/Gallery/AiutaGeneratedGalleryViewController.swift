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



final class AiutaGeneratedGalleryViewController: ViewController<AiutaGeneratedGalleryView> {
    var data: DataProvider<Aiuta.GeneratedImage>?
    var index: Int = 0

    convenience init(_ data: DataProvider<Aiuta.GeneratedImage>?, start index: Int) {
        self.init()
        self.data = data
        self.index = index
    }

    override func prepare() {
        hero.modalAnimationType = .fade
        statusBarStyle = .lightContent
    }

    override func setup() {
        ui.closeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.shareButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            shareCurrent()
        }

        ui.galleryView.gestures.onTap(with: self) { [unowned self] tap in
            guard tap.state == .ended else { return }
            dismiss()
        }

        ui.data = data
        ui.pageIndex = index

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
    }

    private func shareCurrent() {
        guard let image = ui.currentPage?.zoomView.imageView.image else { return }
        share(image: image)
    }
}
