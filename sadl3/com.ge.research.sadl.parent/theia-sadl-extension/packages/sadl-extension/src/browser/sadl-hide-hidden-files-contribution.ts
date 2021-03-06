/************************************************************************
 * Copyright 2007-2018 General Electric Company, All Rights Reserved
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

import { inject, injectable } from 'inversify';
import { FileNavigatorFilter } from '@theia/navigator/lib/browser/navigator-filter';
import { FrontendApplicationContribution } from '@theia/core/lib/browser/frontend-application';

@injectable()
export class SadlHideHiddenFilesContribution implements FrontendApplicationContribution {

    @inject(FileNavigatorFilter)
    protected readonly fileNavigatorFilter: FileNavigatorFilter;

    async onStart(): Promise<void> {
        this.fileNavigatorFilter.toggleHiddenFiles();
    }

}