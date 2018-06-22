//
//  Consts.swift
//  QRChild
//
//  Created by Karapats on 19/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import Foundation

let youtubeRegexp = "((?:youtube(?:-nocookie)?\\.com\\/(?:[^\\/\n\\s]+\\/\\S+\\/|(?:v|e(?:mbed)?)\\/|\\S*?[?&]v=)|youtu\\.be\\/)([a-zA-Z0-9_-]{11})|([a-zA-Z0-9_-]{11}))"
let youtubeIdRegexp = "([a-zA-Z0-9_-]{11})"
let noQrString = "QR код не обнаружен"
let noCameraString = "Камера не обнаружена"
let cameraAccessDeniedString = "Доступ к камере запрещён"
let wrongQrFormatString = "Неверный формат QR кода"
