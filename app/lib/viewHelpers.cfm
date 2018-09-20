<cfscript>

    matchUtilValid = function(args){
        if(StructKeyExists(args,'val1') and StructKeyExists(args,'val2')){
            return true;
        }
        return false;
    }

    matchUtil = function(val1,val2,method,output){
        switch(method){
            case "eq" :
                if(val1 eq val2){
                    return output;
                }
                break;
            case "neq" :
                if(val1 neq val2){
                    return output;
                }
                break;
        }
        return '';
    }

    matchSelect = function(val1,val2){
        if(matchUtilValid(arguments)){
            return matchUtil(val1,val2,"eq","selected");
        }
    }

    matchCheck = function(val1,val2){
      if(matchUtilValid(arguments)){
            return matchUtil(val1,val2,"eq","checked");
        }
    }

    matchHide = function(val1,val2,output){
        return matchUtil(val1,val2,"neq",output);
    }

    moneyFormat = function(number){
        return numberformat(arguments.number, "$0.00");
    }
</cfscript>
