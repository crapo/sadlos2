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
package com.ge.research.sadl.preferences;

import java.util.Arrays;
import java.util.List;

import org.eclipse.xtext.preferences.PreferenceKey;

import com.ge.research.sadl.model.SadlSerializationFormat;

@SuppressWarnings("restriction")
public class SadlPreferences {
	
	public static final PreferenceKey SADL_BASE_URI= new PreferenceKey("baseUri", "http://sadl.org");
	public static final PreferenceKey OWL_MODEL_FORMAT = new PreferenceKey("OWL_Format", SadlSerializationFormat.RDF_XML_ABBREV_FORMAT);
	public static final PreferenceKey RDF_XML_FORMAT = new PreferenceKey(SadlSerializationFormat.RDF_XML_FORMAT, ""); // default
	public static final PreferenceKey RDF_XML_ABBREV_FORMAT = new PreferenceKey(SadlSerializationFormat.RDF_XML_ABBREV_FORMAT, "");
	public static final PreferenceKey N_TRIPLE_FORMAT = new PreferenceKey(SadlSerializationFormat.N_TRIPLE_FORMAT, "");
	public static final PreferenceKey TURTLE_FORMAT = new PreferenceKey(SadlSerializationFormat.TURTLE_FORMAT, "");
	public static final PreferenceKey JSON_LD = new PreferenceKey(SadlSerializationFormat.JSON_LD_FORMAT, "");
	public static final PreferenceKey RDF_JSON = new PreferenceKey(SadlSerializationFormat.RDF_JSON_FORMAT, "");
	public static final PreferenceKey TRIG = new PreferenceKey(SadlSerializationFormat.TRIG_FORMAT, "");
	public static final PreferenceKey N_QUAD = new PreferenceKey(SadlSerializationFormat.N_QUADS_FORMAT, "");
	public static final PreferenceKey TRIX = new PreferenceKey(SadlSerializationFormat.TRIX_FORMAT, "");
	public static final PreferenceKey RDF_BINARY = new PreferenceKey(SadlSerializationFormat.RDF_BINARY_FORMAT, "");
	public static final PreferenceKey JENA_TDB = new PreferenceKey(SadlSerializationFormat.JENA_TDB_FORMAT, "");
	
	public static final PreferenceKey MODEL_NAMESPACES = new PreferenceKey("ns", "");
	public static final PreferenceKey SADL_FILE_NAMES = new PreferenceKey("fn", "");
	public static final PreferenceKey PREFIXES_ONLY_AS_NEEDED = new PreferenceKey("prefixesOnlyAsNeeded", "");
	public static final PreferenceKey VALIDATE_BEFORE_TEST = new PreferenceKey("validateBeforeTest", "");
	public static final PreferenceKey TEST_WITH_KSERVER = new PreferenceKey("testWithKServer", "");	
	public static final PreferenceKey NAMESPACE_IN_QUERY_RESULTS = new PreferenceKey("namespacesInQueryResults", "");
	public static final PreferenceKey SHOW_TIMING_INFORMATION = new PreferenceKey("showTimingInformation", "");
	public static final PreferenceKey DMY_ORDER_DMY = new PreferenceKey("dmy", "");
	public static final PreferenceKey DMY_ORDER_MDY = new PreferenceKey("mdy", "");
	public static final PreferenceKey DEEP_VALIDATION_OFF = new PreferenceKey("deepValidationOff", "");
	public static final PreferenceKey GRAPH_RENDERER_CLASS= new PreferenceKey("graphrendererclass", "com.ge.research.sadl.model.visualizer.GraphVizVisualizer");
	public static final PreferenceKey TABULAR_DATA_IMPORTER_CLASS= new PreferenceKey("tabulardataimporterclass", "com.ge.research.sadl.jena.importer.CsvImporter");
	public static final PreferenceKey CHECK_FOR_AMBIGUOUS_NAMES = new PreferenceKey("ambiguousNameCheckOn", String.valueOf(true));
	public static final PreferenceKey CHECK_FOR_CARDINALITY_OF_PROPERTY_IN_DOMAIN = new PreferenceKey("cardinalityCheck", String.valueOf(false));
	public static final PreferenceKey P_USE_ARTICLES_IN_VALIDATION= new PreferenceKey("use_articles_in_validation", String.valueOf(false));
	public static final PreferenceKey FIND_AND_EXPAND_MISSING_PATTERNS= new PreferenceKey("find_and_expand_missing_patterns", String.valueOf(false));
	public static final PreferenceKey TYPE_CHECKING_WARNING_ONLY = new PreferenceKey("typeCheckingWarningOnly", String.valueOf(false));
	public static final PreferenceKey TYPE_CHECKING_RANGE_REQUIRED = new PreferenceKey("typeCheckingRangeRequired", String.valueOf(true));
	public static final PreferenceKey IGNORE_UNITTEDQUANTITIES = new PreferenceKey("ignoreUnittedQuantities", String.valueOf(false));
	public static final PreferenceKey CREATE_DOMAIN_AND_RANGE_AS_UNION_CLASSES = new PreferenceKey("domainAndRangeAsUnionClasses", String.valueOf(true));
	public static final PreferenceKey ENABLE_METRICS_COLLECTION = new PreferenceKey("metricsCollectionOn", String.valueOf(false));
	public static final PreferenceKey GENERATE_METRICS_REPORT_ON_CLEAN_BUILD = new PreferenceKey("generateMetricsReport", String.valueOf(false));
	public static final PreferenceKey METRICS_QUERY_FILENAME = new PreferenceKey("metricsQueryFilename", "");
	public static final PreferenceKey GRAPH_IMPLICIT_ELEMENTS = new PreferenceKey("graphImplicitElements", String.valueOf(false));
	public static final PreferenceKey GRAPH_IMPLICIT_ELEMENT_INSTANCES = new PreferenceKey("graphImplicitElementInstances", String.valueOf(false));
	public static final PreferenceKey CONTENT_ASSIST__FILTER_IMPLICIT_MODEL = new PreferenceKey("contentAssist__filterImplicitModel", String.valueOf(false));
	// Don't forget to add new property to the list below
	
	private static final PreferenceKey[] allKeys = {
			SADL_BASE_URI,
			OWL_MODEL_FORMAT,
			RDF_XML_FORMAT,
			RDF_XML_ABBREV_FORMAT,
			N_TRIPLE_FORMAT,
			TURTLE_FORMAT,
			JSON_LD,
			RDF_JSON,
			TRIG,
			N_QUAD,
			TRIX,
			RDF_BINARY,
			JENA_TDB,
			MODEL_NAMESPACES,
			SADL_FILE_NAMES,
			PREFIXES_ONLY_AS_NEEDED,
			VALIDATE_BEFORE_TEST,
			TEST_WITH_KSERVER,
			NAMESPACE_IN_QUERY_RESULTS,
			SHOW_TIMING_INFORMATION,
			DMY_ORDER_DMY,
			DMY_ORDER_MDY,
			DEEP_VALIDATION_OFF,
			GRAPH_RENDERER_CLASS,
			TABULAR_DATA_IMPORTER_CLASS,
			CHECK_FOR_AMBIGUOUS_NAMES,
			CHECK_FOR_CARDINALITY_OF_PROPERTY_IN_DOMAIN,
			P_USE_ARTICLES_IN_VALIDATION,
			FIND_AND_EXPAND_MISSING_PATTERNS,
//			DISABLE_TYPE_CHECKING,
			TYPE_CHECKING_WARNING_ONLY,
			TYPE_CHECKING_RANGE_REQUIRED,
			IGNORE_UNITTEDQUANTITIES,
			CREATE_DOMAIN_AND_RANGE_AS_UNION_CLASSES,
			ENABLE_METRICS_COLLECTION,
			GENERATE_METRICS_REPORT_ON_CLEAN_BUILD,
			METRICS_QUERY_FILENAME, 
			GRAPH_IMPLICIT_ELEMENTS,
			GRAPH_IMPLICIT_ELEMENT_INSTANCES,
			CONTENT_ASSIST__FILTER_IMPLICIT_MODEL
	};
	
	public static final List<PreferenceKey> preferences() {
		return Arrays.asList(allKeys);
	}
}
