component persistent="true" extends="asset" joincolumn="assetID"
{
    
    property name="public" type="boolean";
    property name="URL" type="string";
    property name="newWindow" type="boolean" default="false"; 
    
    any function init(){ 
       	this.setDateCreated(now());
        this.setDateModified(now());
 	} 
    
    
}