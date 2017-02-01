//
//  ShaderProgram.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

class ShaderProgram {
	
	var programHandle : GLuint = 0
	
	init() {}
	
	init(vert: String, frag: String) {
		let vertexShaderName = self.compileShader(src: vert, type: GLenum(GL_VERTEX_SHADER))
		let fragmentShaderName = self.compileShader(src: frag, type: GLenum(GL_FRAGMENT_SHADER))
		
		self.programHandle = glCreateProgram()
		glAttachShader(self.programHandle, vertexShaderName)
		glAttachShader(self.programHandle, fragmentShaderName)
		
		glBindAttribLocation(self.programHandle, VertexAttributes.pos.rawValue, "pos")
		glLinkProgram(self.programHandle)
		
		var linkStatus : GLint = 0
		glGetProgramiv(self.programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
		if linkStatus == GL_FALSE {
			var infoLength : GLsizei = 0
			let bufferLength : GLsizei = 1024
			glGetProgramiv(self.programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
			
			let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
			var actualLength : GLsizei = 0
			
			glGetProgramInfoLog(self.programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
			NSLog(String(validatingUTF8: info)!)
			exit(1)
		}
	}
	
	func compileShader(src shaderSrc: String, type shaderType: GLenum) -> GLuint {
		
		//let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
		let shaderString: NSString = shaderSrc as NSString
		let shaderHandle = glCreateShader(shaderType)
		var shaderStringLength : GLint = GLint(Int32(shaderString.length))
		var shaderCString = shaderString.utf8String
		glShaderSource(
			shaderHandle,
			GLsizei(1),
			&shaderCString,
			&shaderStringLength)
		
		glCompileShader(shaderHandle)
		var compileStatus : GLint = 0
		glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus)
		
		if compileStatus == GL_FALSE {
			var infoLength : GLsizei = 0
			let bufferLength : GLsizei = 1024
			glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
			
			let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
			var actualLength : GLsizei = 0
			
			glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
			NSLog(String(validatingUTF8: info)!)
			exit(1)
		}
		
		return shaderHandle
	}
	
	func use() {
		glUseProgram(programHandle)
	}
}
