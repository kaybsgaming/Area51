component extends="com.practicalpixels.controller"    {
public function init(){
	// set up entity and action for ELS (Entity Level Security))
	request.entity="quickLink";
	// "do" should correspond to your public methods in this component (a controller handles multiple "do" commands)
	switch(request.do){
		case "default":{request.entityAction="read"; break;}
		case "form":{request.entityAction="read"; break;}
		case "set":{request.entityAction="write"; break;}
		case "delete":{request.entityAction="delete"; break;}
		case "getPrivateLinks":{request.entityAction="read"; break;}
	}
	// Call ELS to ensure we are allowed to execute this controller method
	application.security.entityAuthorise(request.entity, request.entityAction);
	
	// which module is selected in the Nav
	request.module="QuickLinks";
	request.pagename="Quick links";
	request.icon="icon-link";
	
	// breadcrumbs setup (displayed via Custom Tag) - we will arrayAppend to this down below where needed
	request.breadcrumbs=[
		{"Home"="/"},
		{"QuickLinks"="/?controller="&request.entity}
	];
	return this;
}

public function getPrivateLinks(struct user){
	var links = [];
	var u = entityLoadByPK("user",user.userid);
	var l = entityload("quickLink",{public=false,author=u},"title asc");
	for (var q in l){
		var s = {
			"title"=q.getTitle(),
			"url"=q.getURL(),
			"newWindow"=q.getNewWindow()
		};
	}
	
}
	
/* 
default - lists any Hero Entities for showing in the default list page
 */	
public string function default(){
	
	
	/* request.event.setEventType("Growl");
	 request.event.setValue("alert",{title="Test",description="Testing, Testing, 1-2-3"});
	request.announceEvent(request.event);*/
	
	// load page data
	var u = entityLoadByPK("user",session.oUser.userid);
	request.listArray  = ORMExecuteQuery("from quickLink where author = :author",{"author"=u});
	
	// return which view to show
	return "/view/"&request.entity&"/default.cfm";
}
	

/* 
form - gets information about an item (if it exists) and resents it
 */
public string function form(){
	request.pageName = "Quick Link Details";
	// set up entity and action for ELS (Entity Level Security))
	var oID = condense("id");
	
	request.o = entityLoadbyPK(request.entity, oID);
	if (isNull(request.o) OR (request.o.getAuthor().getID() neq session.oUser.userid))
		request.o = entityNew(request.entity);
	

		
	
	request.breadcrumbs.append({"Details"=""});
	// return which view to show
	return "/view/"&request.entity&"/form.cfm";
}

/* 
set - sets information about an item (creates it if it doesn't exist) and bounces you to the form
 */
public string function set(){
	var taglist = condense("tagList","");
	var u = entityLoadByPK("user",session.oUser.userID);
	var oID = condense("itemID");
	var active = condense("active");
	var newWindow = condense("newWindow");
	

	transaction{	
		var o = entityLoadbyPK(request.entity,oID);			
		if (isnull(o)){
			o = entityNew(request.entity); 
			o.setInternalID(createUUID());
			o.setAuthor(u);
		}

		// quick check to stop people from stealing items they don't own
		if (o.getAuthor().getID() eq session.oUser.userid){	

			// If Validation Passes
			o.setTitle(trim(form.title));
			o.setEditor(u);
			o.setURL(trim(form.URL));
			
			o.setPublic(active);
			o.setNewWindow(newWindow);
		
		  	
			session.formScope = form;
			if (true){
				if (not(val(oID)))
					EntitySave(o);
				transaction action="commit";
				success = true;
			} else {
				transaction action="rollback";
				success = false;
			}
			}
			else {
		
		location(url="/?controller="&request.entity, addtoken="false");		
	}
	

		} // end transaction

	if (success){    
	   	growl("entitySave");
    		location("/index.cfm?controller="&request.entity&"&do=form&id="&o.getID(),false);    
	} else {    
		growl("entityError");
		location("/index.cfm?controller="&request.entity&"&do=form&id="&o.getID(),false);    
	}
	abort;	
	} 
	


/* 
Delete - deletes the item and routes you to the list/default page
*/
public function delete(){

	if (not(structKeyExists(form,"confirm"))){
		sAlert = {title="Confirmation not detected!", type="danger", description="Please check the confirm box if you would like to delete this item", datecreated=now()};
		request.event.setEventType("Growl");
		request.event.setValue("alert",sAlert);
		request.announceEvent(request.event);
	    	
	    	location(url="/?controller="&request.entity&"&do=form&id="&condense("id"), addtoken="false");
	}
   
   transaction {
		var o = entityLoadByPK(request.entity, condense("id"));
		if (not(isNull(o))){
			entityDelete(o); // delete the entity from the database
		}
	} // end transaction
	growl("entityDelete");
	location(url="/?controller="&request.entity);
}

// End Component
}