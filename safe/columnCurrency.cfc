component persistent="true" extends="column" joincolumn="columnID"
{
 	property name="min" type="numeric";
	property name="max" type="numeric";
	property name="default" type="numeric";
	property name="placeHolder" type="string";
	property name="decimals" type="boolean";
	
	
 any function init(){
	this.setTypeName("Currency");
	this.setDataType("Currency");
}
}