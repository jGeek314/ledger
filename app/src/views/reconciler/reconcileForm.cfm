<cfoutput>
	#includeStylesheet('reconcile.css')#


	<h4 class="mb-4"><i class="fas fa-fw fa-clipboard-check"></i> Reconcile Account with External Transaction File</h4>

	<div class="card">
		<div class="card-header">
			Step 1: Upload File for Comparison
		</div>
		<div class="card-body">
			<input type="hidden" id="csvData">
			<cfoutput>
				#view('reconciler/_reconcileStep1', {
					csvDataInputId: 'csvData'
				})#
			</cfoutput>
		</div>
	</div>
	<br>
	<div class="card">
		<div class="card-header">
		Step 2: Search for checkbook transactions
		</div>
		<div class="card-body">
			<form id="searchTransactions" method="post" style="max-width:600px" class="mb-5">  
				<div class="row">
					<label class="col-3 col-form-label">Accounts:</label>
					<div class="col-9">
						#view('controls/userAccounts', {
							accountsInput: rc.viewModel.getAccounts(),
							linkedInput: rc.viewModel.getIncludeLinked()
						})#
					</div>
				</div>
				<div class="row">
					<label class="col-3 col-form-label">Date Range:</label>
					<div class="col-9">
						#view('controls/dateRange', {
							startDateInput: rc.viewModel.getStartDate(),
							endDateInput: rc.viewModel.getEndDate()
						})#
					</div>
				</div>
				<div class="row">
					<div class="col-9 offset-sm-3">
						<button class="btn btn-sm btn-primary">Search Transactions</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</cfoutput>
<br>

<div class="card">
	<div class="card-header">
	  Step 3: Reconcile!!!
	</div>
	<div class="card-body">
		<button id="btnReconcile" type="button" class="btn btn-primary">Process</button>
	</div>
</div>

<script>
	viewScripts.add(function(){
		
		$("#btnReconcile").click(function(){
			var formData = {
				accounts: '1'
			}; //$form.serialize();
			$.ajax({
				url: routerUtil.buildUrl('reconciler.reconcile'),
				data: formData
			}).done(function(results){
				console.log(results);
			});
		});

		$("#searchTransactions").submit(function(e){
			e.preventDefault();
			$.ajax({
				url: routerUtil.buildUrl('transactionSearch.getSearchResultsData'),
				type: "POST",
				dataType: "json",
				data: $("#searchTransactions").serialize()
			})
			.done(function(response){
				console.log(response);
			});
		});
		
	});
</script>