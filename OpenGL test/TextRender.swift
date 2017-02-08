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
		+	"uniform sampler2D tex;"
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
		+			"gl_FragColor = texture2D(tex, fragUV); "
		+		"} "
		+	"}"
	
	let FragShaderSrc = ""
		+	"uniform sampler2D u_Texture;"
		+	"varying lowp vec2 fragUV; "
		+	"precision lowp float; "
		+	"void main(void) { "
		+		"gl_FragColor = vec4(texture2D(u_Texture, fragUV).rg, 0.2, 1.0); "
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
		
		let shader = ShaderProgram(vertAttribs: VertexAttributes, vert: vertShaderSrc, frag: FragShaderSrc)
		
		//shader.addUniform(uniform: cycle, name: "cycle")
		
		object = FullRect(shader: shader)
		
		drawables.append(object)
		
		//object = WidapShape(verts: vertices, indices: [0, 1, 2], shader: ShaderProgram(vert: vertShaderSrc, frag: fragShaderSrc))
		
		//UIView *view = ... something ...;
		
		let view = UITextView(frame: CGRect(x: 0, y: 0, width: 220, height: 180))
		
		view.text = "William W Wold"
		view.textColor = UIColor(colorLiteralRed: 0.4, green: 0.9, blue: 0.1, alpha: 1.0)
		view.font = UIFont(name: view.font!.fontName, size: 60)
		view.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.6, blue: 0.8, alpha: 1.0)
		
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
		
		let tex = UniformTex()
		
		//glBindTexture(GLenum(GL_TEXTURE_2D), tex.texId)
		
		//glGenTextures(1, &tex)
		
		// upload to OpenGL
		//glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), pixelBuffer);
		
		//free(pixelBuffer);
		
		tex.texId = loadTexture("dungeon_01.png")
		
		shader.addUniform(uniform: tex, name: "u_Texture")
	}
	
	override func update() {
		
		cycle.val += 0.01
		
		cycle.val = cycle.val - floor(cycle.val)
	}
	
	func loadTexture(_ filename: String) -> GLuint {
		
		let path = Bundle.main.path(forResource: filename, ofType: nil)!
		let option = [ GLKTextureLoaderOriginBottomLeft: true]
		do {
			let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
			let tex = info.name
			return tex
		} catch {
			print("texture loading failed")
			return 0
		}
	}
}
