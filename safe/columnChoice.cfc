component persistent="true" extends="column" joincolumn="columnID"
{
 	property name="choices" ormtype="Text";//  (Maybe do this with JSON?)
	property name="displayMode" type="string";// 1 = Dropdown, 2=Radio Buttons, 3=checkbox (Maybe do this with JSON?)
	property name="default" type="string";

any function init(){
	this.setTypeName("Choice Field");
	this.setDataType("Choice");
}	 
}