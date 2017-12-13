component  displayname="admin" hint="admin user object" persistent="true" table="admin"       
{
	property name="id" fieldtype="id" column="id" generator="identity" setter="false";
	property name="username" column="username" type="string" length="50";
	property name="twitter" column="twitter" type="string" length="100";
	property name="facebook" column="facebook" type="string" length="100";
	property name="instagram" column="instagram" type="string" length="100";
	property name="pinterest" column="pinterest" type="string" length="100";
	property name="email" column="email" type="string" length="100";
	property name="salt" column="salt" type="string" length="1024";
	property name="password" column="password" type="string" length="2048";
	property name="active" column="active" type="boolean" default="false";
	property name="requiresApproval" column="requiresApproval" type="boolean" default="true";
	property name="profile" ormType="text";// this is a JSON struct that will hold custom profile data defined by the custom keys defined against any given role
	property name="roles" fieldtype="many-to-many" cfc="role" type="array" singularname="role" linktable="roles_users" fkcolumn="fk_userid" inversejoincolumn="fk_roleid" lazy="true"   ;
 	
	property name="description" ormType="text";
	property name="dateCreated" ormType="timestamp";
	property name="dateModified" ormType="timestamp";
	property name="dateLoggedOn" ormType="timestamp";
	property name="status" ormType="string" default="Applicant";  
	
	any function init(){
		variables.profile="{}";
	}
	
any function preInsert(){ 
	this.setDateCreated(now());
	
} 

public boolean function profileIsMissingRequiredFields(){
	for (var r in variables.roles){
		for (var ka in r.getKeys()){
			if (ka.getRequired() AND not(len(profile[r.getID()][ka.getID()][ka.getKey().getID()].value))){
				return true;
			}
		}
	}
	return false;
}
}
