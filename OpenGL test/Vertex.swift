//
//  Vertex.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

/*
enum VertexAttributes : GLuint {
	case pos = 0
	case uv = 1
}
*/

let VertexAttributes: [VertexAttribute] = [
	VertexAttribute(name: "pos", index: 0, type: GLenum(GL_FLOAT), count: 3, offset: 0),
	VertexAttribute(name: "uv", index: 1, type: GLenum(GL_FLOAT), count: 2, offset: 3 * MemoryLayout<GLfloat>.size)
]

class VertexAttribute {
	
	var name: String
	var index: GLuint
	var type: GLenum
	var count: GLint
	var offset: UnsafeRawPointer!
	
	init(name: String, index: GLuint, type: GLenum, count: GLint, offset: Int) {
		
		self.name = name
		self.index = index
		self.type = type
		self.count = count
		self.offset = UnsafeRawPointer(bitPattern: offset)
	}
}

struct Vertex {
	var x : GLfloat = 0.0
	var y : GLfloat = 0.0
	var z : GLfloat = 0.0
	
	var u : GLfloat = 0.0
	var v : GLfloat = 0.0
	
	init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat, _ u : GLfloat = 0.0, _ v : GLfloat = 0.0) {
		self.x = x
		self.y = y
		self.z = z
		
		self.u = u
		self.v = v
	}
}
