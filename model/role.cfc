component  displayname="Role" hint="Role and associated permissions" output="false" accessors="true" persistent="true"       
{
	property name="id" fieldtype="id" column="id" generator="identity" setter="false";
	property name="internalID" type="string";
	property name="title" type="string" length="50";
	property name="system" type="boolean" default="false";
	property name="active" column="active" type="boolean" default="false";
	property name="publicGroup" type="boolean" default="false";   
	property name="requiresApproval" type="boolean" default="true";  
	
	property name="customFields" ormType="text";
	
	property name="users" fieldtype="many-to-many" cfc="user" type="array" inverse="true" singularname="user" fkcolumn="fk_roleid" inversejoincolumn="fk_userid" linktable="roles_users";

public function init(){
	variables.internalID = createUUID(); 
	variables.keys=[];
}	

any function preInsert(){ 
	if (isnull(variables.internalID) OR not(isvalid("GUID",variables.internalID)))
		this.setInternalID(createUUID()); 
} 
	
any function preUpdate() {
	if (isnull(variables.internalID) OR not(isvalid("GUID",variables.internalID)))
		this.setInternalID(createUUID()); 
}

}
