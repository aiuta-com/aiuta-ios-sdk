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

import AiutaKit

final class AiutaGenerationsHistorySnackbar: Plane {
    let deleteButton = OptionButton { it, ds in
        it.icon.image = ds.image.sdk(.aiutaTrash)
    }

    let shareButton = OptionButton { it, ds in
        it.icon.image = ds.image.sdk(.aiutaShare)
    }

    let toggleSeletionButton = LabelButton { it, ds in
        it.font = ds.font.footer
        it.label.color = ds.color.item
        it.text = "Select all"
    }

    let cancelButton = LabelButton { it, ds in
        it.font = ds.font.footer
        it.color = ds.color.item
        it.label.color = ds.color.tint
        it.text = "Cancel"
    }

    override func setup() {
        view.backgroundColor = ds.color.tint
    }

    override func updateLayout() {
        layout.make { make in
            make.height = 68
            make.radius = 16
        }

        cancelButton.layout.make { make in
            make.left = 16
            make.centerY = 0
            make.radius = make.height / 2
        }

        toggleSeletionButton.layout.make { make in
            make.left = cancelButton.layout.rightPin + 10
            make.centerY = 0
        }

        shareButton.layout.make { make in
            make.right = 16
            make.centerY = 0
        }

        deleteButton.layout.make { make in
            make.right = shareButton.layout.leftPin + 16
            make.centerY = 0
        }
    }
}

extension AiutaGenerationsHistorySnackbar {
    final class OptionButton: PlainButton {
        let circle = Stroke { it, ds in
            it.color = ds.color.item
        }

        let icon = Image { it, ds in
            it.tint = ds.color.tint
        }

        var isEnabled = true {
            didSet {
                guard oldValue != isEnabled else { return }
                icon.tint = isEnabled ? ds.color.tint : ds.color.gray
            }
        }

        override func updateLayout() {
            layout.make { make in
                make.size = .init(square: 46)
            }

            circle.layout.make { make in
                make.circle = 36
                make.center = .zero
            }

            icon.layout.make { make in
                make.center = .zero
            }
        }

        public convenience init(_ builder: (_ it: OptionButton, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
