library(ReadPDF);library(XML)
invisible(lapply(list.files("../ReadPDF/R", pattern = "\\.R$", full = TRUE), base::source))

source("dayFuns.R")

f = "2014-02-03_Dayton_Power_&_Light.xml"
doc = readPDFXML(f)
tbls = lapply(doc, getPage)

sapply(tbls, class)
sapply(tbls, nrow)

sapply(tbls, ncol) # Problems.
