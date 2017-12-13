<cfparam name="attributes.id" default="itemTags" >
<cfscript>
string function tmTagList(list, delim=","){
	var tempList="";
	var i=0;
	var delimiter= arguments.delim;
	var returnstring = '"';
	if (ArrayLen(arguments) gt 1){
		// if there is a delimiter passed in, use it
		delimiter = arguments[2];
	}

	totalLen=ListLen(list, delimiter);// calculate the length of the list
	for (i=1; i LTE totalLen; i=i+1){// loop over the list
		returnstring = returnstring & trim(listGetAt(list, i, delimiter))&'"';
  		if  (i lt totalLen)
			returnstring = returnstring & ',"';
	}
	return returnString;
}
</cfscript>
<cfswitch expression="#thistag.executionMode#">
<cfcase value="start">
<cfoutput>

<input type="hidden" name="#attributes.id#_tagList" id="#attributes.id#_tagList">

<cfif not(structKeyExists(attributes, "noLabel"))><label class="label"><i class="icon-tag"></i> Tags</label></cfif>
<label class="input"><input type="text" id="#attributes.id#" autocomplete="off" placeholder="Tags" data-original-title=""/></label>
<cfsavecontent variable="jScriptInject" >
 <script>
    var tagAPI = jQuery("###attributes.id#").tagsManager({
    blinkBGColor_1: '##FFFFFF',
    blinkBGColor_2: '##EFEFEF',
	hiddenTagListName: '#attributes.id#_tagList',
	AjaxPush: '/?controller=tag&do=push',
    AjaxPushAllTags: true<cfif len(request.tagList)>,
	prefilled:[<cfoutput>#lcase(tmTagList(request.tagList))#</cfoutput>]</cfif>
 });
jQuery("###attributes.id#").typeahead({
      prefetch: '/?controller=tag&do=JSONList'
    }).on('typeahead:selected', function (e, d) {

      tagAPI.tagsManager("pushTag", d.value);

    });
</script>
</cfsavecontent>
<cfset arrayAppend(request.JScript, jScriptInject)>
</cfoutput>
</cfcase> 
<cfdefaultcase></cfdefaultcase>	
</cfswitch>