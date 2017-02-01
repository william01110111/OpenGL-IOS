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
		+	"varying lowp vec2 fragUV; "
		+	"void main(void) { "
		+		"gl_Position = pos; "
		//+		"fragColor = vec4(0.5, 0.0, 1.0, 1.0); "
		+		"fragUV = uv; "
		+	"} "
	
	/*
	let fragShaderSrc = ""
		+	"varying lowp vec4 fragColor; "
		+	"varying lowp vec2 fragUV; "
		+	"void main(void) { "
		+		"gl_FragColor = fragColor; "
		+	"} "
	*/
	
	let spinnerFragShaderSrc = ""
		+	"uniform lowp float cycle; "
		+	"varying lowp vec2 fragUV; "
		+	"precision lowp float; "
		+	"void main(void) { "
		+		"float dstSq = fragUV.x*fragUV.x+fragUV.y*fragUV.y; "
		+		"if (dstSq<0.9*0.9 && dstSq>0.7*0.7) { "
		//+			"float cycle = 0.33; "
		+			"float ang = degrees(atan(fragUV.y, fragUV.x))/360.0; "
		+			"gl_FragColor.r=mod(ang-cycle*1.0+0.5, 1.0); "
		+			"gl_FragColor.b=mod(ang-cycle*2.0, 1.0); "
		+			"gl_FragColor.g=mod(ang-cycle*3.0, 1.0); "
		+			"gl_FragColor.a=1.0; "
		+		"} "
		+		"else { "
		+			"gl_FragColor = vec4(0, 0, 0, 1); "
		+		"} "
		+	"}"
	
	let vertices : [Vertex] = [
		Vertex( 0.0,  0.25, 0.0),    // TOP
		Vertex(-0.5, -0.25, 0.0),    // LEFT
		Vertex( 0.5, -0.25, 0.0),    // RIGHT
	]
	
	fileprivate var object = WidapShape()
	
	var cycle = 0.0
	
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
		
		let shader = ShaderProgram(vertAttribs: VertexAttributes, vert: vertShaderSrc, frag: spinnerFragShaderSrc)
		
		object = FullRect(shader: shader)
		
		//object = WidapShape(verts: vertices, indices: [0, 1, 2], shader: ShaderProgram(vert: vertShaderSrc, frag: fragShaderSrc))
	}
	
	override func draw(_ rect: CGRect) {
		
		cycle += 0.1
		
		print("OpenGL spinner view drawn")
		 
		glClearColor(0.0, 0.0, 1.0, 0.5);
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
		
		object.draw(cycle: cycle)
	}
	
	func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
		let ptr: UnsafeRawPointer? = nil
		return ptr! + n * MemoryLayout<Void>.size
	}
}


