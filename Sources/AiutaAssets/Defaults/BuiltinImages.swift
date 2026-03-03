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

import AiutaDefaults

extension ImagesPack {
    public static var builtin: Self {
        .init(
            onboardingHowItWorksItems: [
                .init(
                    itemPhoto: AiutaAssets.bundleImage("aiutaImageBoardHow1L")!,
                    itemPreview: AiutaAssets.bundleImage("aiutaImageBoardHow1S")!
                ),
                .init(
                    itemPhoto: AiutaAssets.bundleImage("aiutaImageBoardHow2L")!,
                    itemPreview: AiutaAssets.bundleImage("aiutaImageBoardHow2S")!
                ),
                .init(
                    itemPhoto: AiutaAssets.bundleImage("aiutaImageBoardHow3L")!,
                    itemPreview: AiutaAssets.bundleImage("aiutaImageBoardHow3S")!
                ),
            ],
            imagePickerExamples: [
                AiutaAssets.bundleImage("aiutaImagePickerSample1"),
                AiutaAssets.bundleImage("aiutaImagePickerSample2"),
            ].compactMap { $0 }
        )
    }
}
