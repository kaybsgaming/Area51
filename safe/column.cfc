component persistent="true" extends="asset" joincolumn="fk_assetID"
{
 		
	property name="list" fieldtype="many-to-one" fkcolumn="fk_listID" cfc="list" missingRowIgnored="true";	
	property name="values" type="array" fieldtype="one-to-many" cfc="value" singularname="value" fkcolumn="fk_columnID" inverse="true" ;
	property name="itemOrder" type="numeric";
	property name="remoteColumn" type="string";
	property name="required" type="boolean";
	property name="typeName" type="string";
	property name="dataType" type="string";
	//property name="itemCount" formula="[TBC]" setter="false"   ; 

 	
}