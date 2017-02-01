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
	
	let vertShaderSrc = ""
		+	"attribute vec4 pos; "
		+	"attribute vec2 uv; "
		+	"varying lowp vec4 fragColor;"
		+	"void main(void) { "
		+		"gl_Position = pos; "
		+		"fragColor = vec4(0.5, 0.0, 1.0, 1.0); "
		+	"} "
	
	let fragShaderSrc = ""
		+	"varying lowp vec4 fragColor;"
		+	"void main(void) { "
		+		"gl_FragColor = fragColor; "
		+	"} "
	
	let vertices : [Vertex] = [
		Vertex( 0.0,  0.25, 0.0),    // TOP
		Vertex(-0.5, -0.25, 0.0),    // LEFT
		Vertex( 0.5, -0.25, 0.0),    // RIGHT
	]
	
	fileprivate var object = WidapShape()
	
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
		self.isOpaque = false
		
		self.context = EAGLContext(api: .openGLES2)
		EAGLContext.setCurrent(self.context)
		
		var shader = ShaderProgram(vertAttribs: VertexAttributes, vert: vertShaderSrc, frag: fragShaderSrc)
		
		object = FullRect(shader: shader)
		
		//object = WidapShape(verts: vertices, indices: [0, 1, 2], shader: ShaderProgram(vert: vertShaderSrc, frag: fragShaderSrc))
	}
	
	override func draw(_ rect: CGRect) {
		
		print("OpenGL spinner view drawn")
		
		glClearColor(0.0, 0.0, 1.0, 0.5);
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
		
		object.draw()
	}
	
	func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
		let ptr: UnsafeRawPointer? = nil
		return ptr! + n * MemoryLayout<Void>.size
	}
}


