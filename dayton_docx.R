# Convert the PDF to DOCX.
#   Use PDFPenPro for example.

# Then use RWordXML.

library(XML)
library(RWordXML)

doc = wordDoc("2014-02-03_Dayton_Power_&_Light.docx")
#nxdoc = doc[["word/document.xml"]]

nodes = getTableNodes(doc)

t1 = readTable(nodes[[1]])
t1 = readTable(nodes[[1]], elFun = cell)

t1 = myReadTable(nodes[[1]], elFun = cell)

t1 = myReadTable(nodes[[1]], elFun = cell, header = TRUE)


pages = mapply(function(n, h)
                    myReadTable(n, header = h, elFun = cell),
               nodes, c(TRUE, rep(FALSE, length(nodes)-1)), SIMPLIFY = FALSE)


table(sapply(pages, class))

sapply(pages, dim)


pages[-1] = lapply(pages[-1], function(x) {names(x) = names(pages[[1]]); x})
ans = do.call(rbind, pages)





