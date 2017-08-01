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
/*
 * generated by Xtext 2.9.0-SNAPSHOT
 */
package com.ge.research.sadl.tests

import com.ge.research.sadl.sADL.SadlModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(SADLNoopModelProcessorsInjectorProvider)
abstract class AbstractSADLParsingTest extends AbstractSadlTest {
		
	protected def void assertNoErrors(CharSequence text) {
		val model = parseHelper.parse(text)
		val issues = validate(model)
		if (issues.isEmpty)
			return;
		var String annotatedText = text.toString
		for (issue : issues.filter[isSyntaxError].sortBy[-offset]) {
			annotatedText = annotatedText.substring(0, issue.offset) + '''[«issue.message»]''' + annotatedText.substring(issue.offset)
		}
		Assert.assertEquals(text.toString, annotatedText)
	}
	
	protected def void assertErrors(CharSequence text, String[] errPartials) {
		val model = parseHelper.parse(text)
		val issues = validate(model)
		Assert.assertFalse(issues.isEmpty)
		Assert.assertEquals(issues.size, 1)
		for (err : errPartials) {
			var found = false
			for (issue : issues) {
				if (issue.message.contains(err)) {
					found = true
				}
			}
			Assert.assertTrue(found)
		}
	}

	def void assertAST(CharSequence text, (SadlModel)=>void assertion) {
		val model = parseHelper.parse(text)
		assertNoErrors(model)
		assertion.apply(model)
	}
	
	def String prependUri(CharSequence sequence) {
		return '''
			«model»
			«sequence»
		'''
	}
	
	protected def String model() {
		val name = Thread.currentThread.stackTrace.findFirst[className!=AbstractSADLParsingTest.simpleName].methodName
		return '''uri "http://sadl.org/TestSadl/«name»" alias «name».'''
	}

	protected def void assertNoErrors(Resource resource) {
		val issues = validate(resource).toList.sortBy[-(offset?:0)]
		val text = (resource as XtextResource).parseResult.rootNode.text
		var errorText = text
		if (text === null) {
			issues.head.data
			Assert.fail(issues.join(',')[message])
		}
		for (issue : issues) {
			if (issue.offset === null || issue.length === null) {
				errorText = errorText+"\n!["+issue.message+"] ATTENTION : The produced issue doesn't have an offset or length attached!"
			} else {
				errorText = errorText.substring(0, issue.offset)+"!"+errorText.substring(issue.offset, issue.offset + issue.length)+"!["+issue.message+"]"+errorText.substring(issue.offset+issue.length)
			}
		}
		Assert.assertEquals(text, errorText)
	}
	
	protected def void assertOnlyWarningsOrInfo(Resource resource) {
		val issues = validate(resource).toList.sortBy[-(offset?:0)]
		val text = (resource as XtextResource).parseResult.rootNode.text
		var errorText = text
		if (text === null) {
			issues.head.data
			Assert.fail(issues.join(',')[message])
		}
		for (issue : issues) {
			if (issue.severity == Severity.ERROR) {
				if (issue.offset === null || issue.length === null) {
					errorText = errorText+"\n!["+issue.message+"] ATTENTION : The produced issue doesn't have an offset or length attached!"
				} else {
					errorText = errorText.substring(0, issue.offset)+"!"+errorText.substring(issue.offset, issue.offset + issue.length)+"!["+issue.message+"]"+errorText.substring(issue.offset+issue.length)
				}
			}
		}
		Assert.assertEquals(text, errorText)
	}
	
	protected def void assertError(Resource resource, String error) {
		val issues = validate(resource).toList.sortBy[-(offset?:0)]
		val text = (resource as XtextResource).parseResult.rootNode.text
		var errorText = text
		if (text === null) {
			issues.head.data
			Assert.fail(issues.join(',')[message])
		}
		var errorFound = false
		for (issue : issues) {
			if (!errorFound && issue.severity == Severity.ERROR) {
				if (issue.offset === null || issue.length === null) {
					errorText = errorText+"\n!["+issue.message+"] ATTENTION : The produced issue doesn't have an offset or length attached!"
				}
				else if (issue.message.startsWith(error)) {
					errorFound = true
				} else {
					errorText = errorText.substring(0, issue.offset)+"!"+errorText.substring(issue.offset, issue.offset + issue.length)+"!["+issue.message+"]"+errorText.substring(issue.offset+issue.length)
				}
			}
		}
		Assert.assertEquals(text, errorText)
	}
	
}
