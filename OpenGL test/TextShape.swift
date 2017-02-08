//
//  TextShape.swift
//  OpenGL test
//
//  Created by William Wold on 2/8/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import UIKit
import GLKit

class TextShape: WidapShape {
	
	static let VertexAttributes: [VertexAttribute] = [
		VertexAttribute(name: "pos", index: 0, type: GLenum(GL_FLOAT), count: 3, offset: 0),
		VertexAttribute(name: "uv", index: 1, type: GLenum(GL_FLOAT), count: 2, offset: 3 * MemoryLayout<GLfloat>.size)
	]
	
	static let vertShaderSrc = ""
		+	"attribute vec4 pos; "
		+	"attribute vec2 uv; "
		+	"varying lowp vec2 fragUV; "
		+	"void main(void) { "
		+		"gl_Position = pos; "
		+		"fragUV = uv; "
		+	"} "
	
	static let fragShaderSrc = ""
		+	"uniform sampler2D tex;"
		+	"varying lowp vec2 fragUV; "
		+	"precision lowp float; "
		+	"void main(void) { "
		+			"gl_FragColor = texture2D(tex, fragUV); "
		+	"}"
	
	static let vertices : [Vertex] = [
		//		Position			UV
		Vertex(	1.0, -1.0, 0.0,		1.0, 0.0),
		Vertex(	1.0,  1.0, 0.0,		1.0, 1.0),
		Vertex(	-1.0,  1.0, 0.0,	0.0, 1.0),
		Vertex(	-1.0, -1.0, 0.0,	0.0, 0.0)
	]
	
	static let indices : [GLubyte] = [
		0, 1, 2,
		2, 3, 0
	]
	
	var tex = UniformTex()
	
	var text = "" {
		didSet {
			updateText()
		}
	}
	
	override init() {
		let shader = ShaderProgram(vertAttribs: TextShape.VertexAttributes, vert: TextShape.vertShaderSrc, frag: TextShape.fragShaderSrc)
		
		shader.addUniform(uniform: tex, name: "tex")
		
		super.init(verts: TextShape.vertices, indices: TextShape.indices, shader: shader)
	}
	
	func updateText() {
		print("text updating")
		
		let view = UITextView(frame: CGRect(x: 0, y: 0, width: 220, height: 180))
		
		view.text = text
		view.textColor = UIColor.white
		view.font = UIFont(name: view.font!.fontName, size: 60)
		view.backgroundColor = UIColor.black
		//UIColor(colorLiteralRed: 0.1, green: 0.6, blue: 0.8, alpha: 1.0)
		
		// make space for an RGBA image of the view
		//GLubyte *pixelBuffer = (GLubyte *)malloc(4 * view.bounds.size.width * view.bounds.size.height);`
		
		let width: Int = Int(view.bounds.size.width)
		let height: Int = Int(view.bounds.size.height)
		
		let pixelBuffer = malloc(4 * width * height)
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		print(colorSpace.numberOfComponents)
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
		
		/*
		var y = height-1
		
		while (y>=3) {
		
		var x = 0
		
		while (x<width) {
		
		let val0 = (pixelBuffer?.assumingMemoryBound(to: UInt8.self)[(y*width+x)*4])!
		let val1 = (pixelBuffer?.assumingMemoryBound(to: UInt8.self)[((y-3)*width+x)*4])!
		
		if (val0>128 && val1>128) {
		print(":", terminator: "")
		} else if (val0>128) {
		print("'", terminator: "")
		}
		else if (val1>128) {
		print(".", terminator: "")
		}
		else {
		print(" ", terminator: "")
		}
		
		x+=2
		}
		
		print()
		
		y-=6
		}
		*/
		
		glGenTextures(1, &tex.texId)
		
		glBindTexture(GLenum(GL_TEXTURE_2D), tex.texId)
		
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
		
		//glGenTextures(1, &tex)
		
		// upload to OpenGL
		glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), pixelBuffer);
		
		//free(pixelBuffer);
	}
}
