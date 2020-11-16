//
//  ColorImg.swift
//  EUNCAROUSEL
//
//  Created by 60080252 on 2020/10/29.
//

import Foundation

struct ColorImg {
    var img: String
    
    init(img: String) {
        self.img = img
    }
    
    static var colorList: [ColorImg] {
        let array = Array(1...10)
        return array.map { ColorImg(img: "img_\($0)") }
    }
}
