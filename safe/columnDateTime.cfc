component persistent="true" extends="column" joincolumn="columnID"
{
 	property name="showDate" type="boolean" default="true";
	property name="showTime" type="boolean" default="true";
	property name="defaultToNow" type="boolean" default="false";
	property name="default" ormType="timestamp";
	property name="dateFormat" type="string" default="MMM DD YYYY";
	property name="timeFormat" type="string" default="HH:mm:ss";
	
 any function init(){
	this.setTypeName("Date/Time");
	this.setDataType("DateTime");
}
	 
}