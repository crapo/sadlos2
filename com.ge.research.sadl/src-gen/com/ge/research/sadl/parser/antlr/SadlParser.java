/*
* generated by Xtext
*/
package com.ge.research.sadl.parser.antlr;

import com.google.inject.Inject;

import org.eclipse.xtext.parser.antlr.XtextTokenStream;
import com.ge.research.sadl.services.SadlGrammarAccess;

public class SadlParser extends org.eclipse.xtext.parser.antlr.AbstractAntlrParser {
	
	@Inject
	private SadlGrammarAccess grammarAccess;
	
	@Override
	protected void setInitialHiddenTokens(XtextTokenStream tokenStream) {
		tokenStream.setInitialHiddenTokens("RULE_WS", "RULE_ML_COMMENT", "RULE_SL_COMMENT");
	}
	
	@Override
	protected com.ge.research.sadl.parser.antlr.internal.InternalSadlParser createParser(XtextTokenStream stream) {
		return new com.ge.research.sadl.parser.antlr.internal.InternalSadlParser(stream, getGrammarAccess());
	}
	
	@Override 
	protected String getDefaultRuleName() {
		return "Model";
	}
	
	public SadlGrammarAccess getGrammarAccess() {
		return this.grammarAccess;
	}
	
	public void setGrammarAccess(SadlGrammarAccess grammarAccess) {
		this.grammarAccess = grammarAccess;
	}
	
}