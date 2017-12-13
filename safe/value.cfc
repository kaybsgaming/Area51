component persistent="true" extends="asset" joincolumn="assetID"
{
	property name="version" type="numeric";
	property name="column" fieldtype="many-to-one" cfc="column" fkColumn="fk_columnID";//cascade="save-update"
	property name="columnID" type="string";// we keep this aside, as we directly reference it when determining values by column.
	property name="row" fieldtype="many-to-one" cfc="row" fkColumn="fk_rowID"  ;
	

}