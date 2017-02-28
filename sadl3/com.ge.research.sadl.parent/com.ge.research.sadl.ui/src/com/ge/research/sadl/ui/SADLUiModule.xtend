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
package com.ge.research.sadl.ui

import com.ge.research.sadl.ui.contentassist.SadlReferenceProposalCreator
import com.ge.research.sadl.ui.editor.SadlCopyQualifiedNameService
import com.ge.research.sadl.ui.preferences.SadlPreferencesInitializer
import com.ge.research.sadl.ui.preferences.SadlRootPreferencePage
import com.ge.research.sadl.ui.syntaxcoloring.SadlHighlightingConfiguration
import com.ge.research.sadl.ui.syntaxcoloring.SadlSemanticHighlightingCalculator
import com.ge.research.sadl.ui.syntaxcoloring.SadlTokenToAttributeIdMapper
import com.google.inject.Binder
import com.google.inject.name.Names
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.xtext.ide.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.ui.editor.contentassist.AbstractJavaBasedContentProposalProvider.ReferenceProposalCreator
import org.eclipse.xtext.ui.editor.copyqualifiedname.CopyQualifiedNameService
import org.eclipse.xtext.ui.editor.preferences.IPreferenceStoreInitializer
import org.eclipse.xtext.ui.editor.preferences.LanguageRootPreferencePage
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration

/**
 * Use this class to register components to be used within the Eclipse IDE.
 */
//@FinalFieldsConstructor class SADLUiModule extends AbstractSADLUiModule {

class SADLUiModule extends AbstractSADLUiModule {

	new(AbstractUIPlugin plugin) {
		super(plugin);
		OutputStreamStrategy.SADL.use;
	}

	// Registers our own syntax coloring styles.
	def Class<? extends IHighlightingConfiguration> bindILexicalHighlightingConfiguration() {
		return SadlHighlightingConfiguration
	}

	// Maps our Ecore nodes to our syntax coloring styles.
	def Class<? extends ISemanticHighlightingCalculator> bindISemanticHighlightingCalculator() {
		return SadlSemanticHighlightingCalculator
	}

	// Maps our token names to our syntax coloring styles.
	def Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindTokenToAttributeIdMapper() {
		return SadlTokenToAttributeIdMapper
	}
	
	def void configurePreferenceInitializer(Binder binder) {
        binder.bind(IPreferenceStoreInitializer).annotatedWith(Names.named("sadlPreferenceInitializer")).to(
            SadlPreferencesInitializer)
    }
	
	// registers our own root preference page.
	def Class<? extends LanguageRootPreferencePage> bindLanguageRootPreferencePage() {
    	return SadlRootPreferencePage
	}
	
	override Class<? extends CopyQualifiedNameService> bindCopyQualifiedNameService() {
		return SadlCopyQualifiedNameService;
	}
	
	def Class<? extends ReferenceProposalCreator> bindReferenceProposalCreator() {
		return SadlReferenceProposalCreator;
	}
	
}