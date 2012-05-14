/*
 * Copyright (C) 2012 McEvoy Software Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.spliffy.server.apps.login;

import com.bradmcevoy.http.CollectionResource;
import com.bradmcevoy.http.Resource;
import com.ettrema.event.EventManager;
import java.util.List;
import java.util.Properties;
import org.spliffy.server.apps.AppConfig;
import org.spliffy.server.apps.Application;
import org.spliffy.server.web.LoginPage;
import org.spliffy.server.web.RootFolder;
import org.spliffy.server.web.Services;
import org.spliffy.server.web.SpliffyResourceFactory;
import org.spliffy.server.web.RootFolder;

/**
 *
 * @author brad
 */
public class LoginApp implements Application{

    private Services services;
    
    @Override
    public Resource getNonBrowseablePage(Resource parent, String childName) {
        if( parent instanceof RootFolder) {            
            RootFolder rf = (RootFolder) parent;
            if( childName.equals("login")) {
                return new LoginPage(services.getSecurityManager(), rf);
            }            
        }
        return null;
    }

    @Override
    public void init(SpliffyResourceFactory resourceFactory) {
        this.services = resourceFactory.getServices();
    }

    @Override
    public void shutDown() {
        
    }

    @Override
    public void addBrowseablePages(CollectionResource parent, List<Resource> children) {
        
    }

    @Override
    public String getInstanceId() {
        return "login"; // only single instance
    }

    @Override
    public void initDefaultProperties(AppConfig config) {

    }


    
}
