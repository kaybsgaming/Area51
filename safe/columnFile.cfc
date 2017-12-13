component persistent="true" extends="column" joincolumn="columnID"
{   
	property name="filename" type="string";
	property name="contentMimeType" ormtype="string";
	property name="contentSubType" ormtype="string";
	property name="fileExt" ormtype="string";
	property name="size" ormtype="int"; 
 	property name="thumbBLOB" ormtype="blob";
 	property name="imageBLOB" ormtype="blob";
	property name="isFile" type="boolean" default="false";
	property name="mimeType" fieldtype="many-to-one" cfc="mimetype" fkColumn="mimeTypeID";
	property name="outputType" type="string" default="output";// could be URL, which would just provide a link (which would imply we have a handler on the end of that link)
	 
any function init(){
	this.setTypeName("File/Image");
	this.setDataType("File");
}

/*
getImageBlob - returns the imageBlob, even if it is stored in the filesystem
*/	

public any function getBlob(){
	if (this.getIsFile()){
		// if it is stored in the file System., then read and return it
		return(ToBase64(FileReadBinary(application.constants.assetstore & this.getinternalID()&"."&this.getFileExt())));
	}else {
		// otherwise, return the BLOB from the DB
		return(this.getImageBlob());
	}
} 


/*
absorbImage - takes the upload struct from a file upload and processes all the metadata into the entity.
*/
public void function absorbImage(struct upload){
	var local={};
	try {
	
	// inspect and read the file we just uploaded
        	local.fileInfo = GetFileInfo("#application.constants.assetStore##arguments.upload.serverfile#");
	
	createImageFromPDF(source="#application.constants.assetStore##arguments.upload.serverfile#", destination="#application.constants.assetStore##getInternalID()#.#this.getFIleExt()#");
        	local.myImage = imageRead("#application.constants.assetStore##getInternalID()#.#this.getFIleExt()#");
        	local.mimetype = ORMExecuteQuery("from mimeType where contentType = '#arguments.upload.contentType#/#arguments.upload.contentSubType#' AND fileExt = '.#arguments.upload.serverFileExt#'", true);

        	if (not(isNull(local.mimeType))){
		this.setMimeType(local.mimetype);
	}
 	// set a bunch of info about the file in the entity
 	
 	
	this.setSize(arguments.upload.filesize);
	
	this.setContentMimeType(arguments.upload.contentType);
	this.setContentSubType(arguments.upload.contentSubType);
	this.setFileName(arguments.upload.attemptedServerFile);
	this.setFileExt(arguments.upload.serverFileExt);

	// Set up the file blob. If it is small, store it in the DB, if it is large, store it in the FIle System
	this.setImageBlob(ToBase64(fileReadBinary("#application.constants.assetStore##arguments.upload.serverfile#")));
	
	if (arguments.upload.filesize lt 524288)
		this.inhale();
	else
		this.exhale();
	
	// Delete the original file that was passed into the function
	filedelete(application.constants.assetStore&arguments.upload.serverfile);
		
	// set up the thumbnail
	imageScaleToFit(local.myImage, 240, "", "highestPerformance");
	this.setThumbBLOB(imageGetBlob(local.myImage));
	} catch (any e) {
	application.util.debug(e);

}


}
	
/* 
Inhale - draws the image from the file system into the DataBase
 */
public void function inhale(){
	this.setImageBLOB(this.getBlob());
	if (fileExists(application.constants.assetStore&this.getInternalID()&"."&this.getFileExt()))
		fileDelete(application.constants.assetStore&this.getInternalID()&"."&this.getFileExt());
	this.setIsFile(false);
}

/* 
Exhale - expels the image from the DataBase into the file system
 */	
public void function exhale(){
	if (not(fileExists(application.constants.assetStore & this.getInternalID() & "." & this.getFileExt())))
		filewrite(application.constants.assetStore & this.getInternalID() & "." & this.getFileExt(), getImageBlob());
	this.setImageBLOB(javacast("NULL",""));
	this.setIsFile(true);
	}


/* 
createImageFromPDF - wrapper to simplify thumbnail generation
 */
private void function createImageFromPdf(required string source, required string destination, numeric pages = 1, string resolution = "high", numeric scale = 100, boolean overwrite = true){
	var pdf = new pdf();
	pdf.setSource(arguments.source);
	pdf.thumbnail(pages = arguments.pages, resolution = arguments.resolution, scale = arguments.scale, overwrite = arguments.overwrite);
}

}