package com.ge.research.sadl.ui.handlers;

import java.util.List;

import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.IPath;
import org.eclipse.jface.dialogs.InputDialog;
import org.eclipse.jface.window.Window;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.xtext.resource.XtextResource;

import com.ge.research.sadl.builder.ConfigurationManagerForIdeFactory;
import com.ge.research.sadl.builder.IConfigurationManagerForIDE;
import com.ge.research.sadl.external.ExternalEmfResource;
import com.ge.research.sadl.ide.handlers.SadlRunQueryHandler;
import com.ge.research.sadl.model.SadlSerializationFormat;
import com.ge.research.sadl.reasoner.ConfigurationException;
import com.ge.research.sadl.reasoner.ConfigurationItem;
import com.ge.research.sadl.reasoner.ConfigurationItem.ConfigurationType;
import com.ge.research.sadl.reasoner.ConfigurationItem.NameValuePair;
import com.ge.research.sadl.reasoner.TranslationException;
import com.ge.research.sadl.utils.ResourceManager;
import com.google.common.base.Supplier;
import com.google.inject.Inject;
import com.google.inject.Provider;

public class RunQuery extends SadlActionHandler {

	@Inject
	protected Provider<SadlRunQueryHandler> handlerProvider;
	
	private static final String pSHOWNAMESPACES = "pShowNamespaces";
	private static final String[] CONSOLE = {"Console"};
	public String projectLocation;
	protected Process Process;

	/**
     * Class to capture the user's input in the dialog
     * @author crapo
     *
     */
    class UserQueryInput {
    	private String query;
    	private boolean fqn;
    	private boolean canceled;

		public void setQuery(String query) {
			this.query = query;
		}

		public String getQuery() {
			return query;
		}

		public void setFqn(boolean fqn) {
			this.fqn = fqn;
		}

		public boolean isFqn() {
			return fqn;
		}

		public void setCanceled(boolean canceled) {
			this.canceled = canceled;
		}

		public boolean isCanceled() {
			return canceled;
		}
    	
    }

	public RunQuery() {
		super();
	}

	public Object execute(ExecutionEvent event) throws ExecutionException {
		try {
			String[] validTargetTypes = getValidTargetFileTypes();
			boolean tryAddingOwlExtension = true;
			Object[] target = null;
			try {
				target = getCommandTarget(validTargetTypes);
			}
			catch (TranslationException e) {
				// invalid file type--but maybe this is a derivative grammar OWL file
				// assume naming is to append ".owl" to the file name for any derivative grammar file
				tryAddingOwlExtension = true;
			}
			IProject project = null;
			IPath trgtFolder = null;
			IFile trgtFile = null;
			if (target != null) {
				if (target.length > 0) project = (IProject) target[0];
				if (target.length > 1) trgtFolder = (IPath) target[1];
				if (target.length > 2) trgtFile = (IFile) target[2];
			}
			String owlFileName = null;

			if (trgtFile != null) {
				String modelFolderUri = convertProjectRelativePathToAbsolutePath(project.getFullPath().append(ResourceManager.OWLDIR).toPortableString());
				final String format = SadlSerializationFormat.RDF_XML_ABBREV_FORMAT;
				IConfigurationManagerForIDE configMgr = ConfigurationManagerForIdeFactory.getConfigurationManagerForIDE(modelFolderUri, format);
				final XtextResource resource = getXtextResource(project, trgtFile);
				if (resource == null) {
					final ExternalEmfResource extRsrc = getExternalEmfResource(project, trgtFile);
					if (extRsrc == null) {
						console.error("Query target '" + trgtFile.getName() + "' is not an XtextResource and is not an ExternalEmfResource.\n");
					}
					else {
						Supplier<ExternalEmfResource> resourceSupplier = () -> extRsrc;
						final IProject currentProject = project;
						final IFile targetFile = trgtFile;
						SadlRunQueryHandler delegate = handlerProvider.get();
						delegate.setGraphVisualizerHandler(new SadlEclipseGraphVisualizerHandler(RunQuery.this, currentProject, targetFile));
						delegate.runEER(trgtFile.getLocation().toFile().toPath(), resourceSupplier, getQuery(configMgr));
					}
				}
				else {
					Supplier<XtextResource> resourceSupplier = () -> resource;
					final IProject currentProject = project;
					final IFile targetFile = trgtFile;
					SadlRunQueryHandler delegate = handlerProvider.get();
					delegate.setGraphVisualizerHandler(new SadlEclipseGraphVisualizerHandler(RunQuery.this, currentProject, targetFile));
					delegate.run(trgtFile.getLocation().toFile().toPath(), resourceSupplier, getQuery(configMgr));
				}
			}
			else {
				throw new TranslationException("Please select a target for querying");
			}
		}
		catch (Exception e) {
			console.error(e.getMessage() + "\n");
		}
		finally {

		}

		return event;
	}

	public static final String pQUERY = "pQuery";
	public static final String[] ADHOCQUERY = {"AdHocQuery"};

	public String getQuery(IConfigurationManagerForIDE configMgr) throws ConfigurationException {
		String query = null;
		List<Object> previousQueries = null;
		List<ConfigurationItem> config = configMgr.getConfiguration(ADHOCQUERY, false);
		if (config != null && config.size() > 0) {
			previousQueries = config.get(0).getAllValuesOfName(pQUERY);
		}
		if (previousQueries != null && previousQueries.size() >= 1) {
			final Shell shell = new Shell();
			shell.setText("Run Query");
			Display display = shell.getDisplay();
			shell.setLayout(new GridLayout(2, false));
			(new Label(shell, SWT.NULL)).setText("Enter a SADL or SPARQL query:");
			final UserQueryInput returnVal = new UserQueryInput();
			final Combo combo = new Combo(shell, SWT.DROP_DOWN | SWT.MULTI | SWT.V_SCROLL | SWT.H_SCROLL);
			combo.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
			final Button fqnb = new Button (shell, SWT.CHECK);
			fqnb.setText("Show namespaces?");
			List<ConfigurationItem> cil;
			boolean showNamespaces = true;
			try {
				cil = configMgr.getConfiguration(CONSOLE, false);
				if (cil != null && cil.size() > 0) {
					ConfigurationItem ci = cil.get(0);
					Object objVal = ci.getNamedValue(pSHOWNAMESPACES);
					if (objVal != null && objVal instanceof Boolean) {
						showNamespaces = ((Boolean)objVal).booleanValue();
					}
				}
			} catch (ConfigurationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			fqnb.setSelection(showNamespaces);
			fqnb.addMouseListener(new MouseListener() {		
				@Override
				public void mouseUp(MouseEvent e) {
					
				}
				
				@Override
				public void mouseDown(MouseEvent e) {
				}
				
				@Override
				public void mouseDoubleClick(MouseEvent e) {
				}
			});
			
			Button cancelb = new Button (shell, SWT.PUSH);
			cancelb.setText("Cancel");
			cancelb.addMouseListener(new MouseListener() {		
				@Override
				public void mouseUp(MouseEvent e) {
				}
				
				@Override
				public void mouseDown(MouseEvent e) {
					combo.clearSelection();
//					System.out.println("On Cancel text is: " + combo.getText());
					returnVal.setQuery(null);
					returnVal.setCanceled(true);
					shell.dispose();
				}
				
				@Override
				public void mouseDoubleClick(MouseEvent e) {
				}
			});

			Button okb = new Button (shell, SWT.PUSH);
			okb.setText("OK");
			okb.addMouseListener(new MouseListener() {		
				@Override
				public void mouseUp(MouseEvent e) {
				}
				
				@Override
				public void mouseDown(MouseEvent e) {
//					System.out.println("On OK combo text is: " + combo.getText());
					returnVal.setFqn(fqnb.getSelection());
					returnVal.setQuery(combo.getText());
					shell.dispose();
				}
				
				@Override
				public void mouseDoubleClick(MouseEvent e) {
				}
			});

			combo.addSelectionListener(new org.eclipse.swt.events.SelectionListener() {

				@Override
				public void widgetSelected(SelectionEvent e) {
					// TODO Auto-generated method stub
//					System.out.println("Selected: " + combo.getSelectionIndex() + ", " + combo.getItem(combo.getSelectionIndex()));
//					System.out.println("  check: " + combo.getText());
					returnVal.setQuery(combo.getItem(combo.getSelectionIndex()));
					returnVal.setQuery(combo.getText());
					}
					
				@Override
				public void widgetDefaultSelected(SelectionEvent e) {
					String text = combo.getText();
					if (combo.indexOf(text) == -1) {
						combo.add(text, 0);
					}
//					System.out.println("Default selected: " + text);
					returnVal.setQuery(combo.getText());
					returnVal.setQuery(text);
					shell.dispose();
				}  });
			
			// we want these with most recent (last in Sequence) first
			for (int i = (previousQueries.size() - 1); i >= 0; i--) {
				if (i == (previousQueries.size() - 1)) {
					combo.setText(previousQueries.get(i).toString());
				}
				combo.add(previousQueries.get(i).toString());
			}

			shell.pack();
			shell.open();
			shell.setVisible(true);
			shell.setFocus();
			while (!shell.isDisposed()) {
				if (display != null && !display.readAndDispatch()) {
					display.sleep();
				}
			}
			query = returnVal.getQuery();
			boolean showNS = true;
			if (returnVal.isFqn() != showNamespaces) {
				// this changed
				showNS = returnVal.isFqn();
			}
			else {
//	        	IPreferencesService service = Platform.getPreferencesService();
	        	showNS = false; //service.getBoolean("com.ge.research.sadl.Sadl", "vnamespacesInQueryResults", true, null);
			}
		}
		else {
			Shell shell = new Shell();
			InputDialog dlg = new InputDialog(
				shell,
				"Run Query",
				"SADL or SPARQL Query?",
				query,
				null);
			dlg.open();
			if (dlg.getReturnCode() != Window.OK) {
				return null;
			}
			query = dlg.getValue();
			if (query != null && query.length() > 0) {
				if (query.toLowerCase().contains("select") && query.contains("?") && query.contains("{")) {
					if (!query.trim().startsWith("\"") && !query.trim().endsWith("\"")) {
						query = query.replace("\"", "\\\"");
						query = "\"" + query + "\"";
					}	
				}
				String augmentedQuery = query;
				if (!query.startsWith("Ask:")) {
					augmentedQuery = "Ask: " + query;
				}
				if (!query.endsWith(".")) {
					augmentedQuery += " .\n";
				}
				
				final String finalQuery = query;
				final List<Object> finalPreviousQueries = previousQueries;
				console.info("Query is: " + query + "\n");
			}
		}
		if (query != null) {
			ConfigurationItem ci = new ConfigurationItem(ADHOCQUERY);
			NameValuePair nvp = ci.new NameValuePair(pQUERY, query);
			nvp.setConfigType(ConfigurationType.Sequence);
			ci.addNameValuePair(nvp);
			configMgr.addConfiguration(ci);
		}
		return query;
	}

	@Override
	protected String[] getValidTargetFileTypes() {
		String[] types = {"sadl","owl"};
		return types;
	}

}