component persistent="true" extends="column" joincolumn="columnID"
{
 	property name="editLines" type="numeric" default="6";
	property name="displayMode" type="string" length="10" default="plain";
	property name="default" type="string";
	 
	 	
any function init(){
	this.setTypeName("Text Box");
	this.setDataType("NText");
}
}