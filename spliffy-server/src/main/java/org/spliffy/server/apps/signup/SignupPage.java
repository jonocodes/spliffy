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
package org.spliffy.server.apps.signup;

import com.bradmcevoy.http.*;
import com.bradmcevoy.http.Request.Method;
import com.bradmcevoy.http.exceptions.BadRequestException;
import com.bradmcevoy.http.exceptions.ConflictException;
import com.bradmcevoy.http.exceptions.NotAuthorizedException;
import com.bradmcevoy.http.exceptions.NotFoundException;
import com.ettrema.http.acl.Principal;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.spliffy.server.apps.contacts.ContactManager;
import org.spliffy.server.db.BaseEntity;
import org.spliffy.server.db.utils.SessionManager;
import org.spliffy.server.db.User;
import org.spliffy.server.web.AbstractResource;
import org.spliffy.server.web.JsonResult;
import org.spliffy.server.web.Services;
import org.spliffy.server.web.SpliffyCollectionResource;
import org.spliffy.server.web.SpliffyResourceFactory;
import org.spliffy.server.web.SpliffyResourceFactory.RootFolder;

/**
 *
 * @author brad
 */
public class SignupPage extends AbstractResource implements GetableResource, PostableResource {

    private static final Logger log = LoggerFactory.getLogger(SignupPage.class);
    
    private final String name;
    private final SpliffyResourceFactory.RootFolder parent;
    private JsonResult jsonResult;

    public SignupPage(String name, RootFolder parent, Services services) {
        super(services);
        this.parent = parent;
        this.name = name;
    }

    @Override
    public void sendContent(OutputStream out, Range range, Map<String, String> params, String contentType) throws IOException, NotAuthorizedException, BadRequestException, NotFoundException {
        if (jsonResult != null) {
            jsonResult.write(out);
        } else {
            services.getTemplater().writePage("signup.ftl", this, params, out, currentUser);
        }
    }

    @Override
    public String processForm(Map<String, String> parameters, Map<String, FileItem> files) throws BadRequestException, NotAuthorizedException, ConflictException {
        // ajax request to signup
        Session session = SessionManager.session();
        Transaction tx = session.beginTransaction();
        try {
            String name = parameters.get("name");
            if( name == null || name.trim().length() == 0 ) {
                throw new Exception("No name was provided");
            }
            User u = new User();
            u.setName(name);
            u.setEmail(parameters.get("email"));
            u.setCreatedDate(new Date());
            u.setModifiedDate(new Date());

            String password = parameters.get("password");
            if( password == null || password.trim().length() == 0 ) {
                throw new Exception("No password given");
            }
            services.getSecurityManager().getPasswordManager().setPassword(u, password);

            session.save(u);
            tx.commit();

            String userPath = "/" + u.getName(); // todo: encoding
            jsonResult = new JsonResult(true, "Created account", userPath);
        } catch (Exception e) {
            log.error("Exception creating user", e);
            jsonResult = new JsonResult(false, e.getMessage());
        }
        return null;
    }

    @Override
    public String getContentType(String accepts) {
        if (jsonResult != null) {
            return "application/x-javascript; charset=utf-8";
        }
        return "text/html";
    }

    @Override
    public boolean authorise(Request request, Method method, Auth auth) {
        return true;
    }

    @Override
    public boolean isDir() {
        return false;
    }

    @Override
    public SpliffyCollectionResource getParent() {
        return parent;
    }

    @Override
    public BaseEntity getOwner() {
        return null;
    }

    @Override
    public void addPrivs(List<Priviledge> list, User user) {
        list.add(Priviledge.READ);
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public Date getModifiedDate() {
        return null;
    }

    @Override
    public Date getCreateDate() {
        return null;
    }

    @Override
    public Map<Principal, List<Priviledge>> getAccessControlList() {
        return null;
    }

    @Override
    public Long getMaxAgeSeconds(Auth auth) {
        return null;
    }

    @Override
    public Long getContentLength() {
        return null;
    }
}
