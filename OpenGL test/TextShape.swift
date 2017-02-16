//
//  TextShape.swift
//  OpenGL test
//
//  Created by William Wold on 2/8/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import UIKit
import GLKit

class TextShape: Shape {
	
	static let VertexAttributes: [VertAttrib] = [
		VertAttrib(name: "pos", index: 0, type: GLenum(GL_FLOAT), count: 3, offset: 0),
		VertAttrib(name: "uv", index: 1, type: GLenum(GL_FLOAT), count: 2, offset: 3 * MemoryLayout<GLfloat>.size)
	]
	
	static let vertShaderSrc = ""
		+	"uniform highp mat4 transform;"
		+	"attribute vec4 pos; "
		+	"attribute vec2 uv; "
		+	"varying lowp vec2 fragUV; "
		+	"void main(void) { "
		+		"gl_Position = transform * pos; "
		+		"fragUV = uv; "
		+	"} "
	
	static let fragShaderSrc = ""
		+	"uniform sampler2D tex;"
		+	"varying lowp vec2 fragUV; "
		+	"precision lowp float; "
		+	"void main(void) { "
		+		"float val = texture2D(tex, fragUV).x; "
		+		"gl_FragColor = vec4(1.0, 1.0, 1.0, val/2.0+0.5); "
		+	"}"
	
	static let vertices : [ShapeVert] = [
		//		Position			UV
		ShapeVert(	1.0, 0.0, 0,		1.0, 0.0),
		ShapeVert(	1.0,  1.0, 0,		1.0, 1.0),
		ShapeVert(	-1.0,  1.0, 0,		0.0, 1.0),
		ShapeVert(	-1.0, 0.0, 0,		0.0, 0.0)
	]
	
	static let indices : [GLubyte] = [
		0, 1, 2,
		2, 3, 0
	]
	
	var tex = UniformTex()
	var transform0 = UniformMatrix4(GLKMatrix4Scale(GLKMatrix4Identity, 0.5, 0.5, 0.5))
	
	var text = "" {
		didSet {
			updateText()
		}
	}
	
	override init() {
		let shader = ShaderProgram(vertAttribs: TextShape.VertexAttributes, vertShader: TextShape.vertShaderSrc, fragShader: TextShape.fragShaderSrc)
		
		shader.addUniform(uniform: tex, name: "tex")
		shader.addUniform(uniform: transform0, name: "transform")
		
		super.init(verts: TextShape.vertices, indices: TextShape.indices, shader: shader)
	}
	
	func updateText() {
		//let view = UITextView(frame: CGRect(x: 0, y: 0, width: 220, height: 180))
		
		let layer = CATextLayer()
		
		//layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		layer.string = text
		layer.foregroundColor = UIColor.white.cgColor
		layer.backgroundColor = UIColor.black.cgColor
		layer.fontSize = 300
		layer.isWrapped = false
		
		let preferredFrameSize = layer.preferredFrameSize()
		print("preferred frame size: \(preferredFrameSize)")
		
		let width: Int = Int(ceil(preferredFrameSize.width/4))*4
		let height: Int = Int(ceil(preferredFrameSize.height/4))*4
		
		//layer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: layer.preferredFrameSize())
		
		layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
		
		//layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
		
		/*for familyName:String in UIFont.familyNames {
			print("Family Name: \(familyName)")
			for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
				print("--Font Name: \(fontName)")
			}
		}*/
		
		//let myFont = UIFont(name: "SnellRoundhand", size: 60)
		
		//let text: NSAttributedString = "hello"
		
		//let myFontSize = myFont.size
		//	[YourTextHere sizeWithFont:myFont];
		
		//view.text = text
		//view.textColor = UIColor.white
		//view.font = UIFont(name: view.font!.fontName, size: 60)
		//view.backgroundColor = UIColor.black
		//UIColor(colorLiteralRed: 0.1, green: 0.6, blue: 0.8, alpha: 1.0)
		
		// make space for an RGBA image of the view
		//GLubyte *pixelBuffer = (GLubyte *)malloc(4 * view.bounds.size.width * view.bounds.size.height);`
		
		print("width: \(width), height: \(height)")
		
		//let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let colorSpace = CGColorSpaceCreateDeviceGray()
		
		let pixelBuffer = malloc((colorSpace.numberOfComponents + 1) * width * height)
		
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		guard let context = CGContext.init(data: pixelBuffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: (colorSpace.numberOfComponents + 1) * width, space: colorSpace, bitmapInfo: UInt32(bitmapInfo.rawValue)) else {
			// cannot create context - handle error
			print("context error or something")
			return
		}
		
		// create a suitable CoreGraphics context
		//let context = CGBitmapContextCreate(pixelBuffer, view.bounds.size.width, view.bounds.size.height, 8, 4*view.bounds.size.width, colourSpace, CGBitmapInfo.alphaInfoMask, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		
		//CGColorSpaceRelease(colourSpace);
		
		// draw the view to the buffer
		//[view.layer renderInContext:context];
		
		layer.render(in: context)
		
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
		
		//glGenTextures(1, &tex.texId)
		
		glBindTexture(GLenum(GL_TEXTURE_2D), tex.texId)
		
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
		glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
		
		//glGenTextures(1, &tex)
		
		// upload to OpenGL
		glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_LUMINANCE_ALPHA, GLsizei(width), GLsizei(height), 0, GLenum(GL_LUMINANCE_ALPHA), GLenum(GL_UNSIGNED_BYTE), pixelBuffer);
		
		free(pixelBuffer);
	}
	
	//returns a vertex array
	private func getVerts(w: Double, h: Double) {
		
		
	}
}
