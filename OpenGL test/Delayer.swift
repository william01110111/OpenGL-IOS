//
//  Delayer.swift
//  OpenGL test
//
//  Created by William Wold on 2/1/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation

class Delayer {
	
	let clbk: (() -> Void)?
	var nsTimer: Timer?
	
	init() {
		
		clbk = nil
	}
	
	init(seconds: Double, repeats: Bool, callback: @escaping () -> Void) {
		
		clbk = callback
		
		nsTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(Delayer.callClbk), userInfo: nil, repeats: repeats)
	}
	
	@objc func callClbk() {
		
		clbk?()
	}
	
	func stop() {
		
		nsTimer?.invalidate()
	}
}
