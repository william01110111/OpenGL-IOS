//
//  GLToVideo.swift
//  OpenGL test
//
//  Created by William Wold on 2/2/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit
import AVFoundation

class GLToVideo: WidapGLView {
	
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
		+			"gl_FragColor.g=mod(ang-cycle*2.0, 1.0); "
		+			"gl_FragColor.b=mod(ang-cycle*3.0, 1.0); "
		+			"gl_FragColor.a = 1.0; "
		+		"} else { "
		+			"float maxDstSq = (sin(radians(cycle*360.0))+1.0)*0.2+0.1; "
		+			"if (dstSq < maxDstSq * maxDstSq) {"
		+				"gl_FragColor = vec4(0.0, 0.5, 1.0, 1); "
		+			"} else { "
		+				"gl_FragColor = vec4(0, 0, 0, 0); "
		+			"} "
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
		
		setupCapture()
	}
	
	override func update(delta: Double) {
		
		captureFrame()
		
		cycle.val += GLfloat(delta)
		
		cycle.val = cycle.val - Float(Int(cycle.val))
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor?
	
	func setupCapture() {
		
		let width = 200
		let height = 200
		
		let url = URL(fileURLWithPath: "widap_output_video.mp4")
		
		do {
			let assetWriter = try AVAssetWriter(outputURL: url, fileType: AVFileTypeMPEG4)
			
			var outputSettings = [String: Any]();
			
			outputSettings[AVVideoCodecKey] = AVVideoCodecH264
			outputSettings[AVVideoWidthKey] = width
			outputSettings[AVVideoHeightKey] = height
			
			let assetWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
			
			assetWriterInput.expectsMediaDataInRealTime = true
			
			let sourcePixelBufferAttributesDictionary: [String: Any] = [
				kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
				kCVPixelBufferWidthKey as String: width,
				kCVPixelBufferHeightKey as String: height
			]
			
			assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
			
			assetWriter.add(assetWriterInput)
		} catch {
			print("AVAssetWriter error")
		}
	}
	
	func captureFrame() {
		/*
		var pixel_buffer: CVPixelBuffer? = nil;
		
		CVPixelBufferPool
		
		CVPixelBufferPoolCreatePixelBuffer (NULL, [assetWriterPixelBufferInput pixelBufferPool], &pixel_buffer);
		if ((pixel_buffer == NULL) || (status != kCVReturnSuccess))
		{
			return;
		}
		else
		{
			CVPixelBufferLockBaseAddress(pixel_buffer, 0);
			GLubyte *pixelBufferData = (GLubyte *)CVPixelBufferGetBaseAddress(pixel_buffer);
			glReadPixels(0, 0, videoSize.width, videoSize.height, GL_RGBA, GL_UNSIGNED_BYTE, pixelBufferData);
		}
		
		// May need to add a check here, because if two consecutive times with the same value are added to the movie, it aborts recording
		CMTime currentTime = CMTimeMakeWithSeconds([[NSDate date] timeIntervalSinceDate:startTime],120);
		
		if(![assetWriterPixelBufferInput appendPixelBuffer:pixel_buffer withPresentationTime:currentTime])
		{
			NSLog(@"Problem appending pixel buffer at time: %lld", currentTime.value);
		}
		else
		{
			//        NSLog(@"Recorded pixel buffer at time: %lld", currentTime.value);
		}
		CVPixelBufferUnlockBaseAddress(pixel_buffer, 0);
		
		CVPixelBufferRelease(pixel_buffer);
		*/
	}
}
