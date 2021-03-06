/************************************************************************
 * Copyright © 2007-2017 - General Electric Company, All Rights Reserved
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
package com.ge.research.sadl.ui.tests.contentassist

import com.ge.research.sadl.preferences.SadlPreferences
import org.eclipse.xtext.preferences.PreferenceKey
import org.junit.Ignore
import org.junit.Test

/**
 * Plug-in tests for the SADL content assist.
 * 
 * @author akos.kitta
 */
class SadlContentAssistTest extends AbstractSadlContentAssistTest {

	/** Primitive primary type reference. */
	@Test
	def void checkCA_01_PrimaryType_Negative() {
		newBuilder('''uri "http://myUri". Foo is a class. myFoo is a ''').assertProposalIsNot('integer');
	}

	/** Primary type reference. */
	@Test
	def void checkCA_02_PrimaryType_Positive() {
		newBuilder('''uri "http://myUri". Foo is a class. myFoo is a ''').assertProposal('Foo');
	}

	/** Imported primary type reference. */
	@Test
	def void checkCA_03_PrimaryType_Positive() {
		newBuilder('''uri "http://myUri". import "http://barUri". Foo is a class. myFoo is a ''').assertProposal('Bar');
	}

	/** Self primary type reference with imports. */
	@Test
	def void checkCA_04_PrimaryType_Positive() {
		newBuilder('''uri "http://myUri". import "http://barUri". Foo is a class. myFoo is a ''').assertProposal('Foo');
	}

	/** Not visible primary type reference with imports. */
	@Test
	def void checkCA_05_PrimaryType_Negative() {
		newBuilder('''uri "http://myUri". import "http://barUri". Foo is a class. myFoo is a ''').
			assertProposalIsNot('NotVisible');
	}

	/** Property check with imports. */
	@Test
	def void checkCA_06_Property_Positive() {
		newBuilder('''uri "http://myUri". import "http://circle". import "http://rectangle". C is a Circle with ''').
			assertProposal('radius');
	}

	/** Property check with imports. */
	@Test
	def void checkCA_06b_Property_Positive() {
		newBuilder('''uri "http://myUri". import "http://circle". import "http://rectangle". C is a Circle. C has ''').
			assertProposal('radius');
	}

	/** Negative property check with imports. */
	@Test
	def void checkCA_07_Property_Negative() {
		newBuilder('''uri "http://myUri". import "http://circle". import "http://rectangle". C is a Circle with ''').
			assertProposalIsNot('width');
	}

	/** Super type element. */
	@Test
	def void checkCA_08_SuperElment_Positive() {
		newBuilder('''uri "http://myUri". Person is a class. {Man, Woman} are types of ''').assertProposal('Person');
	}

	/** Super type element. */
	@Test
	def void checkCA_09_SuperElment_Negative() {
		newBuilder('''uri "http://myUri". Person is a class. {Man, Woman} are types of ''').assertProposalIsNot('Man');
	}

	/** Subject of property in test statement. */
	@Test
	def void checkCA_10_SubjectOfProperty_Positive() {
		newBuilder('''uri "http://myUri". import "http://circle". import "http://rectangle". Test: width of ''').
			assertProposal('Rectangle');
	}

	/** Subject of property in test statement. */
	@Test
	def void checkCA_11_SubjectOfProperty_Negative() {
		// Instead of importing `Shape`, `Circle`, and `Rectangle`, this model defines them in place: https://github.com/crapo/sadlos2/issues/407
		newBuilder('''uri "http://myUri". Shape is a class described by area with values of type float. Rectangle is a type of Shape, described by height with values of type float, described by width with values of type float. Circle is a type of Shape described by radius with values of type float. Test: width of ''').
			assertProposalIsNot('Circle');
	}

	/** Subject of property in test statement. */
	@Test
	def void checkCA_12_PropertyInTestStatement_Positive() {
		newBuilder('''uri "http://myUri". import "http://circle". import "http://rectangle". Test: ''').
			assertProposal('width');
	}

	/** Subject of property in test statement. */
	@Test
	def void checkCA_13_PropertyInTestStatement_Negative() {
		newBuilder('''uri "http://myUri". import "http://circle". import "http://rectangle". Test: ''').
			assertProposalIsNot('Circle');
	}

	/** Property initializer value. */
	@Test
	def void checCA_14_PropertyInitializerValue_Positive() {
		newBuilder('''uri "http://myUri". Foo is a class described by p1 with values of type Foo. myFoo is a Foo with p1 ''').
			assertProposal('myFoo');
	}

	/** Property initializer value. */
	@Test
	def void checCA_14b_PropertyInitializerValue_Positive() {
		newBuilder('''uri "http://myUri". 
					  Bar is a class.
					  MyBar is a Bar.
					  Foo is a class described by p1 with values of type Bar. 
					  MyFoo is a Foo with p1 ''').
			assertProposal('MyBar');
	}

	/** Property initializer value. */

	@Test
	def void checCA_14c_PropertyInitializerValue_Positive() {
		newBuilder('''uri "http://myUri". 
					  Bar is a class.
					  MyBar is a Bar.
					  Foo is a class described by p1 with values of type Bar. 
					  MyFoo is a Foo with p1 M''').
			assertProposal('MyBar');
	}
	
	@Test
	def void checCA_14d_PropertyInitializerValue_Positive() {
		newBuilder('''uri "http://sadl.org/DateTimeConversion.sadl" alias datetimeconversion.
					  Artifact is a class described by generatedAtTime with values of type dateTime .
		              MyArtifact is an Artifact with generatedAtTime ''').
			assertProposal('"MM/DD/YYYY hh:mm:ss PM TZD"');
	}
	
	/** Super element with `type of`. */
	@Test
	def void checkCA_15_SuperElement_IsATypeOf_Positive() {
		newBuilder('''uri "http://myUri". Foo is a class. Bar is a type of ''').assertProposal('Foo');
	}

	/** Super element with `type of`. */
	@Test
	def void checkCA_16_SuperElement_IsATypeOf_Negative() {
		newBuilder('''uri "http://myUri". Foo is a class. Bar is a type of ''').assertProposalIsNot('Bar');
	}

	/** Instance declaration. */
	@Test
	def void checkCA_17_InstanceDeclaration1() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of type float .
					   MyShape is a  ''').assertProposal('Shape');
	}
	
	/** Instance declaration. */
	@Test
	def void checkCA_17_InstanceDeclaration2() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of type float .
					   MyShape is a  ''').assertProposalIsNot('float');
	}
	
	/** Keywords in range definition */
	@Test
	def void checkCA_18_RangeKeyword1() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area ''').assertProposal('with');
	}

	/** Keywords in range definition */
	@Test
	def void checkCA_19_RangeKeyword2() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with ''').assertProposal('values');
	}
	
	/** Keywords in range definition */
	@Test
	def void checkCA_20_RangeKeyword3() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values ''').assertProposal('of');
	}
	
	/** Keywords in range definition */
	@Test
	def void checkCA_21_RangeKeyword4() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of ''').assertProposal('type');
	}
	
	/** Keywords in range definition */
	@Test
	def void checkCA_22_Range1() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of type ''').assertProposal('Shape');
	}
	
	/** Keywords in range definition */
	@Test
	def void checkCA_23_Range2() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of type ''').assertProposal('float');
	}
	
	/** Keywords NOT in declaration */
	@Test
	def void checkCA_24_DeclarationCompletion() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of type float.
					   MyShape is a ''').assertProposal('Shape');
	}
	
	/** Completion after start of input */
	@Test
	def void checkCA_25_DeclarationCompletion() {
		newBuilder(''' uri "http://sadl.org/classes.sadl" alias clses.
					   Shape is a class described by area with values of type float.
					   MyShape is a Sh''').assertProposal('Shape');
	}

	@Test
	def void checkCA_26_ImplicitModelIsNotFiltered() {
		newBuilder('''uri "http://myUri". Foo is a class. myFoo describes ''').assertProposal('ScientificConcept');
	}

	@Test
	def void checkCA_27_ImplicitModelCanBeFiltered() {
		val key = new PreferenceKey(SadlPreferences.CONTENT_ASSIST__FILTER_IMPLICIT_MODEL.id, Boolean.TRUE.toString);
		updatePreference(key);
		newBuilder('''uri "http://myUri". Foo is a class. myFoo describes ''').assertProposalIsNot('ScientificConcept');
	}

	@Test
	def void checkCA_28_NoPrimitivesAtdDomainOfAnyProperty() {
		// https://github.com/crapo/sadlos2/issues/406
		val builder = newBuilder('''uri "http://myUri". Engine is a class. engine describes ''');
		builder.assertProposalIsNot('double');
		builder.assertProposal('Engine');
	}

	@Test
	def void checCA_14e_PropertyInitializerValue_Positive() {
		val builder = newBuilder('''uri "http://sadl.org/AdamsFamily.sadl" alias adamsfamily.
					  Gender is a class, must be one of {Male, Female}.
					  Person is a class described by gender with values of type Gender.
					  JohnAdams (alias "John Adams") is a Person, 
					  with gender  ''');
			builder.assertProposal('Male');
			builder.assertProposal('Female');
			builder.assertProposalIsNot('literalString');
	}
	
	@Test
	def void checkCA_29_PrimitivesInRanges() {
		// https://github.com/crapo/sadlos2/issues/406
		val builder = newBuilder('''uri "http://myUri". Aircraft is a class. engine describes Aircraft with values of type ''');
		builder.assertProposal('Aircraft');
		builder.assertProposal('double');
	}

	@Test
	def void checkCA_30_CanProposeIsAForClassOrPropertyDeclaration() {
		// https://github.com/crapo/sadlos2/issues/406#issuecomment-597610402
		newBuilder('''uri "http://myUri". Foo is ''').assertProposal('a');
	}

	@Test
	def void checkCA_31_CanProposeSadlResourcesOnTopLevel() {
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Artefact is a class.
			part describes Artefact with values of type Artefact.
			Aircraft is a type of Artefact.
			Engine is a type of Artefact.
		''');
		builder.assertProposal('Artefact');
		builder.assertProposal('part');
		builder.assertProposal('Aircraft');
		builder.assertProposal('Engine');
		// And we have the keywords too.
		builder.assertProposal('Ask');
		builder.assertProposal('Equation');
		// etc.
	}

	@Test
	def void checkCA_32_CanProposeCardinalityValue() {
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Artefact is a class.
			part describes Artefact with values of type Artefact.
			Aircraft is a type of Artefact.
			Engine is a type of Artefact.
			part of Aircraft has at least 
		''');
		builder.assertProposal('one');
		builder.assertProposal('2');
		builder.assertProposal('CARDINALITY');
	}

	@Ignore('This works correctly from Eclipse-IDE, not from the test :( we have one less CA context, most likely the setup in parent class incomplete.')
	@Test
	def void checkCA_33_AlwaysRunContextWithPrefixWhenFilteringCrossRefs() {
		// https://github.com/crapo/sadlos2/issues/406#issuecomment-597622176
		val builder = newBuilder('''
			uri "http://sadl.org/y.sadl".
			Artefact is a class.
			Aircraft is a type of Artefact.
			W_IsSomethingWithW is a class.
			IsSomethingWithoutW is a class.
			MyAircraft is an Aircraft w
		''');
		builder.assertProposal('W_IsSomethingWithW');
		builder.assertProposal('with');
		builder.assertProposalIsNot('IsSomethingWithoutW');
	}

	@Test
	def void checkCA_DescribbedBy() {
		// https://github.com/crapo/sadlos2/issues/412#issue-583680230
		val builder = newBuilder('''
			uri "http://sadl.org/ca.sadl".
			area is a property with values of type float.
			Shape is a class described by 
		''');
		builder.assertProposal('area');
		builder.assertProposalIsNot('Shape');
		builder.assertProposalIsNot('sin')
	}

	@Test
	def void checkCA_PofS() {
		// https://github.com/crapo/sadlos2/issues/407
		val key = new PreferenceKey(SadlPreferences.TYPE_CHECKING_WARNING_ONLY.id, Boolean.TRUE.toString);
		updatePreference(key);
		
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Shape is a class described by area with values of type float.
			Rectangle is a type of Shape, described by height with values of type float, described by width with values of type float.
			Circle is a type of Shape described by radius with values of type float.
			Test: width of 
		''');
		builder.assertProposal('Rectangle');
		builder.assertProposalIsNot('Circle');
	}

	@Test
	def void checkCA_disjoint() {
		// https://github.com/crapo/sadlos2/issues/407
		val key = new PreferenceKey(SadlPreferences.TYPE_CHECKING_WARNING_ONLY.id, Boolean.TRUE.toString);
		updatePreference(key);
		
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Singer is a class.
			Musician is a class.
			{Singer, Instrumentalist} are types of Musician.
			WindInstrumentalist is a type of Instrumentalist.
			Singer and 
		''');
		builder.assertProposal('WindInstrumentalist');
	}

	@Test
	def void checkCA_disjoint2() {
		// https://github.com/crapo/sadlos2/issues/407
		val key = new PreferenceKey(SadlPreferences.TYPE_CHECKING_WARNING_ONLY.id, Boolean.TRUE.toString);
		updatePreference(key);
		
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Singer is a class.
			Instrumentalist is a class.
			Musician is a class.
			Musician is the same as {Singer or Instrumentalist}.
			WindInstrumentalist is a type of Instrumentalist.
			Singer and 
		''');
		builder.assertProposal('WindInstrumentalist');
	}

	@Test
	def void checkCA_disjoint3() {
		// https://github.com/crapo/sadlos2/issues/407
		val key = new PreferenceKey(SadlPreferences.TYPE_CHECKING_WARNING_ONLY.id, Boolean.TRUE.toString);
		updatePreference(key);
		
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Singer is a class.
			Instrumentalist is a class.
			Musician is a class.
			Musician is the same as {Singer or Instrumentalist}.
			WindInstrumentalist is a type of Instrumentalist.
			{Singer, 
		''');
		builder.assertProposal('WindInstrumentalist');
	}
	
		@Test
	def void checkCA_disjoint4() {
		// https://github.com/crapo/sadlos2/issues/407
		val key = new PreferenceKey(SadlPreferences.TYPE_CHECKING_WARNING_ONLY.id, Boolean.TRUE.toString);
		updatePreference(key);
		
		val builder = newBuilder('''
			uri "http://sadl.org/x.sadl".
			Singer is a class.
			Instrumentalist is a class.
			Musician is a class.
			Musician is the same as {Singer or Instrumentalist}.
			WindInstrumentalist is a type of Instrumentalist.
			PresidentOfUSA is a class.
			GeorgeWashington is a PresidentOfUSA.
			
			{  
		''');
		builder.assertProposal('WindInstrumentalist');
		builder.assertProposal('GeorgeWashington');
		builder.assertProposalIsNot('max');
	}
	
	@Test
	def void checkCA_disjoint5() {
		// https://github.com/crapo/sadlos2/issues/407
		val key = new PreferenceKey(SadlPreferences.TYPE_CHECKING_WARNING_ONLY.id, Boolean.TRUE.toString);
		updatePreference(key);
		
		val builder = newBuilder('''
			 uri "http://sadl.org/BasicSetTheory2.sadl" alias bst2.
			 
			 PresidentOfUSA is a class .
			 MilitaryCommander is a class.
			
			 GeorgeWashington is a {PresidentOfUSA and MilitaryCommander}.
			 
			 Singer is a class.
			 Instrumentalist is a class.
			 Musician is a class.
			 Musician is the same as {Singer or Instrumentalist}.
			 
			 WindInstrumentalist is a type of Instrumentalist.
			// Singer and 
			//{Singer, WindInstrumentalist} are disjoint .  
			{ 
		''');
		builder.assertProposal('WindInstrumentalist');
		builder.assertProposal('GeorgeWashington');
		builder.assertProposalIsNot('max');
	}
	
	@Test
	def void checkCA_sameAs() {
		val builder = newBuilder('''
			 uri "http://sadl.org/SameAsProperties.sadl" alias sap.
			 
			 Person is a class described by child with values of type Person,
			 	described by age with values of type int.
			 
			 offspring is the same as 
		''');
		builder.assertProposal('Person');
		builder.assertProposal('child');
		builder.assertProposal('age');
	}
	
	@Test
	def void checkCA_sameAsNot() {
		val builder = newBuilder('''
			 uri "http://sadl.org/SameAsProperties.sadl" alias sap.
			 
			 Person is a class described by child with values of type Person,
			 	described by age with values of type int.
			 
			 offspring is the same as not 
		''');
		builder.assertProposal('Person');
		builder.assertProposalIsNot('child');
		builder.assertProposalIsNot('age');
	}
	
	@Test
	def void checkCA_subject_has() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Logic1b.sadl" alias l1b.
		 
		 Person is a class described by dateOfBirth with values of type date .
		 
		 PresidentOfUSA is a type of Person.
		 
		 wife describes Person with values of type Person.
		 
		 GeorgeWashington (alias "George Washington") is a PresidentOfUSA.
		 MarthDandridge (alias "Martha Dandridge") is a Person.
		 
		GeorgeWashington has 
		''');
		builder.assertProposalIsNot('default');
		builder.assertProposal('wife');
		builder.assertProposal('dateOfBirth');
		builder.assertProposalIsNot('Person');
		builder.assertProposalIsNot('GeorgeWashington');
		builder.assertProposalIsNot('one')
	}
	
	@Test
	def void checkCA_subject_has2() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Logic1b.sadl" alias l1b.
		 
		 Person is a class described by dateOfBirth with values of type date .
		 
		 PresidentOfUSA is a type of Person.
		 
		 wife describes Person with values of type Person.
		 
		 Rock is a class described by density with values of type float.
		 
		 GeorgeWashington (alias "George Washington") is a PresidentOfUSA.
		 MarthDandridge (alias "Martha Dandridge") is a Person.
		 
		GeorgeWashington has 
		''');
		builder.assertProposal('wife');
		builder.assertProposal('dateOfBirth');
		builder.assertProposalIsNot('Person');
		builder.assertProposalIsNot('GeorgeWashington');
		builder.assertProposalIsNot('density')
	}
	
	@Test
	def void checkCA_subject_has3() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Logic1b.sadl" alias l1b.
		 
		 Person is a class described by dateOfBirth with values of type date .
		 
		 PresidentOfUSA is a type of Person.
		 
		 wife describes Person with values of type Person.
		 
		 Rock is a class described by density with values of type float.
		 
		 GeorgeWashington (alias "George Washington") is a PresidentOfUSA.
		 MarthDandridge (alias "Martha Dandridge") is a Person.
		 
		GeorgeWashington has wife 
		''');
		builder.assertProposal('MarthDandridge');
	}
	
	@Test
	def void checkCA_subject_has4() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Logic1b.sadl" alias l1b.
		 
		 Person is a class described by dateOfBirth with values of type date .
		 
		 PresidentOfUSA is a type of Person.
		 
		 wife describes Person with values of type Person.
		 
		 Rock is a class described by density with values of type float.
		 
		 GeorgeWashington (alias "George Washington") is a PresidentOfUSA.
		 MarthDandridge (alias "Martha Dandridge") is a Person.
		 
		GeorgeWashington has wife M''');
		builder.assertProposal('MarthDandridge');
	}
	
	@Test
	def void checkCA_subject_has5() {
		val builder = newBuilder('''
		uri "http://sadl.org/Logic1b.sadl" alias l1b.
		
		Person is a class described by dateOfBirth with values of type date .
		
		Rock is a class described by density with values of type float.
		
		GeorgeWashington (alias "George Washington") is a Person.
		
		GeorgeWashington has dateOfBirth 
		''');
		builder.assertProposal('"MM/DD/YYYY"');
	}
	
	@Test
	def void checkCA_subject_has6() {
		val builder = newBuilder('''
		uri "http://sadl.org/Logic1b.sadl" alias l1b.
		
		Rock is a class described by density with values of type float.
		
		MyRock is a Rock, has density  
		''');
		builder.assertProposal('123.4');
	}
	
	@Test
	def void checkCA_subject_has7() {
		val builder = newBuilder('''
		uri "http://sadl.org/Logic1b.sadl" alias l1b.
		
		Rock is a class described by color with values of type string.
		
		MyRock is a Rock, has color 
		''');
		builder.assertProposal('"<color-value>"');
	}
	
	@Test
	def void checkCA_subject_has8() {
		val builder = newBuilder('''
		uri "http://sadl.org/Logic1b.sadl" alias l1b.
		
		Rock is a class described by shinny with values of type boolean.
		
		MyRock is a Rock, has shinny 
		''');
		builder.assertProposal('true');
		builder.assertProposal('false');
	}
	
	@Test
	def void checkCA_subject_has9() {
		val builder = newBuilder('''
			 uri "http://sadl.org/Owl2b.sadl" alias owl2b.
			 
			 Person is a class.
			 {Man, Woman} are types of Person.
			 
			 Marriage is a class described by husband with values of type Man,
			 	described by wife with values of type Woman
			 	described by ^date with values of type date,
			 	described by location with values of type string.
			 	
			GeorgeWashington is a Man.
			MarthaDandridge is a Woman.
			
			 A Marriage with husband GeorgeWashington, 
			 	with wife 
		''');
		builder.assertProposal('MarthaDandridge');
		builder.assertProposalIsNot('GeorgeWashington');
		builder.assertProposalIsNot('acos');
	}
	
	@Test
	def void checkCA_is_a() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Concepts.sadl" alias Concepts.
		 
		 Person is a class described by birthdate with a single value of type date .
		 {Man, Woman} are types of Person.
		 
		 Gender is a class, must be one of {Male, Female}.
		 
		 Man and Woman are disjoint .
		 
		 Person is ''');
		 
		 builder.assertProposal('a');
		 builder.assertProposalIsNot('acos');
		 builder.assertProposalIsNot('Gender');
	}
	
	@Test
	def void checkCA_is_a2() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Concepts.sadl" alias Concepts.
		 
		 Person is a class described by birthdate with a single value of type date .
		 {Man, Woman} are types of Person.
		 
		 Gender is a class, must be one of {Male, Female}.
		 
		 Man and Woman are disjoint .
		 
		 Person is a ''');
		 
		 builder.assertProposal('type');
		 builder.assertProposalIsNot('Person');	// Person is already defined, shouldn't define again
		 builder.assertProposalIsNot('acos');
	}
	
	@Test
	def void checkCA_is_a3() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Concepts.sadl" alias Concepts.
		 
		 Person is a class described by birthdate with a single value of type date .
		 {Man, Woman} are types of Person.
		 
		 Gender is a class, must be one of {Male, Female}.
		 
		 Man and Woman are disjoint .
		 
		 NewName is ''');
		 
		 builder.assertProposal('a');
		 builder.assertProposalIsNot('acos');
		 builder.assertProposalIsNot('Gender');
		 builder.assertProposalIsNot('birthdate');
	}
	
	@Test
	def void checkCA_is_a4() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Concepts.sadl" alias Concepts.
		 
		 Person is a class described by birthdate with a single value of type date .
		 {Man, Woman} are types of Person.
		 
		 Gender is a class, must be one of {Male, Female}.
		 
		 Man and Woman are disjoint .
		 
		 NewName is a ''');
		 
		 builder.assertProposal('type');
		 builder.assertProposal('class');
		 builder.assertProposal('Person');
		 builder.assertProposalIsNot('acos');
	}
	
	@Test
	def void checkCA_inverse_of() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Concepts.sadl" alias Concepts.
		 
		 Person is a class.
		 Place is a class.

		 ownedBy describes Place with values of type Person.
		 owns describes Person with values of type Place.
		 ownedBy is the inverse of ''');
		 
		 builder.assertProposal('owns');
		 builder.assertProposalIsNot('ownedBy');
		 builder.assertProposalIsNot('Person');
		 builder.assertProposalIsNot('acos');
	}
	
	@Test
	def void checkCA_HasValueValue01() {
		val builder = newBuilder('''
		  uri "http://sadl.org/Genealogy1.sadl" alias gen1.
		  
		  Gender is a class, must be one of {Male, Female}.
		  Person is a class described by gender with values of type Gender,
		  	described by dateOfBirth with values of type date,
		  	described by age with values of type nonNegativeInteger,
		  	described by parent with values of type Person.
		  	
		  A Person is a Woman only if gender always has value ''');
		 
		 builder.assertProposal('Female');
		 builder.assertProposalIsNot('Gender');
		 builder.assertProposalIsNot('Person');
		 builder.assertProposalIsNot('acos');
	}
	
	@Test
	def void checkCA_HasValueValue02() {
		val builder = newBuilder('''
		  uri "http://sadl.org/Genealogy1.sadl" alias gen1.
		  
		  Gender is a class, must be one of {Male, Female}.
		  Person is a class described by gender with values of type Gender,
		  	described by dateOfBirth with values of type date,
		  	described by age with values of type nonNegativeInteger,
		  	described by parent with values of type Person.
		  Woman is a class.	
		  gender of Woman always has value ''');
		 
		 builder.assertProposal('Female');
		 builder.assertProposalIsNot('Gender');
		 builder.assertProposalIsNot('Person');
		 builder.assertProposalIsNot('false');		 
		 builder.assertProposalIsNot('known');
		 builder.assertProposalIsNot('PI');
		 builder.assertProposalIsNot('e');
	}
	
	@Ignore ("lots to work out with CA in rules...")
	@Test
	def void checkCA_Rule01() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Genealogy1.sadl" alias gen1.
		 
		 Gender is a class, must be one of {Male, Female}.
		 Person is a class described by gender with values of type Gender,
		 	described by dateOfBirth with values of type date,
		 	described by age with values of type nonNegativeInteger,
		 	described by parent with values of type Person.
		 	
		 A Person is a Woman only if gender always has value Female.
		 A Person is a Man only if gender always has value Male. 	
		 	
		 child describes Person with values of type Person.
		 spouse describes Person with values of type Person.
		 spouse of Person has at most 1 value.
		 sibling describes Person with values of type Person.
		 
		 spouse is symmetrical .
		 sibling is symmetrical .
		  Rule SiblingRule:
		  	if x is a Person and x has parent ''');
		 
		 builder.assertProposal('Female');
		 builder.assertProposalIsNot('Gender');
		 builder.assertProposalIsNot('Person');
		 builder.assertProposalIsNot('false');		 
		 builder.assertProposalIsNot('known');
		 builder.assertProposalIsNot('PI');
		 builder.assertProposalIsNot('e');
	}
	
	@Test
	def void checkCA_alias() {
		val builder = newBuilder('''
		 uri "http://sadl.org/Logic1b.sadl" alias 
		''');
		builder.assertProposal('checkca_alias');
	}
	
}
