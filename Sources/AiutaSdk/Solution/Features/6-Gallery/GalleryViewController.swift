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
import UIKit

final class GalleryViewController: ViewController<GalleryView> {
    let willShare = Signal<(ImageSource, Int, GalleryViewController)>()
    var data: DataProvider<ImageSource>?
    var index: Int = 0

    @injected private var watermarker: Watermarker
    private let breadcrumbs = Breadcrumbs()

    override func prepare() {
        statusBarStyle = .lightContent
    }

    convenience init(_ data: DataProvider<ImageSource>?, start index: Int) {
        self.init()
        self.data = data
        self.index = index
    }

    override func setup() {
        ui.close.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.galleryView.gestures.onTap(with: self) { [unowned self] tap in
            guard tap.state == .ended else { return }
            dismiss()
        }

        ui.pages.forEach { cell in
            cell.zoomView.onDismiss.subscribe(with: self) { [unowned self] in
                dismiss()
            }
        }

        ui.share.onTouchUpInside.subscribe(with: self) { [unowned self] in
            shareCurrent()
        }

        ui.data = data
        ui.pageIndex = index
        ui.share.view.isVisible = !willShare.observers.isEmpty && ds.config.behavior.isShareAvailable
    }

    private func shareCurrent() {
        guard let generatedImage = ui.currentItem else { return }
        willShare.fire((generatedImage, ui.pageIndex, self))
    }
}
