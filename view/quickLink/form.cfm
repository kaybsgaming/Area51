<cfimport prefix="ud" taglib="/tags/com/underdog/site">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<ud:header>
<ud:breadcrumbs/>
<div class="container-fluid">
	<form action="/?controller=quicklink&do=set" method="post" role="form" class="sky-form">
		<input:hidden name="itemID" value="#val(request.o.getID())#"/>
		
		<input:text label="Title" name="title" placeholder="Title" value="#trim(request.o.getTitle())#" required="true">
		<input:text label="Link URL" name="url" placeholder="The URL of the page you want to link to" value="#trim(request.o.getURL())#" required="true">
		<input:checkbox label="Open in New Window" name="newWindow" value="1" checked="#val(request.o.getNewWindow())#">
		<input:checkbox label="Shared" name="active" value="1" checked="#(val(request.o.getID()) AND request.o.getPublic())#">

		<footer>
			<input:submit/>
			<input:cancel/>
			<input:deleteModal disabled="#not(val(request.o.getID()))#"/>
		</footer>
	</form>
</div>
<ud:footer/>