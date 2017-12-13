<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnNVarchar&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="nVarcharModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Single Line of Text</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" placeHolder="Column Name" required="true"/>
	<input:text name="placeHolder" label="Placeholder" placeHolder="Placeholder Text"/>
	<input:text name="remoteColumn" placeholder="Mapping to remote JSON column" label="JSON Column">
	<input:text type="number" name="length" label="Length" placeHolder="Maximum length"/>
	<input:text name="default" label="Default" placeHolder="Default Value (if any))"/>
	<input:checkbox name="required" label="Required" value="1" placeHolder="Default Value (if any))"/>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Save column</button>
      </div>
    </div>
  </div>
</div>
</form>
</cfif>