/************************************************************************
 * Copyright © 2007-2016 - General Electric Company, All Rights Reserved
 * 
 * Project: SADL
 * 
 * Description: The Semantic Application Design Language (SADL) is a
 * language for building semantic models and expressing rules that
 * capture additional domain knowledge. The SADL-IDE (integrated
 * development environment) is a set of Eclipse plug-ins that
 * support the editing and testing of semantic models using the
 * SADL language.
 * 
 * This software is distributed "AS-IS" without ANY WARRANTIES
 * and licensed under the Eclipse Public License - v 1.0
 * which is available at http://www.eclipse.org/org/documents/epl-v10.php
 * 
 ***********************************************************************/
package com.ge.research.sadl.tests.lsp

import com.ge.research.sadl.ide.SadlProjectStructureInitializer
import com.ge.research.sadl.utils.PathToFileUriConverter
import com.google.inject.Inject
import org.junit.Test

/**
 * Test for checking the {@link ISemanticHighlightService semantic highlight
 * service} for the {@code SADL} language.
 * 
 * @author akos.kitta
 */
class SadlColoringTest extends AbstractSadlLanguageServerTest {

	@Inject
	SadlProjectStructureInitializer projectStructureInitializer;

	@Inject
	PathToFileUriConverter uriConverter;

	@Override
	override setup() {
		super.setup();
		initialize();
	}

	@Test
	def void checkColoring_01() {
		val file = root.toPath.resolve('''MyModel.«fileExtension»''').toFile;
		val uri = file.toURI.toString;

		uri.open('''
		uri "http://sadl.imp/shapes_top".

		Shape is a top-level class.''');
		
		assertEquals('''
		«uriConverter.createFileUri(file)» ->
		 * [[0, 4] .. [0, 32]] -> [28]
		 * [[2, 0] .. [2, 5]] -> [29]''', coloringParams.toExpectation);
	}

	@Test
	def void checkColoring_02() {
		val file = root.toPath.resolve('''MyModel.«fileExtension»''').toFile;
		val uri = file.toURI.toString;
		
		uri.open('''
		uri "http://sadl.imp/shapes_specific".
		import "file://shapes-top.sadl" as shapes-top.

		Circle is a type of Shape,
		        described by radius with values of type float.

		Rectangle is a type of Shape,
		       described by height with values of type float,
		        described by width with values of type float.''');
		
		assertEquals('''
		«uriConverter.createFileUri(file)» ->
		 * [[1, 7] .. [1, 31]] -> [28]
		 * [[0, 4] .. [0, 37]] -> [28]
		 * [[3, 0] .. [3, 6]] -> [29]
		 * [[3, 20] .. [3, 25]] -> [30]
		 * [[4, 21] .. [4, 27]] -> [35]
		 * [[6, 0] .. [6, 9]] -> [29]
		 * [[6, 23] .. [6, 28]] -> [30]
		 * [[7, 20] .. [7, 26]] -> [35]
		 * [[8, 21] .. [8, 26]] -> [35]''', coloringParams.toExpectation);
	}

	@Test
	def void checkColoring_03() {
		val file = root.toPath.resolve('''MyModel.«fileExtension»''').toFile;
		val uri = file.toURI.toString;
		
		uri.open('''
		uri "http://sadl.imp/shapes_test" .
		import "file://shape-rules.sadl" as shape-rules.

		MyCircle is a Circle, has radius 3.5 .

		MyRect is a Rectangle, has height 3.5, has width 4.5.

		Test: MyCircle has area 38.48 .''');
		
		assertEquals('''
		«uriConverter.createFileUri(file)» ->
		 * [[1, 7] .. [1, 32]] -> [28]
		 * [[0, 4] .. [0, 33]] -> [28]
		 * [[3, 0] .. [3, 8]] -> [31]
		 * [[3, 14] .. [3, 20]] -> [30]
		 * [[3, 26] .. [3, 32]] -> [30]
		 * [[5, 0] .. [5, 6]] -> [31]
		 * [[5, 12] .. [5, 21]] -> [30]
		 * [[5, 27] .. [5, 33]] -> [30]
		 * [[5, 43] .. [5, 48]] -> [30]
		 * [[7, 6] .. [7, 14]] -> [31]
		 * [[7, 19] .. [7, 23]] -> [30]''', coloringParams.toExpectation);
	}

	@Override
	override protected initialize() {
		val rootPath = root.absoluteFile.toPath;
		projectStructureInitializer.initialize(rootPath);
		super.initialize();
	}

}
