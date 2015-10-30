package com.ge.research.sadl.tests.model

import com.ge.research.sadl.jena.ModelManager
import com.ge.research.sadl.model.SadlManagerProvider
import com.ge.research.sadl.sADL.SadlModel
import com.ge.research.sadl.tests.SADLInjectorProvider
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.runner.RunWith
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(SADLInjectorProvider)
class SadlModelManagerProviderTest {
	
	@Inject ParseHelper<SadlModel> parser
	@Inject ValidationTestHelper validationTestHelper
	@Inject SadlManagerProvider managerProvider
	
	@Test def void myFirstTestCase() {
		'''
			uri "my/uri".
			Foo is a class.
		'''.assertTranslatesTo [ modelManager |
			// expectations go here
			assertEquals("my/uri", modelManager.getModelBaseURI())
		]
	}
	
	@Test def void importTestCase() {
		'''
			uri "http://sadl.org/model1" alias m1.
			import "http://sadl.org/model2".
			Foo is a class.
		'''.assertTranslatesTo [ modelManager |
			// expectations go here
			assertEquals("http://sadl.org/model1", modelManager.getModelBaseURI())
			assertEquals("m1", modelManager.getModelAlias());
			assertTrue(modelManager.getOrderedImports().size() == 1);
			assertEquals("http://sadl.org/model2", modelManager.getOrderedImports.get(0).getUri());
		]
	}
	
	protected def void assertTranslatesTo(CharSequence code, (ModelManager)=>void assertions) {
		val model = parser.parse(code)
		validationTestHelper.assertNoErrors(model)
		managerProvider.getModelManager(model.eResource,  CancelIndicator.NullImpl)		
	}
}