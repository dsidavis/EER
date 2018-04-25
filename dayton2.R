library(ReadPDF);library(XML)
invisible(lapply(list.files("../ReadPDF/R", pattern = "\\.R$", full = TRUE), base::source))

source("dayFuns.R")

f = "2014-02-03_Dayton_Power_&_Light.xml"
ans = getDocTables(f)







if(FALSE) {
doc = readPDFXML(f)
tbls = lapply(doc, getPage)

sapply(tbls, class)
nsapply(tbls, nrow)
sapply(tbls, ncol) # Problems.
tbls[-1] = lapply(tbls[-1], function(x) { names(x) = names(tbls[[1]]); x})
}


