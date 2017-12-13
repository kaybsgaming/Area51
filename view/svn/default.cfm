<cfimport prefix="ud" taglib="/tags/com/underdog/site">
<ud:header>
<ud:breadcrumbs/>

<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="jumbotron">
				<h2>
					SVN Processor
				</h2>
				<p>
					This form takes a SVN change file and spits out a CSV.Once processed, select the text and save as a CSV file (MVP). Future iterations may allow for direct download.
				</p>
			</div>
			<div class="row">
				<div class="col-md-12">
					<form role="form" action="/?controller=svn&do=process" method="post" enctype="multipart/form-data">
						<div class="form-group">
							<label for="inputFile">
								File input
							</label>
							<input type="file" id="inputFile" name="sourceFile" />
							<p class="help-block">
								The SVN change file you want to process
							</p>
						</div>
						<button type="submit" class="btn btn-default">
							Process
						</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<ud:footer>