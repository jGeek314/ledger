<cfoutput>
    <ul class="nav nav-tabs">
        <li class="nav-item">
            <a class="nav-link #matchDisplay(getItem(),'newTransaction','active disabled')#" href="#buildurl('transaction.newTransaction?accountid=#rc.account.getid()#')#">Add Entry</a>
        </li>
        <li class="nav-item">
            <a class="nav-link #matchDisplay(getItem(),'verify','active')#" href="#buildurl('transaction.verify?accountid=#rc.account.getid()#')#">Verify Entries</a>
        </li>
        <li class="nav-item">
        <span class="nav-link  #matchDisplay(getItem(),'edit','active','disabled')#">Edit Entry</span>
        </li>
    </ul> 
</cfoutput>


 