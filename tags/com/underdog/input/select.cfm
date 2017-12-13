<cfparam name="attributes.displayMode" default="select" >
<cfparam name="attributes.allowEdit" default="true" type="boolean" >
<cfif thistag.executionMode is "start">


<section>
	<label class="label"><cfoutput>#attributes.label#</cfoutput><cfif structKeyExists(attributes,"helper") AND len(attributes.helper)> - <small><cfoutput>#attributes.helper#</cfoutput></small></cfif>
<cfswitch expression="#attributes.displayMode#">
	<cfcase value="radio">
	<!---RADIO BUTTONS --->
		<cfif structKeyExists(attributes,"array")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<!---<cfif structKeyExists(attributes, "blankValue") AND !(arrayFind(attributes.array, attributes.blankValue))>
					<cfoutput>
	  					<label class="radio"><input type="radio" name="#attributes.name#" value="#attributes.blankValue# " <cfif not(structKeyExists(attributes,"selected"))>checked</cfif>><i class="rounded-x"></i>#attributes.blankValue#</label>	
					</cfoutput>
				</cfif>--->
				<cfloop array="#attributes.array#" index="o">
					<label class="radio"><input type="radio" name="#attributes.name#" value="#trim(o)#" <cfif structKeyExists(attributes,"required") && attributes.required>required</cfif> <cfif structKeyExists(attributes,"selected") AND not(compareNoCase(attributes.selected,trim(o)))>checked</cfif>><i class="rounded-x"></i>#trim(o)#</label>
				</cfloop>
			</cfoutput>
		</cfif>
		<cfif structKeyExists(attributes,"ORMArray")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfloop array="#attributes.ORMArray#" index="o" >
					<div class="radio">
						<label>
	 						<input class="radio" type="radio" name="#attributes.name#" value="#invoke(o,"get"&attributes.id)#" <cfif structKeyExists(attributes,"required") && attributes.required>required</cfif> <cfif structKeyExists(attributes,"selected") AND not(compareNoCase(attributes.selected,invoke(o,"get"&attributes.id)))>checked</cfif>><i class="rounded-x"></i>#invoke(o,"get"&attributes.value)#
	 					</label>
					</div>	
				</cfloop>
			</cfoutput>
		</cfif>

		
	</cfcase>
	<cfcase value="checkbox">

		<cfif structKeyExists(attributes,"array")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<div class="row">
				<cfloop array="#attributes.array#" index="o">
					<!--- Some values have line breaks in them. this is bad, so we remove them --->
					<cfset v = replaceNoCase(o,chr(10),"","ALL")>
					<cfset v = replaceNoCase(o,chr(13),"","ALL")>
					<label class="checkbox">
						 <cfoutput><label class="checkbox"><input type="checkbox" name="#attributes.name#" value="#v#" <cfif structKeyExists(attributes, "selected") AND listFindNoCase(attributes.selected,v)>checked</cfif> /><i></i> #o#</label></cfoutput>
					</label>	
			</cfloop>
			</div>
			</cfoutput>
		</cfif>
		<cfif structKeyExists(attributes,"ORMArray")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfloop array="#attributes.ORMArray#" index="o" >
					<div class="checkbox">
	 					<cfoutput><label><input type="checkbox" name="#attributes.name#" value="#invoke(o,"get#attributes.id#")#" <cfif structKeyExists(attributes, "checked") AND listFindNoCase(attributes.checked,invoke(o,"get#attributes.id#"))>checked</cfif> /> #invoke(o, "get#attributes.value#")#</label></cfoutput>
					</div>	
				</cfloop>
			</cfoutput>
		</cfif>
		

	</cfcase>

	
	
	<cfdefaultcase>
	<!---SELECT BOX --->
		<select <cfif not(compareNoCase(attributes.displayMode,"multiselect"))>multiple</cfif> <cfif structKeyExists(attributes,"disabled") AND attributes.disabled> disabled</cfif> class="form-control" name="<cfoutput>#attributes.name#</cfoutput>">
		<cfif structKeyExists(attributes, "blankValue")><cfoutput><option value="" <cfif not(structKeyExists(attributes,"selected"))>selected</cfif>>#attributes.blankValue#</option></cfoutput></cfif>
		<cfif structKeyExists(attributes,"query")>
			<cfoutput query="attributes.query">
				<option value="#attributes.query[attributes.id][currentRow]#" <cfif structKeyExists(attributes,"selected") AND not(compareNoCase(attributes.selected, attributes.query[attributes.id][currentRow]))> selected</cfif>>#attributes.query[attributes.value][currentRow]#</option>
			</cfoutput>
		</cfif>
		<cfif structKeyExists(attributes,"ORMArray")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfloop array="#attributes.ORMArray#" index="o" >
					<option value="#invoke(o,"get"&attributes.id)#" <cfif structKeyExists(attributes,"selected") AND listfindNoCase(attributes.selected,invoke(o,"get#attributes.id#"))> selected</cfif>>#invoke(o, "get#attributes.value#")#</option>
				</cfloop>
			</cfoutput>
		</cfif>
		<cfif structKeyExists(attributes,"array")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfloop array="#attributes.array#" index="o" >
					<option value="#trim(o)#" <cfif structKeyExists(attributes,"selected") AND listFindNoCase(attributes.selected, trim(o))> selected</cfif>>#o#</option>
				</cfloop>
			</cfoutput>
		</cfif>
	</select>
	</cfdefaultcase>
</cfswitch>
</label>
</section>

	
	

</cfif>