component {
    public function init(){
		variables.URLs=[
			"https://mt-dev.aeronet.nz/rc-handler/V4/cron/cron?key=h3CzmVEJIdcfEs7k&mime-type=application/json&status_id=5",
			"https://dev.aeronet.nz/rc-handler/V4/cron/cron?key=hCIOiKkzzr4m5mXK&mime-type=application/json&status_id=5"
		];
        return this;
	}

	public string function default(){
		var urls = [
			"https://mt-dev.aeronet.nz/rc-handler/V4/cron/cron?key=h3CzmVEJIdcfEs7k&mime-type=application/json&status_id=5",
			"https://dev.aeronet.nz/rc-handler/V4/cron/cron?key=hCIOiKkzzr4m5mXK&mime-type=application/json&status_id=5"
		];
		request.data = checkCrons(urls);
		return "/view/cron/default.cfm";
	}

	public string function email(){
		var temp="";
		var to = "marty@aeronet.nz";
		var from = "marty@aeronet.nz";
		var subject = "cron test";
		http url="http://127.0.0.1:64510/?controller=cron&email=true" method="get" result="temp";
		//dump(temp);
		sendGrid(body=temp.filecontent, to=to, from=from, subject=subject);
		return "/view/cron/email.cfm";
	}

	/*
	Loop over the URLs provided, and parse the JSON returned from each to assess the status of each Cron on the server
	*/
	public array function checkCrons(array urls){
		var out = [];
		var temp = "";
		var r = {};
		for (var u in urls){
			r={};
			r.server = {};
			r.server.url = u;
			r.server.name = listgetat(u,2,"/");
			try {
				http url=u method="get" result="temp";
				if (temp.status_code is "200"){
					if (isJSON(temp.filecontent)){
						r.server.results=assessServer(temp.filecontent);
						// dump(temp.filecontent);
						temp = "";
					} else {
						
						r.server.error = "HTTP 200 OK, but no JSON Returned";
						r.server.results = temp.fileContent;
					}
				} else {
					dump(temp);
					abort;
				} 
			}  catch (any e) {
				dump(e);
				abort;
				r.server = {};
				r.server.error = "Server not resonding";

				r.server.results = "";
			}	
		arrayAppend(out, r);
		}
		return out;
	}

	private array function assessServer(string s){
		var out = [];
		var json = deserializeJSON(s);
		
		for (var c in json.data){
			arrayappend(out, assessCron(c));
		}
		return out;
	}

	private struct function assessCron(struct s){
		var out = {};
		var f = getChronSchedule(s.frequency);
		// dump(s);
		out["id"] = s.id;
		out["description"]= s.description;
		out["active"] = s.active;
		out["lastRun"] = structKeyExists(s, "last_run") ? s.last_run : "Never";
		out["frequency"] = f;
		
		if (structKeyExists(s,"last_run")){
			out["status"] = getChronStatus(f, s.last_run);
			out["ago"] = getCronAgo(f, s.last_run);
		} else {
			out ["ago"] = "Infinite time"
			out["last_run"] = "Never";
			out["status"] = "Never";	
		}
		//echo(s.frequency&" = "&out["frequency"]&" - Last Run: {"&s.last_run&"} - status = "&out["status"]&"<br>");
		//dump(out["status"]);
		return out;
	}

	private string function getCronAgo(string schedule, date lastRun){
		var out = "";
		switch (schedule){
			case "daily": {
				out = datediff("h",lastRun,  now()) & " hours";
				break;
			}
			case "weekly": {
				out = datediff("d",lastRun,  now()) & " days";
				break;
			}
			case "monthly":{
				out = datediff("d",lastRun,  now()) & " days";
				break;
			}
			case "hourly":{
				out = datediff("n",lastRun,  now()) & " minutes";
				break;
			}
			case "minute":{
				out = datediff("s",lastRun,  now()) & " seconds";
				break;
			}
			case "never":{
				out = "Unknown time";
				break;
			}
			default: {
				out = "Unknown time";
			}
		}
		return out;
	}

	private string function getChronStatus(string schedule, date lastRun){
		var out = "danger";
		switch (schedule){
			case "daily": {
				//echo(lastRun&" - "&now());
				if(datediff("h",lastRun,  now()) lt 24){
				out = "success";	
				};
				break;
			}
			case "weekly": {
				if(datediff("d",lastRun,  now()) lt 7){
					out = "success";	
					};
				break;
			}
			case "monthly":{
				if ((month(now()) gt month(lastRun)) && (day(now()) lt day(lastRun))){
					out = "success";	
					};
				break;
			}
			case "hourly":{
				if(datediff("n",lastRun,  now()) lt 60){
					out = "success";	
					};
				break;
			}
			case "minute":{
				if(datediff("s",lastRun,  now()) lt 60){
					out = "success";	
					};
				break;
			}
			case "never":{
				out = "Never";
				break;
			}
			default: {
				out = "warning";
			}
		}
		return out;
	}

	private string function getChronSchedule(string status){
		var out = "";
		/*
		From Dave: "3rd or 4th col != * then should run monthly.
		if 5th col != * then should run weekly
		if 2nd != * it should run daily.
		if 1st != * then should run hourly (edited)
		do those in if elseif elseif else
		otherwise its all * * * * * and runs every minute"
		*/
		//dump(status);
	 	if (not(len(trim(status)))){
			out = "unknown";
		 } else if (not(compareNoCase(trim(status), "never"))){
			out = "never";
		} else if (compareNoCase(listgetat(status,3," "),"*") || compareNoCase(listgetat(status,4," "),"*")){
			out = "monthly";
		} else if (compareNoCase(listLast(status," "),"*")){
			out = "weekly";
		} else if (compareNoCase(listgetat(status,2," "),"*")){
			out = "daily";
		} else if (compareNoCase(listFirst(status," "),"*")){
			out = "hourly";
		} else if (not(compareNoCase(status,"* * * * *"))){
			out = "minute";
		} else {
			out = "unknown";
		}
		return out;
	}

   

	/* 
	Function to return the reference JSON for the Cron Checker
	*/
	public struct function referenceJSON(){
		var out = {
			"data": [
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "",
					"cron_admin_id": "63",
					"description": "Sends in email to notify when stock report is out for any day",
					"int_2": "0",
					"string_4": "",
					"id": "3",
					"include_path": "mod_parts/plugins/cron/",
					"text_3": "",
					"frequency": "never",
					"active": "1",
					"updated_by": "0",
					"created_by": "738",
					"include_prefix": "parts_debug_notify",
					"string_3": "",
					"type": "",
					"status_id": javacast("null",""),
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2009-04-02 11:52:23",
					"name": "Sends in email to notify when stock report is out for a",
					"string_2": ""
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "",
					"cron_admin_id": "104",
					"int_2": "0",
					"description": "Analyze all the cost and income and reconcile the job cost.",
					"string_4": "",
					"include_path": "mod_job_costs/plugins/cron/",
					"id": "4",
					"text_3": "",
					"frequency": "never    ",
					"updated_by": "0",
					"active": "1",
					"created_by": "10",
					"include_prefix": "job_costs_reconcile",
					"string_3": "",
					"status_id": "1",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2009-04-17 02:06:47",
					"string_2": "",
					"name": "Reconciles the job costs"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "",
					"cron_admin_id": "122",
					"int_2": "0",
					"description": "Finds user clockins and if no clockout for the day force a logout",
					"string_4": "",
					"include_path": "mod_users/plugins/cron/",
					"id": "6",
					"text_3": "",
					"frequency": "never",
					"updated_by": "0",
					"active": "1",
					"created_by": "738",
					"include_prefix": "users_auto_logout",
					"string_3": "",
					"status_id": "0",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2011-04-04 12:27:35",
					"string_2": "",
					"name": "Force user logout"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "luis",
					"text_1": "",
					"cron_admin_id": "132",
					"int_2": "0",
					"description": "Techlog Update Aircraft",
					"string_4": "",
					"include_path": "mod_techlog/plugins/cron/",
					"id": "7",
					"text_3": "",
					"frequency": "never",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "techlog_update_aircraft",
					"string_3": "",
					"status_id": "0",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2013-07-22 10:54:13",
					"string_2": "",
					"name": "Techlog Update Aircraft"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "30",
					"text_1": "info@aeronet.co.nz",
					"cron_admin_id": "149",
					"int_2": "0",
					"description": "Email if part is expired based on due date",
					"string_4": "",
					"include_path": "mod_registers/plugins/cron/",
					"id": "8",
					"text_3": "Shelf Life Due In 30 Days",
					"frequency": "never    ",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "registers_email_shelflife",
					"string_3": "",
					"status_id": "2",
					"type": "",
					"text_2": "info@aeronet.co.nz",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2015-01-27 16:58:14",
					"string_2": "4",
					"name": "Email if part is expired based on due date"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "",
					"cron_admin_id": "159",
					"int_2": "0",
					"description": "Resync Lastest V2Track records. This will check the last date recorded and request the next 500 records. Its recommended to sync using the advanced search sync feature first to generate a maximum date to sync from.",
					"string_4": "",
					"include_path": "mod_v2track/plugins/cron/",
					"id": "11",
					"text_3": "",
					"frequency": "10 22 * * *",
					"updated_by": "0",
					"active": "1",
					"created_by": "2",
					"include_prefix": "v2track_sync",
					"string_3": "",
					"status_id": "2",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2015-08-04 11:50:49",
					"string_2": "",
					"name": "V2track Sync of Lastest records"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "",
					"cron_admin_id": "134",
					"int_2": "0",
					"description": "Aircraft Import (Specific to import Fixed Wing for Mcdermott)",
					"string_4": "",
					"include_path": "mod_aircraft/plugins/cron/",
					"id": "14",
					"text_3": "",
					"frequency": "00 00 * * *",
					"updated_by": "0",
					"active": "1",
					"created_by": "1",
					"include_prefix": "aircraft_import",
					"string_3": "",
					"status_id": "1",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2015-12-22 14:40:46",
					"string_2": "",
					"name": "Aircraft Import"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "upload",
					"text_1": "",
					"cron_admin_id": "165",
					"int_2": "0",
					"description": "Sync Aircraft Upload",
					"string_4": "luis",
					"include_path": "mod_aircraft/plugins/cron/",
					"id": "15",
					"text_3": "",
					"frequency": "never    ",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "aircraft_sync",
					"string_3": "878",
					"status_id": "2",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2016-02-24 13:15:03",
					"string_2": "1,19",
					"name": "Sync Aircraft"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "download",
					"text_1": "",
					"cron_admin_id": "165",
					"int_2": "0",
					"description": "Sync Aircraft Download",
					"string_4": "luis",
					"include_path": "mod_aircraft/plugins/cron/",
					"id": "16",
					"text_3": "",
					"frequency": "2 2 * * *",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "aircraft_sync",
					"string_3": "878",
					"status_id": "2",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2016-02-24 13:37:51",
					"string_2": "1,19",
					"name": "Sync Aircraft"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "",
					"cron_admin_id": "155",
					"int_2": "0",
					"description": "Checking and Updating Discrepancies",
					"string_4": "",
					"include_path": "mod_global/plugins/cron/",
					"id": "17",
					"text_3": "",
					"frequency": "1 * * * *",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "global_discrepancy_test",
					"string_3": "",
					"status_id": "1",
					"type": "",
					"text_2": "",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2016-03-15 18:05:21",
					"string_2": "",
					"name": "Global Discrepancy Test"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "rlangefeld@module.net.nz",
					"cron_admin_id": "166",
					"int_2": "0",
					"description": "Sends in email to configured user with md stock list",
					"string_4": "",
					"include_path": "mod_parts/plugins/cron/",
					"id": "18",
					"text_3": "",
					"frequency": "never",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "parts_email_md_stock",
					"string_3": "",
					"status_id": "1",
					"type": "",
					"text_2": "http://prod1.aeronet.mymd.modulenz.net/rc-handler/V1/parts/parts_mymd_list/979/?key=yLi16TWyN5tio&mime-type=application/json",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2016-05-20 14:12:51",
					"string_2": "",
					"name": "Sends in email to configured user with md stock list"
				},
				{
					"notes": "",
					"int_3": "0",
					"int_1": "0",
					"string_1": "",
					"text_1": "Componet To Retire List",
					"cron_admin_id": "167",
					"int_2": "0",
					"description": "Sends a daily email to configured list of user with list of components on aircraft which are due to retire or overhaul and dont have a item sitting in stock for replacement",
					"string_4": "",
					"include_path": "mod_aircraft/plugins/cron/",
					"id": "19",
					"text_3": "jobyc@module.net.nz",
					"frequency": "never    ",
					"updated_by": "0",
					"active": "1",
					"created_by": "878",
					"include_prefix": "aircraft_email_component_to_retire",
					"string_3": "",
					"status_id": "1",
					"type": "",
					"text_2": "jobyc@module.net.nz",
					"updated_date": "0000-00-00 00:00:00",
					"created_date": "2016-06-21 16:26:39",
					"string_2": "",
					"name": "Aircraft Email Component To Retire List"
				},
				{
					"notes": "c",
					"int_3": "4",
					"int_1": "0",
					"string_1": "d",
					"text_1": "",
					"cron_admin_id": "137",
					"int_2": "3",
					"description": "Apdates the aircraft limitation warning colors alongwith the aircraft warning colors.",
					"string_4": "h",
					"include_path": "mod_aircraft/plugins/cron/",
					"id": "20",
					"text_3": "",
					"frequency": "0 1 * * *",
					"updated_by": "0",
					"active": "0",
					"created_by": "0",
					"include_prefix": "aircraft_warning_processor",
					"string_3": "f",
					"status_id": "1",
					"type": "",
					"text_2": "",
					"updated_date": "2017-12-06 16:01:21",
					"created_date": "2017-12-06 12:03:27",
					"string_2": "b",
					"name": "FAircraft Warning Update"
				}
			],
			"order_by": "`id`",
			"result_msg": "",
			"total_pages": 1,
			"total_records": "13",
			"page_records": 13,
			"filters": [],
			"limit": "50",
			"order_by_direction": "ASC",
			"index": "0",
			"page": "1",
			"filter_expr": "",
			"result_code": "",
			"record_limit": "200"
		};
		return out;
	}

	private void function sendGrid(){
		// var	api = new controller.sendgrid();
		var mail = new mail();


	if (not(len(arguments.to)))
		return;
	// Set it's properties
	mail.setSubject(arguments.subject);
	mail.setTo(arguments.to);
	mail.setFrom(arguments.from);
	
	// mail.setFailTo( "failto@coldgen.com" );
	// mail.setReplyTo( "replyto@coldgen.com" );
	 
	// Set the priority (1, 2 or 3 - High to Low)
	mail.addParam(name="X-Priority", value="1" );
	
	// Add an attachment, remove from server after sending
	// mail.addParam( file="C:\foo.txt", remove="true" );
	
	// Add email body content in text and HTML formats
	mail.addPart( type="text", charset="utf-8", wraptext="72", body=arguments.body );
	mail.addPart( type="html", charset="utf-8", body=arguments.body );
	
	// Send the email message
	mail.send();

	}
	
}