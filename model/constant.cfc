component persistent="true" 
{
	property name="id" fieldtype="id" column="id" generator="identity" setter="false";
	property name="title" type="string";
 	property name="setting" type="string" length="7000" ;
	property name="active" type="boolean" default="false";
	property name="public" type="boolean" default="false";
	property name="system" type="boolean" default="false";
	property name="helper" type="string" length="255" ;

public function postInsert(){
	application.constants[getTitle()] = getSetting();
}

public function postUpdate(){
	application.constants[getTitle()] = getSetting();
}
	 	
}