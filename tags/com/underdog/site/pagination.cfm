<!---Handle required values--->
<cfif structKeyExists(attributes, 'itemCount') IS false>
	<cfthrow detail="Required Custom Tag Attribute 'itemCount' not defined" >
</cfif>

<cfif structKeyExists(attributes, 'itemsPerPage') IS false>
	<cfthrow detail="Required Custom Tag Attribute 'itemsPerPage' not defined" >
</cfif>

<cfif structKeyExists(attributes, 'linkTemplate') IS false>
	<cfthrow detail="Required Custom Tag Attribute 'linkTemplate' not defined" >
</cfif>

<!---Get number of pages to paginate for--->
<cfset pageCount = Ceiling(attributes.itemCount / attributes.itemsPerPage) >
<!---Determine which pagination page is currently selected--->
<cfif structKeyExists(attributes, 'currentPage') IS false>
	<cfset currentPage = 1>
<cfelse>
	<cfset currentPage = attributes.currentPage >
</cfif>
<div class="paginationWrapper">
<ul class="pagination">
	<cfif structKeyExists(attributes, 'leftAndRight') AND attributes.leftAndRight IS true>
		<cfif currentPage IS 1>
			<li class="disabled navLeft relative" ><a href="#"><</a></li>
		<cfelse>
			<cfset href = Replace(attributes.linkTemplate, '{page}', currentPage - 1) >
			<cfoutput><li class="navLeft relative"><a href="#href#"><</a></li></cfoutput>
		</cfif>
	</cfif>
	
	<cfloop from="1" to="#pageCount#" index="i">
		<cfset href = Replace(attributes.linkTemplate, '{page}', i) >
		<cfoutput><li <cfif i IS currentPage>class="active"</cfif>><a href="#href#">#i#</a></li></cfoutput>
	</cfloop>
	
	<cfif structKeyExists(attributes, 'leftAndRight') AND attributes.leftAndRight IS true>
		<cfif currentPage IS pageCount>
			<li class="disabled navRight relative"><a href="#">></a></li>
		<cfelse>
			<cfset href = Replace(attributes.linkTemplate, '{page}', currentPage + 1) >
			<cfoutput><li class="navRight relative"><a href="#href#">></a></li></cfoutput>
		</cfif>
	</cfif>
</ul>
</div>

<!---End tag execution--->
<cfexit method="EXITTAG" />