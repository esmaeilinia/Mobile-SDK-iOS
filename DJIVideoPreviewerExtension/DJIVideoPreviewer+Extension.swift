//
//  VideoPreviewer+Extension.swift
//  Mesh
//
//  Created by Pandara on 08/03/2018.
//  Copyright © 2018 Kiwi Information Technology Co., Ltd. All rights reserved.
//

import Foundation
import DJIWidget

extension DJIVideoPreviewer {
    func setupDecodeType() {
        if let camera = MeshDeviceManager.shared.djiDevice?.camera, camera.encoderType == ._unknown {
            DJIVideoPreviewer.instance().enableHardwareDecode = false
        } else {
            DJIVideoPreviewer.instance().enableHardwareDecode = true
        }
    }
}
