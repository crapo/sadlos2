/*
 * generated by Xtext 2.9.0-SNAPSHOT
 */
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
package com.ge.research.sadl.scoping

import com.ge.research.sadl.model.DeclarationExtensions
import com.ge.research.sadl.reasoner.IReasoner
import com.ge.research.sadl.sADL.BinaryOperation
import com.ge.research.sadl.sADL.EquationStatement
import com.ge.research.sadl.sADL.Expression
import com.ge.research.sadl.sADL.ExternalEquationStatement
import com.ge.research.sadl.sADL.PropOfSubject
import com.ge.research.sadl.sADL.QueryStatement
import com.ge.research.sadl.sADL.RuleStatement
import com.ge.research.sadl.sADL.SadlCanOnlyBeOneOf
import com.ge.research.sadl.sADL.SadlClassOrPropertyDeclaration
import com.ge.research.sadl.sADL.SadlImport
import com.ge.research.sadl.sADL.SadlInstance
import com.ge.research.sadl.sADL.SadlModel
import com.ge.research.sadl.sADL.SadlMustBeOneOf
import com.ge.research.sadl.sADL.SadlNecessaryAndSufficient
import com.ge.research.sadl.sADL.SadlNestedInstance
import com.ge.research.sadl.sADL.SadlParameterDeclaration
import com.ge.research.sadl.sADL.SadlProperty
import com.ge.research.sadl.sADL.SadlResource
import com.ge.research.sadl.sADL.SelectExpression
import com.ge.research.sadl.sADL.SubjHasProp
import com.ge.research.sadl.sADL.TestStatement
import com.ge.research.sadl.sADL.UpdateExpression
import com.ge.research.sadl.sADL.UpdateStatement
import com.google.common.base.Predicate
import com.google.common.base.Predicates
import com.google.common.collect.ImmutableMap
import com.google.inject.Inject
import com.google.inject.Provider
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.common.util.TreeIterator
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.AbstractGlobalScopeDelegatingScopeProvider
import org.eclipse.xtext.scoping.impl.FilteringScope
import org.eclipse.xtext.scoping.impl.MapBasedScope
import org.eclipse.xtext.util.OnChangeEvictingCache

import static com.ge.research.sadl.processing.SadlConstants.*
import static com.ge.research.sadl.sADL.SADLPackage.Literals.*

import static extension com.ge.research.sadl.utils.SadlASTUtils.*
import com.ge.research.sadl.sADL.SadlDifferentFrom

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class SADLScopeProvider extends AbstractGlobalScopeDelegatingScopeProvider {
	
	/**
	 * Flag for enabling additional logging during debugging.
	 */
	static val DEBUG_FLAG = Debug.FALSE;

	/**
	 * Mapping of implicit/built-in resource file name and the corresponding model URIs.
	 */	
	static val IMPLICIT_MODELS = ImmutableMap.of(SADL_IMPLICIT_MODEL_FILENAME, SADL_IMPLICIT_MODEL_URI,
		SADL_BUILTIN_FUNCTIONS_FILENAME, IReasoner.SADL_BUILTIN_FUNCTIONS_URI);

	@Inject protected extension DeclarationExtensions
	@Inject protected IQualifiedNameConverter converter
	@Inject protected AmbiguousNameHelper ambiguousNameHelper;
	@Inject protected GlobalScopeProviderFilterProvider globalScopeProviderFilterProvider;

	@Inject OnChangeEvictingCache cache

	val LocalScopeProvider localScope_01 = namedScopeProvider([resource, namespace, parentScope, importScope |
		return internalGetLocalResourceScope(resource, namespace, parentScope, importScope, true) [
			if (it instanceof SadlResource) {
				return (eContainer instanceof SadlClassOrPropertyDeclaration && eContainingFeature == SADL_CLASS_OR_PROPERTY_DECLARATION__CLASS_OR_PROPERTY && !(eContainer.eContainer instanceof SadlDifferentFrom))
					|| eContainer instanceof SadlProperty && (eContainer as SadlProperty).isPrimaryDeclaration() && eContainingFeature == SADL_PROPERTY__NAME_OR_REF;
					
			} 
			return false;
		];
	], '01');

	val LocalScopeProvider localScope_02 = namedScopeProvider([resource, namespace, parentScope, importScope |
		return internalGetLocalResourceScope(resource, namespace, parentScope, importScope) [
			if (it instanceof SadlResource) {
				return eContainer instanceof SadlProperty && eContainingFeature == SADL_PROPERTY__NAME_OR_REF
					|| eContainer instanceof SadlProperty && eContainingFeature == SADL_PROPERTY__NAME_DECLARATIONS;
			} 
			return false;
		];
	], '02');

	// only if (https://github.com/crapo/sadlos2/issues/215)
	val LocalScopeProvider localScope_03 = namedScopeProvider([resource, namespace, parentScope, importScope |
		return internalGetLocalResourceScope(resource, namespace, parentScope, importScope) [
			if (it instanceof SadlResource) {
				return eContainer instanceof SadlNecessaryAndSufficient && eContainingFeature == SADL_NECESSARY_AND_SUFFICIENT__OBJECT;
			} 
			return false;
		];
	], '03');

	// SADL nested instance support: https://github.com/crapo/sadlos2/issues/250
	val LocalScopeProvider localScope_04 = namedScopeProvider([resource, namespace, parentScope, importScope |
		return internalGetLocalResourceScope(resource, namespace, parentScope, importScope) [
			if (it instanceof SadlResource) {
				return eContainer instanceof SadlNestedInstance && eContainingFeature == SADL_INSTANCE__INSTANCE;
			} 
			return false;
		];
	], '04');

	val LocalScopeProvider localScope_05 = namedScopeProvider([resource, namespace, parentScope, importScope |
		return internalGetLocalResourceScope(resource, namespace, parentScope, importScope) [
			if (it instanceof SadlResource) {
				return eContainer instanceof SadlInstance && 
					eContainingFeature == SADL_INSTANCE__NAME_OR_REF &&
					(eContainer as SadlInstance).type !== null;
			} 
			return false;
		];
	], '05');

	val LocalScopeProvider localScope_06 = namedScopeProvider([resource, namespace, parentScope, importScope |
		return internalGetLocalResourceScope(resource, namespace, parentScope, importScope) [
			if (it instanceof SadlResource) {
				return (eContainer instanceof SadlMustBeOneOf && eContainingFeature == SADL_MUST_BE_ONE_OF__VALUES) ||
				(eContainer instanceof SadlCanOnlyBeOneOf && eContainingFeature == SADL_CAN_ONLY_BE_ONE_OF__VALUES);
			} 
			return false;
		];
	], '06');

	override getScope(EObject context, EReference reference) {
		// resolving imports against external models goes directly to the global scope
		if (reference.EReferenceType === SADL_MODEL) {
			// Here we need to filter out all the items that do not belong to the same SADL project.
			// It has no effect for the headless tool-chain and the Eclipse IDE case.
			val predicate = globalScopeProviderFilterProvider.getPredicate(context.eResource);
			val globalScope = super.getGlobalScope(context.eResource, reference)
			return new FilteringScope(globalScope, predicate);
		}
		if (SADL_RESOURCE.isSuperTypeOf(reference.EReferenceType)) {
			val result = getSadlResourceScope(context, reference)
			return result
		}
		throw new UnsupportedOperationException(
			"Couldn't build scope for elements of type " + reference.EReferenceType.name)
	}

	protected def IScope getSadlResourceScope(EObject context, EReference reference) {
		val parent = createResourceScope(context.eResource, null, newHashSet)
		val rule = EcoreUtil2.getContainerOfType(context, RuleStatement)
		if (rule !== null) {
			return getLocalVariableScope(rule.ifs + rule.thens, parent)
		}
		val equation = EcoreUtil2.getContainerOfType(context, EquationStatement)
		if (equation !== null) {
			// Filter items with `null` `concreteName`.
			// E.g.: `Equation add(decimal x, /* no "type" here */ y) returns decimal: x + y.`
			val params = equation.parameter
					.filter[unknown.nullOrEmpty && ellipsis.nullOrEmpty]
					.map[name.concreteName -> it]
					.filter[!key.nullOrEmpty]
					.map[EObjectDescription.create(key, value.name)].toList;
			val newParent = MapBasedScope.createScope(parent, params)
			return getLocalVariableScope(#[equation.where, equation.body, equation.retval].filterNull, newParent);
		}
		val externalEquation = EcoreUtil2.getContainerOfType(context, ExternalEquationStatement)
		// https://github.com/crapo/sadlos2/issues/376
		if (externalEquation !== null) {
			val params = externalEquation.parameter
					.filter[unknown.nullOrEmpty && ellipsis.nullOrEmpty] // XXX: otherwise we run into a NPE for the concrete names for `--` and `...`.
					.map[name.concreteName -> it]
					.filter[!key.nullOrEmpty]
					.map[EObjectDescription.create(key, value.name)].toList;
			val newParent = MapBasedScope.createScope(parent, params)
			return getLocalVariableScope(#[externalEquation.where].filterNull, newParent);
		}
		val ask = EcoreUtil2.getContainerOfType(context, QueryStatement)
		if (ask?.expr !== null) {
			return getLocalVariableScope(#[ask.expr], parent)
		}
		val test = EcoreUtil2.getContainerOfType(context, TestStatement)
		if (test?.tests !== null) {
			return getLocalVariableScope(test.tests, parent)
		}
		val update = EcoreUtil2.getContainerOfType(context, UpdateStatement)
		if (update?.expr !== null && update?.expr instanceof UpdateExpression) {
			val uexpr = update.expr as UpdateExpression
			return getLocalVariableScope(#[uexpr.deleteExpression] + #[uexpr.insertExpression] + #[uexpr.whereExpression], parent)
		}
		return parent
	}

	protected def IScope getLocalVariableScope(Iterable<Expression> expressions, IScope parent) {
		if (expressions.nullOrEmpty) {
			return parent;
		}
		var newParent = doGetLocalVariableScope(expressions, parent) [
			// https://github.com/crapo/sadlos2/issues/344
			if (it instanceof SadlResource && EcoreUtil2.getContainerOfType(it, EquationStatement) !== null) {
				return  EcoreUtil2.getContainerOfType(it, SubjHasProp) === null;
			}
			if (it instanceof SadlResource && EcoreUtil2.getContainerOfType(it, ExternalEquationStatement) !== null) {
				return  EcoreUtil2.getContainerOfType(it, SubjHasProp) === null;
			}
			var container = eContainer;
			if (container instanceof SelectExpression) {
				if (container.whereExpression instanceof SubjHasProp) {
					val subjHasProp = container.whereExpression as SubjHasProp;
					return subjHasProp.left === it || subjHasProp.right === it;
				}
			}
			if (container instanceof PropOfSubject || container instanceof SubjHasProp) {
				container = container.eContainer;
			}
			if (container instanceof BinaryOperation) {
				if (container.op == 'is' || container.op == '==' || container.op == '=' ||
					(container.op == 'and' && EcoreUtil2.getContainerOfType(it, SelectExpression) !== null) || // we are in the middle of a select expression.
					(container.op == 'and' && EcoreUtil2.getContainerOfType(it, RuleStatement) !== null) // we are in the middle of a rule statement (GH-245).
				) {
					return true;
				}
			} else if (container instanceof UpdateExpression) {
				if (container.whereExpression instanceof SubjHasProp) {
					val subjHasProp = container.whereExpression as SubjHasProp
					return subjHasProp.left === it || subjHasProp.right === it;
				}
			} else if (container instanceof SelectExpression) {
				if (container.whereExpression instanceof SubjHasProp) {
					val subjHasProp = container.whereExpression as SubjHasProp;
					return subjHasProp.left === it || subjHasProp.right === it;
				}
			};
			return false
		]
		return doGetLocalVariableScope(expressions, newParent, [true]);
	}

	protected def IScope doGetLocalVariableScope(Iterable<Expression> expressions, IScope parent, Predicate<SadlResource> predicate) {
		if (expressions.nullOrEmpty) {
			return parent;
		}
		val map = newHashMap
		for (expression : expressions) {
			val iter = EcoreUtil2.getAllContents(expression, false).filter(SadlResource).filter(predicate)
			while (iter.hasNext) {
				val name = iter.next
				val concreteName = name.concreteName
				if (concreteName !== null) {
					val qn = QualifiedName.create(concreteName)
					if (!map.containsKey(qn) && parent.getSingleElement(qn) === null) {
						map.put(qn, new EObjectDescription(qn, name, emptyMap))
					}
				}
			}
		}
		return MapBasedScope.createScope(parent, map.values)
	}

	protected def IScope createResourceScope(Resource resource, String alias, Set<Resource> importedResources) {
		return createResourceScope(resource, alias, importedResources, Predicates.alwaysTrue); 
	}

	protected def IScope createResourceScope(Resource resource, String alias, Set<Resource> importedResources, Predicate<EObject> isIncluded) {
		val provider = [
			val shouldWrap = importedResources.empty
			if (!importedResources.add(resource)) {
				return IScope.NULLSCOPE
			}
			
			var newParent = createImportScope(resource, importedResources)
			if (shouldWrap) {
				newParent = wrap(newParent)
			}
			val importScope = newParent;
			val aliasToUse = alias ?: resource.getAlias
			val namespace = if(aliasToUse !== null) QualifiedName.create(aliasToUse) else null
			
			// Get an ordered collection of local scope providers which are used to determine
			// the precedence of the SADL resources. In other words, which one should be the declarations
			// which one should be the reference.
			for (scopeProvider : localScopeProviders) {
				if (DEBUG) {
					println('''Processing scope provider: «scopeProvider.name».''');
				}
				newParent = scopeProvider.getLocalScope(resource, namespace, newParent, importScope);
			}
			
			// finally all the rest
			newParent = internalGetLocalResourceScope(resource, namespace, newParent, importScope, isIncluded)
			return newParent
		] as Provider<IScope>;
		val key = 'resource_scope' -> alias;
		return cache.get(key, resource, provider);
	}

	protected def List<LocalScopeProvider> getLocalScopeProviders() {
		return newArrayList(
			localScope_01,
			localScope_02,
			localScope_03,
			localScope_04,
			localScope_05,
			localScope_06
		);
	}

	protected def IScope internalGetLocalResourceScope(Resource resource, QualifiedName namespace, IScope parentScope,
		IScope importScope, Predicate<EObject> isIncluded) {

		internalGetLocalResourceScope(resource, namespace, parentScope, importScope, false, isIncluded);
	}

	@Data
	protected static class ScopeContext {
		val EObject obj;
		val QualifiedName namespace;
		val IScope parentScope;
		val IScope importScope;
		val boolean checkAmbiguity;
		val Map<QualifiedName, IEObjectDescription> map;
		val Predicate<EObject> isIncluded;
		val TreeIterator<EObject> iter;
		def ScopeContext wrap(EObject otherObj) {
			return new ScopeContext(otherObj, namespace, parentScope, importScope, checkAmbiguity, map, isIncluded, iter);
		}
	}

	protected def IScope internalGetLocalResourceScope(Resource resource, QualifiedName namespace, IScope parentScope,
		IScope importScope, boolean checkAmbiguity, Predicate<EObject> isIncluded) {

		val map = <QualifiedName, IEObjectDescription>newHashMap
		val iter = resource.allContents
		while (iter.hasNext) {
			val it = iter.next
			if (isIncluded.apply(it)) {
				val context = new ScopeContext(it, namespace, parentScope, importScope, checkAmbiguity, map, isIncluded, iter);
				val objSwitch = doSwitch(context);
				if (objSwitch !== null) {
					objSwitch.apply(context);
				} else {
					switch it {
						SadlResource case concreteName !== null: {
							handleSadlResource(context);
						}
						// if (!it.name.concreteName.nullOrEmpty) as a workaround for the broken AST
						// E.g.: `Equation Equation Equation Equation <|>newtons2ndLaw`
						EquationStatement: {
							if (!it.name.concreteName.nullOrEmpty) {
								val name = converter.toQualifiedName(it.name.concreteName)
								map.addElement(name, it.name)
								if (name.segmentCount > 1) {
									map.addElement(name.skipFirst(1), it.name)
								} else if (namespace !== null) {
									map.addElement(namespace.append(name), it.name)
								}
							}
							iter.prune
						}
						ExternalEquationStatement: {
							if (!it.name.concreteName.nullOrEmpty) {
								val name = converter.toQualifiedName(it.name.concreteName)
								map.addElement(name, it.name)
								if (name.segmentCount > 1) {
									map.addElement(name.skipFirst(1), it.name)
								} else if (namespace !== null) {
									map.addElement(namespace.append(name), it.name)
								}
							}
							iter.prune
						}
						QueryStatement: {
							// Ignore `anonymous` query statements. Nothing to put into the scope.
							if (name?.concreteName !== null) {
								val name = converter.toQualifiedName(it.name.concreteName)
								map.addElement(name, it.name)
								if (name.segmentCount > 1) {
									map.addElement(name.skipFirst(1), it.name)
								} else if (namespace !== null) {
									map.addElement(namespace.append(name), it.name)
								}
								// Make sure we do not expose the parameters from the query expression to the scope.
								// Stop processing the subtree of the current AST element by pruning the iterator.
								// For instance, we do not let `c` into the scope. 
								// `C is a class. Ask myQuery: select c where c is a C.` 
							}
							iter.prune // variables from a query expression w/o a name should not leave the variable scope. 
						}
						RuleStatement: {
							if (name?.concreteName !== null) {
								val name = converter.toQualifiedName(it.name.concreteName)
								map.addElement(name, it.name)
								if (name.segmentCount > 1) {
									map.addElement(name.skipFirst(1), it.name)
								}
								else if (namespace !== null) {
									map.addElement(namespace.append(name), it.name)
								}
							}
							iter.prune
						}
						default: {
							if (pruneScope(it)) {
								iter.prune
							}
						}
					}
				}
			}
		}
		return MapBasedScope.createScope(parentScope, map.values)
	}

	protected def handleSadlResource(ScopeContext context) {
		val it = context.obj as SadlResource;
		val parentScope = context.parentScope;
		val importScope = context.importScope;
		val checkAmbiguity = context.checkAmbiguity;
		val namespace = context.namespace;
		val map = context.map;

		val ambiguousNameDetection = ambiguousNameHelper.isAmbiguousNameCheckEnabled(eResource)
		val name1 = getName(it);
		val resourceInParentScope = parentScope.getSingleElement(name1);
		var ambiguousProblem = null as IEObjectDescription;
		if (resourceInParentScope === null) {
			map.addElement(name1, it)
		} else {
			if (checkAmbiguity) {
				val resourceInImportScope = importScope.getSingleElement(name1);
				if (resourceInImportScope !== null) {
					val nameWithPrefixes = getName(it, false);
					if (name1.segmentCount > 1) {
						if (name1 == nameWithPrefixes && (namespace === null || name1.startsWith(namespace))) {
							ambiguousProblem = checkDuplicate(resourceInParentScope,
								EObjectDescription.create(name1, it), ambiguousNameDetection);
							if (ambiguousProblem !== null) {
								map.put(name1, ambiguousProblem);
							}
						}
					} else {
						if (name1 == nameWithPrefixes) {
							ambiguousProblem = checkDuplicate(resourceInParentScope,
								EObjectDescription.create(name1, it), ambiguousNameDetection);
							if (ambiguousProblem !== null) {
								map.put(name1, ambiguousProblem);
							}
						}
					}
				}
			}
		}
		val name2 = if(name1.segments.size == 1) namespace?.append(name1) else name1.skipFirst(1)
		if (name2 !== null && parentScope.getSingleElement(name2) === null && ambiguousProblem === null) {
			map.addElement(name2, it)
		}
		// https://github.com/crapo/sadlos2/issues/423
		// We have to add the SADL resource to the scope with colons as the syntax is the following:
		// import URL as importedAlis.
		// importedAlias:something.from.imported.model
		val name3 = if (namespace !== null) QualifiedName.create(namespace.toString + ':' + name1.toString) else null
		if (name3 !== null &&  parentScope.getSingleElement(name3) === null && ambiguousProblem === null) {
			map.addElement(name3, it)
		}
	}

	protected def QualifiedName getName(SadlResource it) {
		return getName(it, false);
	}

	protected def QualifiedName getName(SadlResource it, boolean trimPrefix) {
		return converter.toQualifiedName(getConcreteName(it, trimPrefix));
	}

	/**
	 * Clients may override to handle anything before visiting the contents of the resource for the internal resource scope.
	 */
	protected def (ScopeContext)=>void doSwitch(ScopeContext context) {
		return null;
	}

	protected def pruneScope(EObject object) {
		return object instanceof RuleStatement || object instanceof EquationStatement || object instanceof QueryStatement || object instanceof TestStatement || object instanceof ExternalEquationStatement
	}

	protected def String getAlias(Resource resource) {
		(resource.contents.head as SadlModel).alias
	}

	protected def IScope createImportScope(Resource resource, Set<Resource> importedResources) {
		val ambiguousNameDetection = ambiguousNameHelper.isAmbiguousNameCheckEnabled(resource)
		val imports = resource.contents.head.eContents.filter(SadlImport).toList.reverseView
		val importedSymbols = <QualifiedName, IEObjectDescription>newHashMap
		for (imp : imports) {
			val importedResource = imp.importedResource
			if (importedResource !== null && !importedResource.eIsProxy) {
				createResourceScope(importedResource.eResource, imp.alias, importedResources).allElements.forEach[
					val existing = importedSymbols.put(name, it)
					val duplicateProblem = checkDuplicate(existing, it, ambiguousNameDetection)
					if (duplicateProblem !== null) {
						importedSymbols.put(duplicateProblem.name, duplicateProblem)
					}
				];
			}
		}
		if (importedSymbols.isEmpty) {
			IMPLICIT_MODELS.forEach [ fileName, desiredUri |
				if (!resource.URI.toString.endsWith(fileName)) {
					val qName = QualifiedName.create(desiredUri);
					val predicate = globalScopeProviderFilterProvider.getPredicate(resource);
					val filteredGlobalScope = new FilteringScope(getGlobalScope(resource, SADL_IMPORT__IMPORTED_RESOURCE), predicate);
					val element = filteredGlobalScope.getSingleElement(qName)
					if (element !== null) {
						val eobject = resource.resourceSet.getEObject(element.EObjectURI, true)
						if (eobject !== null) {
							createResourceScope(eobject.eResource, null, importedResources).allElements.forEach [
								importedSymbols.put(name, it)
							]
						}
					}
				}
			];
		}
		
		return new MapScope(IScope.NULLSCOPE, importedSymbols, false)
	}

	def private IEObjectDescription checkDuplicate(IEObjectDescription existing, IEObjectDescription other, boolean ambiguousNameDetection) {
		if (!ambiguousNameDetection || existing === null || other === null ||
			EcoreUtil.getURI(existing.EObjectOrProxy) == EcoreUtil.getURI(other.EObjectOrProxy)) {
			return null
		}
		if (existing instanceof AmbiguousNameErrorEObjectDescription) {
			return existing.addConflicting(other);
		} else {
			return new AmbiguousNameErrorEObjectDescription(existing, other);
		}
	}

	static class MapScope extends MapBasedScope {
	
		new(IScope parent, Map<QualifiedName, IEObjectDescription> elements, boolean ignoreCase) {
			super(parent, elements, ignoreCase)
		}
		
	}

	protected def void addElement(Map<QualifiedName, IEObjectDescription> scope, QualifiedName qn, EObject obj) {
		if (canAddToScope(scope, qn, obj)) {
			scope.put(qn, new EObjectDescription(qn, obj, emptyMap));
		}
	}

	protected def boolean canAddToScope(Map<QualifiedName, IEObjectDescription> scope, QualifiedName qn, EObject obj) {
		var canAdd = true;
		if (obj instanceof SadlResource) {
			if (!obj.inEquationWhere && !obj.inExternalEquationWhere) {
				canAdd = !obj.inExternalOrLocalEquationStatement
					&& !obj.inExpression
					&& !obj.inQueryStatement
					&& !obj.inRuleStatement
					&& !obj.unit;
			}
		}
		return canAdd && !scope.containsKey(qn);
	}

	// Do not put parameters of external and local equation statements into the scope.
	protected def boolean isInExternalOrLocalEquationStatement(SadlResource it) {
		if (eContainer instanceof SadlParameterDeclaration) {
			val declaration = eContainer as SadlParameterDeclaration;
				val container = declaration.eContainer;
				return container instanceof ExternalEquationStatement || container instanceof EquationStatement;
		}
		return false;
	}

	// Also filter out resources from the expression of any equations.
	protected def boolean isInExpression(SadlResource it) {
		return EcoreUtil2.getContainerOfType(it, BinaryOperation) !== null;
	}

	// The SADL resource from the use-site should not go into the scope.
	// In such cases the statement does not have an expression.
	protected def boolean isInQueryStatement(SadlResource it) {
		if (eContainer instanceof QueryStatement) {
			return (eContainer as QueryStatement).expr === null;
		}
		return false;
	}

	protected def boolean isInRuleStatement(SadlResource it) {
		if (eContainer instanceof RuleStatement) {
			return (eContainer as RuleStatement).thens === null;
		}
		return false;
	}

	/**
	 * {@code true} if the argument is contained in an {@link EquationStatement}'s {@link EquationStatement#getWhere() where} expression.
	 * The containment is not necessarily direct. Otherwise, {@code false}.
	 */
	protected def boolean isInEquationWhere(SadlResource it) {
		val equationStatement = EcoreUtil2.getContainerOfType(it, EquationStatement);
		if (equationStatement !== null && equationStatement.where !== null) {
			return EcoreUtil2.isAncestor(equationStatement.where, it);
		}
		return false;
	}

	protected def boolean isInExternalEquationWhere(SadlResource it) {
		val externalEquationStatement = EcoreUtil2.getContainerOfType(it, ExternalEquationStatement);
		if (externalEquationStatement !== null && externalEquationStatement.where !== null) {
			return EcoreUtil2.isAncestor(externalEquationStatement.where, it);
		}
		return false;
	}

	/**
	 * Sugar for having a name for the local scope provider. This is only for debugging purposes. 
	 */
	protected static def LocalScopeProvider namedScopeProvider(LocalScopeProvider delegate, String theName) {
		return new LocalScopeProvider() {
			
			override getLocalScope(Resource resource, QualifiedName namespace, IScope parentScope, IScope importScope) {
				return delegate.getLocalScope(resource, namespace, parentScope, importScope);
			}
			
			override getName() {
				return theName;
			}
			
		}
	}

	/**
	 * Local helper that is used to modify the declaration/reference precedences of the SADL resources inside a SADL model.
	 */
	protected static interface LocalScopeProvider {
		
		/**
		 * Consumes the {@code parentScope} and returns with a new scope that has to be consumed by another local scope provider
		 * and so on and so on.
		 */
		def IScope getLocalScope(Resource resource, QualifiedName namespace, IScope parentScope, IScope importScope);
		
		/**
		 * Prints the name of the local scope provider.
		 * This is just some sugar for debugging.
		 */
		def String getName() {
			return toString;
		}
		
	}

	//----------------------------------------
	// Helper things.
	//----------------------------------------

	/**
	 * Hack to have a static flag bug no warnings due to dead code.
	 */
	static enum Debug {
		TRUE,
		FALSE
	}

	static def boolean isDEBUG() {
		return DEBUG_FLAG === Debug.TRUE;
	}

}