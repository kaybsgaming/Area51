component  displayname="Underdog CMS" hint="Application.cfc for Underdog CMS" {
this.name=hash(cgi.server_name)&"_"&hash(getCurrentTemplatePath());
include "/assets/config/settings.cfm";
this.datasource = expandPath( "/" );
this.sessionManagement="true"; 
this.setclientcookies="Yes" ;
this.sessiontimeout="#CreateTimeSpan(0,0,45,0)#" ;
this.applicationtimeout="#CreateTimeSpan(0,0,45,0)#";
this.scriptProtect="false";
this.isSecure=true; // this turns on the security settings within the framework (ie login lockdown etc)
this.rootPath = GetDirectoryFromPath(GetCurrentTemplatePath());
this.triggerDataMember = true;

// mappings
temp = expandPath( "../core/" )&application.ud_version;
this.mappings["/com"]=   temp&"/com/";
this.mappings["/controller"]=   "/controller/";
this.mappings["/model"]=   expandPath("/")&"model/";
this.mappings["/view"]=   "/view/";
structDelete(variables,"temp");
// end mappings

// ORM settings
this.ormEnabled=true;
this.ormSettings = {
	logSQL=false,
	dbCreate = "update",
	useDBForMapping = false, 
	autoManageSession=false,
	flushAtRequestEnd = false,
	eventHandling=true,
	logsql="false",
	cfcLocation=[
		this.mappings["/model"]
	]

};

public boolean function onApplicationStart(){
	include "/assets/config/settings.cfm";	
	var temp = GetApplicationMetaData().datasource;// grab the datasource name from the application context
	var currentPath = expandPath("/");
	
	if (findNoCase("underdog",temp) or findNoCase("area51", temp)){									// We use this setting to determine whether to show debug/dev-only type feedback in the UI
		application.underdog = true;
	} else {
		application.underdog = false;
	}

	// ORM Handling - only works when working on a %underdog% datasource
	// TODO: refactor away from underdog datasource and switch to application.sb_version based application setting
	// Signal to the ORM that we want to drop and then re-create our database.	
	if (structKeyExists(url,"refresh") && application.underdog){
		// Signal to the ORM that we want to update existing tables or add new ones.
		this.ormSettings.dbCreate = "update";
		ORMReload();
	}
		// Removed for safety
		if (structKeyExists(url,"rebuild") && application.underdog){
			// Signal to the ORM that we want to nuke the model from orbit (it's the only way to be sure) and rebuild the database
			this.ormSettings.dbCreate = "DropCreate";
			 ORMReload();
	   }
	// END OF ORM HANDLING	

	// application level utilities & components
	application.security=  new com.practicalpixels.security();// security checking, hashing, and authorisation
	application.tagManager = new com.underdog.tagManager();
	// application.util = new com.practicalpixels.util(); // 20171206 - removed this so it forces regression breaks. Should use request.util instead (to ensure any overwriting doesn't happen by mulitple users)
	application.wwwDir = replaceNocase(expandPath("/"),"admin.","www.");// current dev convention
	application.wwwDir = replaceNocase(application.wwwDir,"-admin","-www");// current prod convention
	application.wwwPath = expandPath(application.wwwDir);
	application.www = listLast(application.wwwDir,"/");
	application.assetStore = expandPath(application.wwwDir&"/assets/store/");
	// application constants
	refreshConstants();
	return true;
}

public boolean function onRequestStart(){
	var currentPath = listLast(getDirectoryFromPath(getCurrentTemplatePath()),"\/");
	var isLocal = structKeyExists(URL,"email") && URL.email && (not(compareNoCase(cgi.server_name,cgi.remote_addr)) && not(compareNoCase(cgi.server_name,"127.0.0.1"))); // if the request is coming locally, from the server, then we can slip auth
	//echo(currentPath);
	
	request.util = new com.practicalpixels.util();

	// ORM Handling - REMOVE WHEN IN PROD
	// Signal to the ORM that we want to drop and then re-create our database.	
	request.ORMReload = false;
	if (structKeyExists(url,"refresh") && application.ud_version is "Dev"){
		// Signal to the ORM that we want to update existing tables or add new ones.
		this.ormSettings.dbCreate = "update";
		ORMReload();
	}

	
	// restarts the application and resets our session
	if (structKeyExists(url,"restart")){
	    onApplicationStart();
		onSessionStart();
	}
	if (structKeyExists(URL,"refresh") OR structKeyExists(URL,"rebuild")){
		refreshConstants();
	}
	
	if (this.isSecure && !(isLocal)){
		securitycheck();
		if (not(structKeyExists(session,"quickLinks"))){
			request.do = "getPrivateLinks";
			var c = new controller.quicklink();
			c.getPrivateLinks(session.oUser);
		}
	}
	
	request.out.breadcrumbs=[];

	// used for appending javascript to the end of the page
	request.JScript = [];

	request.module="Home"; // we can change this in the controller to highlight areas of the nav bar in the view   	
	request.breadcrumbs=[];
	request.modals=[];// used to inject any modal content from forms to the bottom of the page

	header  name="expires" value="#now()#"; 
	return true;
}

public boolean function onCFCRequest(string cfc, string method, struct args) {
	/*
	writeLog(file="cfcfix",text="Running onCFCRequest for #arguments.cfc#, method #arguments.method#, args: #structKeyList(arguments.args)#"); 
	var comp = createObject("component", arguments.cfc); 
	var res = evaluate("comp.#arguments.method#(argumentCollection=arguments.args)"); 
	if(isDefined("res"))
		writeOutput(res); 
	*/
	return true; 
}

public void function onRequest(string targetPage){
	request.isEmailContent = (structKeyExists(url,"email") && URL.email);
	request.processor = new com.underdog.processor();
	request.publiclinks= EntityLoad("quickLink",{public:true},"title asc");
	request.privatelinks= request.isEmailContent ? [] : ORMExecuteQuery("from quickLink where fk_authorID = #val(session.oUser.userID)# AND public=:public ",{public=false});

	// set up the controller and action (defaults to the default() method in the default component)
	request.controller=structKeyExists(URL,"controller") ? url.controller : "underdog";
	request.do=structKeyExists(URL,"do") ? url.do : "default";
	
	request.controller = createObject("component","controller."&request.controller).init();// every controller must have an init() method for ELS
	request.view = invoke(request.controller,request.do);// call the actual controller method (assuming init/ELS passes)
	
	include request.view;
	return;
}
 
public void function onRequestEnd(){
	if (structKeyExists(request,"clearORM") AND request.clearORM)
		ORMClearSession();
	// clear the alerts for this request (cflocation is considered the same request, so we can use this to cheese Growl alerts etc)
	session.alerts=[];
}

public void function onSessionEnd(){
		application.security.destroysession();
}

public void function onSessionStart(){
		session.alerts=[];
}

public void function announceEvent(com.practicalpixels.event e){
	application.eventHandler.announceEvent(e);
}
	
/*public function onError(any except, string eventName){
	
	content reset="true";
		
	var view = "default";
	request.in.error = except;
	request.out.message = eventName;
	request.controller = createObject("component","controller.error").init();
	if (structKeyExists(except,"Type") AND except.type is "MissingInclude")
		view = "error404";
	request.view = invoke(request.controller,view);
	include request.view;		
	
}*/


private void function securityCheck(){
	// First priority - if they aren't on login.cfm, aren't logging in and don't have a valid session, bounce them.
		if ((application.security.isAnonymous()) && !structKeyExists(form,"j_username")){
			application.security.destroySession();
			location("/login.htm",false);
		}
		
		// if we've instructed via URL to log them out, bounce them	
		if (!isNull(url.logout )){
			application.security.destroySession();
			location("/login.htm",false);
		}
	

		
		// XSS Protection - if you're not on login.cfm, you've submitted a form, and your CGI referrers look dodgy, then get outta here.
		 if (structCount(form) &&   (!( len(cgi.http_referer) ) || !( findnocase(cgi.http_host,cgi.http_referer)))){
			destroySession(true);
			location("/login.htm",false);
		}	

		if (application.security.isAnonymous()){
			if (structKeyExists(form,"j_username")) {

				if (len(trim(form.j_username)) AND len(trim(form.j_password))){

					tempUser = application.security.authenticate(strUserName = form.j_username, strPassword=form.j_password);
					if (application.security.isAnonymous()){ 
						application.security.destroySession(); 	  
					}else{
						onSessionStart();
					}
				}else{ 
					
					application.security.destroySession();
				}
			}    else {
				
				application.security.destroySession();
		}
	}
		// if we are initiating Entity Level security, execute it
	if (structKeyExists(request,"entity") AND structKeyExists(request,"entityAction"))
		application.security.entityAuthorise(request.entity, request.entityAction);
}
private function process404(){
	cfheader( statuscode="404" statustext="Page not found");
	abort;
}

private function refreshConstants(){
	//var aConstants = EntityLoad("constant",{active=true});
	//if (isNull(aConstants) OR NOT(ArrayLen(aConstants))){
		var underdog = new controller.underdog();
		underdog.setup();

		var aConstants=EntityLoad("constant",{active=true});
	//}
	for (o in aConstants){
			application.constants[o.getTitle()] = isJSON(o.getSetting()) ? deserializeJSON(o.getSetting()) : o.getSetting();	
	}
	//application.security.destroySession();
}

}