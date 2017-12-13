<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnNumber&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="numberModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Number</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" placeHolder="Column Name" required="true"/>
	<input:text name="placeHolder" label="Placeholder" placeHolder="Placeholder Text"/>
	<input:text type="number" name="default" label="Default Value" placeHolder="Default Value"/>
	<input:text type="number" name="min" label="Minimum Value" placeHolder="Minimum Value"/>
	<input:text type="number" name="max" label="Maximum Value" placeHolder="Maximum Value"/>
	<input:text type="number" name="decimals" label="Number of decimal places" placeHolder="None"/>
	<input:checkbox name="showAsPercentage" label="Show as percentage" value="1"/>
	<input:checkbox name="required" label="Required" value="1"/>
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