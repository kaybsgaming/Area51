component persistent="true" extends="asset" joincolumn="assetID"
{
	property name="list" fieldtype="many-to-one" fkcolumn="fk_listID" cfc="list";		
	property name="version" type="numeric";
	property name="values" type="struct" fieldtype="one-to-many" structKeyColumn="columnID" cfc="value" fkcolumn="fk_rowID" singularname="value" inverse="true"  ;

	/*any function preInsert(){ 
       	variables.dateCreated = now();
       	variables.dateModified = now();
       	if (isNull(variables.getInternalID()))
       		variables.internalID = createUUID(); 
       	variables.entiry = getMetaData(this).name;
		putVersion();
 	} 
	
	any function preUpdate() {
	
		variables.dateModified = now();
		putVersion();
	
	}*/
}