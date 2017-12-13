component persistent="true" extends="column" joincolumn="columnID"
{
 	property name="length" type="numeric";
	property name="placeHolder" type="string"; 	
	property name="default" type="string" ;
	
any function init(){
	this.setTypeName("Single line of Text");
	this.setDataType("NVarChar");
}
	 
}