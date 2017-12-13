component persistent="true"
{
 	property name="id" fieldtype="id" column="id" generator="identity" setter="false";
	property name="internalID" type="string";
	property name="dateCreated" ormType="timestamp";
	property name="dateModified" ormType="timestamp";
	property name="isExtended" type="boolean" default="FALSE";
	property name="externalID" type="numeric";
	property name="externalGUID" type="string";
	property name="title" type="string";
	property name="author" fieldtype="many-to-one" cfc="user" fkColumn="fk_authorID";
	property name="editor" fieldtype="many-to-one" cfc="user" fkColumn="fk_editorID";
 	
 	property name="entity" type="string";
 	property name="JSON" ormType="text";
 	
 	// custom data (mapped in application constants)
 	property name="boolean1" type="boolean";
	property name="boolean2" type="boolean";
	property name="boolean3" type="boolean";
	property name="boolean4" type="boolean";
	property name="string1" type="string";
	property name="string2" type="string";
	property name="string3" type="string";
	property name="string4" type="string";
	property name="nText1" type="string";
	property name="nText2" type="string";
	property name="nText3" type="string";
	property name="nText4" type="string";
	property name="numeric1" type="numeric";
	property name="numeric2" type="numeric";
	property name="numeric3" type="numeric";
	property name="numeric4" type="numeric";
	property name="blob1" ormtype="blob";
	property name="blob2" ormtype="blob";
	property name="blob3" ormtype="blob";
	property name="blob4" ormtype="blob";
	property name="timestamp1" ormType="timestamp";
	property name="timestamp2" ormType="timestamp";
	property name="timestamp3" ormType="timestamp";
	property name="timestamp4" ormType="timestamp";
 	
	property name="majorVersion" type="numeric";
	property name="minorVersion" type="numeric";
	property name="publishMajor" type="boolean" default="false" ;
      
	any function init(){
		variables.internalID = createUUID();
  		
  		this.setEntity(getMetaData(this).name);
  			variables.tags=[];
  		// this is a reference for mapping versioned fields. This should actually be handled in the init() method for each entity that extends asset
  		this.mapping = {
				title:"string1"			
		}; 
		variables.versionMapping = serializeJSON(this.mapping);
		this.setIsVersioned(false);// default value for versioning. To cut down on DB bloat etc, Versioning must be explicitly turned on (in code for now) to make it go
	
  	// end mapping reference
	}
      
	any function preInsert(){
		var e = entityLoadByPK("user",session.oUser.userID);
		variables.author=e;
		variables.editor=e;
       	variables.dateCreated = now();
       	variables.dateModified = now();
       	if (isNull(variables.getInternalID()))
       		variables.internalID = createUUID(); 
       	variables.entiry = getMetaData(this).name;
		putVersion();
 	} 
	
	any function preUpdate() {
		var e = entityLoadByPK("user",session.oUser.userID);
		variables.dateModified = now();
		variables.editor = e;
		putVersion();
	
	}

void function addTag( required tag oTag){
	// set up our tag array if we don't have one
	if (not(this.hasTag())){
		variables.tags = [];
	}
	// add the provided tag to this asset (this is what the method we've overwritten would have done)
	arrayAppend(variables.tags, arguments.oTag);
	// add the asset to the tag - this is the new bit, to ensure that bi-directional linking is maintained
	arguments.oTag.addAsset(this);
}

void function removeTag(required tag oTag){
	if (this.hasTag(arguments.oTag)){
		arguments.oTag.removeAsset(this);
		arrayDelete(variables.tags, arguments.oTag);
		
	}
}

void function setTags(required array tags){
	var tag = "";
	if (not(structKeyExists(variables, "tags")))
		variables.tags = [];
	// loop through existing tags
	for (tag in variables.tags){
		// if the new set of tags doesn't include one we already have, remove it
		if(not(arrayContains(arguments.tags, tag))){
			tag.removeAsset(this);
		}
	}
	// loop through the passed in tags
	for (tag in arguments.tags){
		if (not(tag.hasAsset(this))){
			tag.addAsset(this);
		}
	}
	// set the passed in array of tags to this asset (what the original methd would have done)
	variables.tags = arguments.tags;
}

// This is called from preinsert() and preupdate()
public function putVersion(){

}

public function revertTo(numeric nMajor, numeric nMinor){
	// 1. get the version based on this asset, and the requested major and minor version.
	var temp = entityLoad("versionData",{asset=this, majorVersion=arguments.nMajor, minorVersion=arguments.nMinor},true);
	// 2. assign the data to this entity
	if (isNull(temp)){
		location(url="index.cfm?hello", addtoken="false");
			return; // version not found...
	} else {
		
		for (var x in this.mapping){// for each mapped property, this takes the versioned data and updates the Entity with it
			var y = {};
			y[x] = invoke(temp,"get"&this.mapping[x]);
		invoke(this,"set"&x,{argumentcollection=y});// this is the Inception (because we have to) way of saying "this.setXYZ(ABC);" where XYZ is each mapped key, and ABC is the versioned (mapped) data in versionData.
	}
	
	//writedump(this);
	//3. add the new version - handled as part of preUpdate();
//	entitySave(this);
//	ORMFlush();
	
	}
	
}

}