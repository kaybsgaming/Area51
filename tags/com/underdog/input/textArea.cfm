<cfparam name="attributes.value" type="string" default="">
<cfparam name="attributes.rows" type="numeric" default="4">
<cfparam name="attributes.displayMode" type="string" default="plain">
<cfparam name="attributes.helper" type="string" default="">
<cfparam name="attributes.name" type="string" default="noName">
<cfswitch expression="#thistag.executionMode#" >
<cfcase value="start">
	<cfset thisID = attributes.name & createUUID()>
</cfcase>
<cfdefaultcase>
<section>
	<cfoutput>
		<label class="label" for="#thisID#">#attributes.label#<cfif len(attributes.helper)><small> - #attributes.helper#</small></cfif></label>
		<label class="textarea">
<cfswitch expression="#attributes.displayMode#">
	<cfcase value="plain"><textarea <cfif structKeyExists(attributes, "rows") AND val(attributes.rows)>rows="#attributes.rows#"</cfif> <cfif structKeyExists(attributes,"placeholder")>placeholder="#attributes.placeholder#"</cfif> class="form-control" id="#thisID#" name="#attributes.name#">#thistag.generatedContent#</textarea></cfcase>
	<cfcase value="rich"><textarea class="ckeditor" name="#attributes.name#" rows="#val(attributes.rows)#">#thistag.generatedContent#</textarea> </cfcase>
	<cfcase value="code">
			<textarea <cfif structKeyExists(attributes, "rows") AND val(attributes.rows)>rows="#attributes.rows#"</cfif> <cfif structKeyExists(attributes,"placeholder")>placeholder="#attributes.placeholder#"</cfif> class="prettyprint" id="#thisID#" name="#attributes.name#">#thistag.generatedContent#</textarea>
				<script src="/assets/plugins/codemirror-5.1/lib/codemirror.js"></script>
				<script>
					var textArea = document.getElementById('#thisID#');
					var editor = CodeMirror.fromTextArea(textArea);
					editor.getDoc().setValue('#jsStringFormat(thistag.generatedContent)#');
					
				</script>
				</cfcase>
				
				
</cfswitch>
		</label>
	</cfoutput>
	</section>
	<cfset thistag.generatedContent="">
</cfdefaultcase> 
</cfswitch>


