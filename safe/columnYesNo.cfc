component persistent="true" extends="column" joincolumn="columnID"
{
	property name="default" type="boolean" default="true";
	
		 any function init(){
	this.setTypeName("Yes/No");
	this.setDataType("YesNo");
}
}