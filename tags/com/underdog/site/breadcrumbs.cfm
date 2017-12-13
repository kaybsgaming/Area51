<cfif not(compareNoCase(thisTag.executionMode,"start"))>
<cfif structKeyExists(request,"breadcrumbs") && isArray(request.breadcrumbs) && arrayLen(request.breadcrumbs)>
<cfset iCounter = 1>
     <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left"><cfoutput><cfif structKeyExists(request,"icon")><i class="#request.icon#"></i> </cfif>#structKeyExists(request,"pageName") ? request.pageName: ""# <cfif structKeyExists(request,"pageHelper")><small> - #request.pageHelper#</small></cfif></cfoutput></h1>
            <ul class="pull-right breadcrumb">
			<cfoutput>
                <cfloop array="#request.breadcrumbs#" index="bc">
					<cfloop collection="#bc#" item="i">
						<cfif iCounter eq arrayLen(request.breadcrumbs)><li class="active">#i#</li><cfelse><li><cfif len(bc[i])><a href="#bc[i]#">#i#</a><cfelse><a>#i#</a></cfif></li></cfif>
					</cfloop>
					<cfset iCounter ++>
				</cfloop>
			</cfoutput>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
</cfif>
</cfif>

