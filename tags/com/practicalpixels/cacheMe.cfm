<cfprocessingdirective suppresswhitespace="Yes">
<cfsilent>
<!--- 
Author: Marty Pine, ZeroOne (NZ) Limited
15 Sept 2004

This tag was inspired by the cacheThis customTag by Robin Hillard, and the cfcache tag native to Macromedia Coldfusion

Usage:

Caching:  <cf_cacheMe name="" timeout="">

content to cache here

</cf_cacheMe>


Flushing:  <cf_cacheMe flush>

content to cache here

</cf_cacheMe>


Refreshing:  <cf_cacheMe refresh>

content to cache here

</cf_cacheMe>

Notes
 - If the timeout attribute is not set, then the content will be cached until the entire cache is flushed or the relevant entry is refreshed
 - The name attribute defaults to a hash of the templateName and queryString (if any), meaning that whole unique URLs can be cached with ease. 
 - The name can also be defined for custom caching, or caching of certain stanzas of code.
 - Because this tag can cache elements within a page, client caching was not implemented for this tag.
 - Cache will refresh if the calling template has cached since the last cache was stored.
 --->
</cfsilent>
<cfswitch expression="#thisTag.executionMode#">

<cfcase value="START">
	<cfsilent>
		<cfparam name="attributes.flush" default="false">
		<cfparam name="attributes.refresh" default="false">
		<cfparam name="attributes.name" default="#cgi.script_name#">
		<cfscript>
			// If we are flushing the cache, or if the caching structure is not set up in the application scope, then create it
			if (attributes.flush or not(structKeyExists(application, "cacheMe")))
				application.cacheMe = structNew();
				
			// sets up the path to the cfml template that we are hitting
			cfmlTemplatePath = getBaseTemplatePath();
			
			if (len(cgi.query_string) gt 0)// if we have a query string
				attributes.name = attributes.name & "?" & cgi.query_string;// then add it to the name attribute.

			attributes.name = hash(attributes.name);// create a hash out of the templateName and queryString so that we can cache each URL variant of the same template
		</cfscript>
		<!--- if there is a time out specified and it has passed, then time it out. --->
		<cfif structKeyExists(attributes, "timespan")><!--- Check for the timespan attribute (without this, the cache will remain until flushed, refreshed, or the application scope times out) --->
			<cfif isNumeric(attributes.timespan)><!--- make sure it is valid --->
				<cfif structKeyExists(application.cacheMe, attributes.name)><!--- if we have a cached version of this content --->
					<!--- Checks to see if the template has been modified since we cached last --->
					<!--- <cfdirectory action="LIST" directory="#getDirectoryFromPath(cfmlTemplatePath)#" filter="#getFileFromPath(cfmlTemplatePath)#" name="cfmlTemplate"> --->
					<cfscript>
						/* templateLastUpdate = lsParseDateTime(cfmlTemplate.dateLastModified);// set the date up to be compared to now() for timing the cache out
						
						if (application.cacheMe[attributes.name]["asAt"] lt templateLastUpdate)// if the template has been modified since we cached
							attributes.refresh = true;// then set it up for refreshing ---> */
								
						if (application.cacheMe[attributes.name]["asAt"] lt now() - attributes.timespan)// and if it is timed out
							attributes.refresh = true;// then set it up for refreshing
					</cfscript>
				</cfif>
			<cfelse>
				<cfthrow message="Invalid timespan value '#attributes.timespan#'. Consider using the createTimeSpan() function.">
			</cfif>
		</cfif>
	</cfsilent>
	<!--- If we have the page we're looking for and it is within the cache timeout --->
	<cflock name="ad_cacheMe" timeout="1" type="READONLY">
	<cfif not(attributes.refresh) AND structKeyExists(application.cacheMe, attributes.name)>
		<cfoutput>#application.cacheMe[attributes.name]["content"]#</cfoutput><!--- Use the previously saved version of the tag's body. --->
		<cfexit><!--- Skip until after </cacheMe> --->
	</cfif>
	</cflock>
</cfcase>

<cfdefaultCase><cfsilent>
	<cflock name="ad_cacheMe" timeout="1" type="EXCLUSIVE">
		<cfscript>
			// Double check to ensure that the cache structure is present in the Application scope
			if (attributes.flush or not(structKeyExists(application, "cacheMe")))
				application.cacheMe = structNew();
			if(attributes.refresh) {
				// only set the content into the application scope if we are being told to refresh	
				application.cacheMe[attributes.name]["content"] = thisTag.generatedContent;// Save the tag's body into the application scope
				application.cacheMe[attributes.name]["asAt"] = now();// Tag it with a time, so we can compare for timeouts going forward
			}
		</cfscript>
	</cflock>
</cfsilent></cfdefaultcase>
</cfswitch>
</cfprocessingdirective>