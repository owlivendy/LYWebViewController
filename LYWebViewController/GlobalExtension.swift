//
//  GlobalExtension.swift
//  LYWebViewController
//
//  Created by xiaofeishen on 16/7/20.
//  Copyright © 2016年 xiaofeishen. All rights reserved.
//

import Foundation

func after(sec:Double, cb:Void->Void) {
    let ti = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * sec))
    dispatch_after(ti, dispatch_get_main_queue()) {
        cb()
    }
}