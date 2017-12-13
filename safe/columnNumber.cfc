component persistent="true" extends="column" joincolumn="columnID"
{
 	property name="min" type="numeric";//  (Maybe do this with JSON?)
	property name="max" type="numeric";//  (Maybe do this with JSON?)
	property name="default" type="numeric";//  (Maybe do this with JSON?)
	property name="decimals" type="numeric";//  (Maybe do this with JSON?)
	property name="placeholder" type="string";//  (Maybe do this with JSON?)	
	property name="showAsPercentage" type="boolean" default="false";//  (Maybe do this with JSON?)

 any function init(){
	this.setTypeName("Number");
	this.setDataType("Number");
}

}