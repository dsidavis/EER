myReadTable =
function(node, header = FALSE, elFun = RWordXML:::cellValue,
         rows = xmlChildren(node)[names(node) == "tr"])
{
    els = lapply(rows, function(x) lapply(xmlChildren(x)[names(x) == "tc"], elFun))
    numCols =  sapply(els, length)

    cols = lapply(1:max(numCols), function(i) lapply(els, `[[`, i))
    df = as.data.frame(do.call(cbind, cols))
    if(header) {
        names(df) = unlist(df[1,])
        df = df[-1,]
    }
#!!!!    df = as.data.frame(cols)
    df
}    


cell = function(x) {
    xpathSApply(x, ".//w:p", xmlValue, namespaces = "w")
}    
