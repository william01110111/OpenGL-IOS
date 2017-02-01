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
	
	deinit {
		destroy()
	}
	
	init(verts: [Vertex], indices: [GLubyte], shader: ShaderProgram) {
		
		self.shader = shader
		
		glGenBuffers(GLsizei(1), &vertexBuffer)
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
			let count = verts.count
			let size = MemoryLayout<Vertex>.size
			glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, verts, GLenum(GL_STATIC_DRAW))
		
		glGenBuffers(GLsizei(1), &indexBuffer)
		
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
			glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
			indexCount = indices.count
	}
	
	func draw() {
		
		shader.use()
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
		
		for i in VertexAttributes {
			glVertexAttribPointer(i.index, i.count, i.type, GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), i.offset)
			glEnableVertexAttribArray(i.index)
		}
		
		glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indexCount), GLenum(GL_UNSIGNED_BYTE), nil)
		
		for i in VertexAttributes {
			glDisableVertexAttribArray(i.index)
		}
	}
	
	func destroy() {
		
		if vertexBuffer > 0 {
			glDeleteBuffers(GLsizei(1), &vertexBuffer)
			vertexBuffer = 0
		}
		
		if indexBuffer > 0 {
			glDeleteBuffers(GLsizei(1), &indexBuffer)
			indexBuffer = 0
		}
		
		indexCount = 0
		
		shader.destroy()
	}
}
