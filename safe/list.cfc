component persistent="true" extends="asset" joincolumn="fk_assetID"
{
 	property name="systemOnly" type="boolean" default="false";
 	property name="description" ormtype="string";
 	property name="subscribers" ormtype="string";
	property name="csvFolder" ormtype="string";
	property name="dateLastCSVSync"  ormType="timestamp";
	property name="icon" type="string";
	property name="columns" type="array" fieldtype="one-to-many" cfc="column" singularname="column" fkcolumn="fk_listID" inverse="true";//cascade="all-delete-orphan"
	property name="rows" type="array" fieldtype="one-to-many" cfc="row" singularname="row" fkcolumn="fk_listID" inverse="true";//cascade="all-delete-orphan"
	property name="JSONService" type="string" hint="used for remote lists" ;

	

	

	
	public void function resync(){
		if (len(this.getJSONService)){
			// Async Gateway vs Threading.... Decisions descisions... Need to get onto Railo before we sort this
		}
	}
	
	public function getColumnNames(){
		var aList = EntityLoad("column",{list = this});
		var sList ="";
		for (var k in aList){
			sList = listAppend(sList,k.getTitle()&"="&k.getTypeName());
		}
		return listToStruct(sList);
	}
	
/**
 * Converts a delimited list of key/value pairs to a structure.
 * v2 mod by James Moberg
 * 
 * @param list      List of key/value pairs to initialize the structure with.  Format follows key=value. (Required)
 * @param delimiter      Delimiter seperating the key/value pairs.  Default is the comma. (Optional)
 * @return Returns a structure. 
 * @author Rob Brooks-Bilson (rbils@amkor.com) 
 * @version 2, April 1, 2010 
 */
private struct function listToStruct(list){
       var myStruct = StructNew();
       var i = 0;
       var delimiter = ",";
       var tempList = arrayNew(1);
       if (ArrayLen(arguments) gt 1) {delimiter = arguments[2];}
       tempList = listToArray(list, delimiter);
       for (i=1; i LTE ArrayLen(tempList); i=i+1){
               if (not structkeyexists(myStruct, trim(ListFirst(tempList[i], "=")))) {
                       StructInsert(myStruct, trim(ListFirst(tempList[i], "=")), trim(ListLast(tempList[i], "=")));
               }
       }
	 return myStruct;     
}

public function alertSubscribers(){
	if (len(variables.subscribers)){
		var  mailerService = new mail(); 
		var mailBody = "";
		savecontent variable="mailBody"{ 
                WriteOutput("This message was sent by an automatic mailer" & "<br><br>"); 
            } 
            /* set mail attributes using implicit setters provided */ 
			mailerService.setTo(variables.subscribers); 
            mailerService.setFrom("underdogCMS@gmail.com"); 
            mailerService.setSubject("New item added to list: #variables.getTitle()#"); 
            mailerService.setType("html"); 
            /* add mailparams */ 
          //  mailerService.addParam(file=expandpath(form.attachment),type="text/plain",remove=false); 
            /* send mail using send(). Attribute values specified in an end action like "send" will not persist after the action is performed */ 
            mailerService.send(body=mailBody); 

	}
}

}
