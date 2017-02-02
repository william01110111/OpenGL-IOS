//
//  UniformData.swift
//  OpenGL test
//
//  Created by William Wold on 2/2/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit


class UniformBase {
	
	func apply(loc: GLint) {}
}

class UniformData<T>: UniformBase {
	
	var val: T
	
	init(_ val: T) {
		self.val = val
	}
	
	func set(_ val: T) {
		self.val = val
	}
}

class UniformFloat: UniformData<GLfloat> {
	override func apply(loc: GLint) {
		glUniform1f(loc, val)
	}
}

class UniformInt: UniformData<GLint> {
	override func apply(loc: GLint) {
		glUniform1i(loc, val)
	}
}

class UniformVec2: UniformData<(GLfloat, GLfloat)> {
	override func apply(loc: GLint) {
		glUniform2f(loc, val.0, val.1)
	}
}

class UniformVec3: UniformData<(GLfloat, GLfloat, GLfloat)> {
	override func apply(loc: GLint) {
		glUniform3f(loc, val.0, val.1, val.2)
	}
}
