<!--- TODO Finish this --->
<cfparam name="attributes.queryName" default="newQuery">
<cfscript>
	thisquery = "";
switch (thisTag.executionMode){

	case "start": {break;}
	case "end": {
		
			
				thisQuery = QueryNew(
					thisTag.generatedContent.ReplaceAll( "\s*::[^,]+", "" ).ReplaceAll( ",\s*", ", " ).Trim(),
 					thisTag.generatedContent.ReplaceAll( ",[^:]+::\s*", ", " ).ReplaceAll( "^[^:]+::\s*", "" ).Trim()
				);
					break;}
	
}
</cfscript>