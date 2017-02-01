//
//  Vertex.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

enum VertexAttributes : GLuint {
	case pos = 0
	case uv = 1
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
