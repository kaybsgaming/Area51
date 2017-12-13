<cfif thisTag.executionMode is "start">
<cfimport prefix="input" taglib="/tags/com/underdog/input">
<!-- Modal -->
<form action="/?controller=columnCurrency&do=set" method="post" role="form" class="sky-form">
<div class="modal fade" id="currencyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Currency</h4>
      </div>
      <div class="modal-body">
	<input:hidden name="listID" value="#request.o.getID()#"/>
	<input:text name="title" label="Title" placeHolder="Column Name" required="true"/>
	<input:text type="number" name="default" label="Default Value" placeHolder="Default Value"/>
	<input:text type="number" name="min" label="Minimum Value" placeHolder="Minimum Value"/>
	<input:text type="number" name="max" label="Maximum Value" placeHolder="Maximum Value"/>
	<input:checkbox name="showDecimals" label="Show decimal values" value="1"/>
	<input:text name="locale" label="Currency Locale" placeholder="eg: English (New Zealand)" value=""/>
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