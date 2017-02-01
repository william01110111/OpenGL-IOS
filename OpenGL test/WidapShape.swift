//
//  WidapShape.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

class WidapShape {
	
	var vertexBuffer : GLuint = 0
	var indexBuffer: GLuint = 0
	var indexCount = 0
	var shader = ShaderProgram()
	
	init() {}
	
	init(verts: [Vertex], indices: [GLubyte], shader: ShaderProgram) {
		
		self.shader = shader
		
		glGenBuffers(GLsizei(1), &vertexBuffer)
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		let count = verts.count
		let size =  MemoryLayout<Vertex>.size
		glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, verts, GLenum(GL_STATIC_DRAW))
		
		
		glGenBuffers(GLsizei(1), &indexBuffer)
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
		glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
		
		indexCount = indices.count
	}
	
	func draw() {
		
		shader.use()
		
		glVertexAttribPointer(
			VertexAttributes.pos.rawValue,
			3,
			GLenum(GL_FLOAT),
			GLboolean(GL_FALSE),
			GLsizei(MemoryLayout<Vertex>.size),
			nil
		)
		
		glEnableVertexAttribArray(VertexAttributes.pos.rawValue)
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
		
		glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indexCount), GLenum(GL_UNSIGNED_BYTE), nil)
		
		glDisableVertexAttribArray(VertexAttributes.pos.rawValue)
	}
}
