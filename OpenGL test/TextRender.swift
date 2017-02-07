//
//  SpinnerView.swift
//  OpenGL test
//
//  Created by William Wold on 2/2/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import UIKit
import GLKit

class TextRender: WidapGLView {
	
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
		+			"gl_FragColor.r=1.0-mod(ang-cycle*1.0+0.5, 1.0); "
		+			"gl_FragColor.g=1.0-mod(ang-cycle*2.0, 1.0); "
		+			"gl_FragColor.b=1.0-mod(ang-cycle*3.0, 1.0); "
		+			"gl_FragColor.a = 1.0; "
		+		"} "
		+		"else { "
		+			"gl_FragColor = vec4(0, 0, 0, 0); "
		+		"} "
		+	"}"
	
	let vertices : [Vertex] = [
		Vertex( 0.0,  0.25, 0.0),    // TOP
		Vertex(-0.5, -0.25, 0.0),    // LEFT
		Vertex( 0.5, -0.25, 0.0),    // RIGHT
	]
	
	fileprivate var object = WidapShape()
	
	var cycle = UniformFloat(0.0)
	
	override func setup() {
		
		super.setup()
		
		let shader = ShaderProgram(vertAttribs: VertexAttributes, vert: vertShaderSrc, frag: spinnerFragShaderSrc)
		
		shader.addUniform(uniform: cycle, name: "cycle")
		
		object = FullRect(shader: shader)
		
		drawables.append(object)
		
		//object = WidapShape(verts: vertices, indices: [0, 1, 2], shader: ShaderProgram(vert: vertShaderSrc, frag: fragShaderSrc))
		
		//UIView *view = ... something ...;
		
		let view = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
		
		view.text = "hello, this is some text in a view"
		
		// make space for an RGBA image of the view
		//GLubyte *pixelBuffer = (GLubyte *)malloc(4 * view.bounds.size.width * view.bounds.size.height);
		
		let width: Int = Int(view.bounds.size.width)
		let height: Int = Int(view.bounds.size.height)
		
		let pixelBuffer = malloc(4 * width * height)
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext.init(data: pixelBuffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4*width, space: colorSpace, bitmapInfo: UInt32(bitmapInfo.rawValue)) else {
			// cannot create context - handle error
			print("context error or something")
			return
		}
		
		// create a suitable CoreGraphics context
		//let context = CGBitmapContextCreate(pixelBuffer, view.bounds.size.width, view.bounds.size.height, 8, 4*view.bounds.size.width, colourSpace, CGBitmapInfo.alphaInfoMask, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		
		//CGColorSpaceRelease(colourSpace);
		
		// draw the view to the buffer
		//[view.layer renderInContext:context];
		
		view.layer.render(in: context)
		
		var tex: GLuint = 0
		
		glGenTextures(1, &tex)
		
		//glGenTextures(1, &tex)
		
		// upload to OpenGL
		glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(view.bounds.size.width), GLsizei(view.bounds.size.height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), pixelBuffer);
		
		free(pixelBuffer);
	}
	
	override func update() {
		
		cycle.val += 0.01
		
		cycle.val = cycle.val - floor(cycle.val)
	}
}
