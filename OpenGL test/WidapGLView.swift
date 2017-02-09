//
//  ColorSpinnerView.swift
//  Triangle
//
//  Created by William Wold on 1/30/17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import UIKit
import GLKit

class WidapGLView: GLKView {
	
	var frameTime = 0.02
	
	var drawables = [Drawable]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		
		backgroundColor = UIColor.clear
		isOpaque = false
		
		enableSetNeedsDisplay = true
		
		self.context = EAGLContext(api: .openGLES2)
		EAGLContext.setCurrent(self.context)
		
		glEnable(GLenum(GL_BLEND))
		glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
		
		_ = Delayer(seconds: frameTime, repeats: true, callback: setNeedsDisplay)
	}
	
	override func draw(_ rect: CGRect) {
		
		update()
		
		glClearColor(0.0, 0.0, 0.0, 1.0);
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
		
		for i in drawables {
			i.draw()
		}
	}
	
	func update() {}
	
	func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
		let ptr: UnsafeRawPointer? = nil
		return ptr! + n * MemoryLayout<Void>.size
	}
}

protocol Drawable {
	func draw()
}


