<cfparam name="attributes.displayMode" default="select" >
<cfparam name="attributes.allowEdit" default="true" type="boolean" >
<cfif thistag.executionMode is "start">


<section>
	<label class="label"><cfoutput>#attributes.label#</cfoutput><cfif structKeyExists(attributes,"helper") AND len(attributes.helper)> - <small><cfoutput>#attributes.helper#</cfoutput></small></cfif></label>
<cfswitch expression="#attributes.displayMode#">
	<cfcase value="radio">
	<!---RADIO BUTTONS --->
		<cfif structKeyExists(attributes,"array")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfif structKeyExists(attributes, "blankValue")>
					<cfoutput>
	  						<label class="radio">
	  							<input class="radio" type="radio" name="#attributes.name#" value=""<cfif not(structKeyExists(attributes,"selected"))>checked</cfif>><i class="rounded-x"></i>#attributes.blankValue# 
							</label>
					</cfoutput>
				</cfif>
				<cfloop array="#attributes.array#" index="o" >

	  					<label class="radio">
	  						<input class="radio" type="radio" name="#attributes.name#" value="#o#" <cfif structKeyExists(attributes,"selected") AND not(compareNoCase(attributes.selected,o))>checked</cfif>><i class="rounded-x"></i>#o# 
						</label>
				</cfloop>
			</cfoutput>
		</cfif>
		<cfif structKeyExists(attributes,"ORMArray")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfloop array="#attributes.ORMArray#" index="o" >
					<div class="radio">
						<label>
	 						<input class="radio" type="radio" name="#attributes.name#" value="#invoke(o,"get"&attributes.id)#" <cfif structKeyExists(attributes,"selected") AND not(compareNoCase(attributes.selected,invoke(o,"get"&attributes.id)))>checked</cfif>><i class="rounded-x"></i>#invoke(o,"get"&attributes.value)#
	 					</label>
					</div>	
				</cfloop>
			</cfoutput>
		</cfif>

		
	</cfcase>
	<cfcase value="checkbox">

<!---		<cfif structKeyExists(attributes,"array")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<div class="checkbox">
				<cfloop array="#attributes.array#" index="o" >
					<label class="checkbox">
						 <cfoutput><input type="checkbox" name="#attributes.name#" value="#o#" <cfif structKeyExists(attributes, "checked") AND not(compareNoCase(attributes.checked,o))>checked</cfif> /><i></i> #o#</cfoutput>
					</label>	
			</cfloop>
			</div>
			</cfoutput>
		</cfif>--->
		<cfif structKeyExists(attributes,"ORMArray")><!---assume we're parsing an array of objects --->
			<cfoutput>
				<cfloop array="#attributes.ORMArray#" index="o" >
						<!---<label class="checkbox"><input type="checkbox" name="checkbox" checked><i></i>Alexandra</label>--->
	 					<label class="checkbox"><cfoutput><input type="checkbox" name="#attributes.name#" value="#invoke(o,"get#attributes.id#")#" <cfif structKeyExists(attributes, "selected") AND arrayfind(attributes.selected,o)>checked</cfif>><i></i> #invoke(o, "get#attributes.value#")#</label></cfoutput>
				</cfloop>
			</cfoutput>
		</cfif>
		

	</cfcase>

	
	
	<cfdefaultcase>
	<!---SELECT BOX --->
		<select multiple <cfif not(compareNoCase(attributes.displayMode,"multiselect"))>multiple</cfif> <cfif structKeyExists(attributes,"disabled") AND attributes.disabled> disabled</cfif> class="form-control" name="<cfoutput>#attributes.name#</cfoutput>">
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
					<option value="#o#" <cfif structKeyExists(attributes,"selected") AND not(compareNoCase(attributes.selected, o))> selected</cfif>>#o#</option>
				</cfloop>
			</cfoutput>
		</cfif>
	</select>
	</cfdefaultcase>
</cfswitch>

</section>

	
	

</cfif>