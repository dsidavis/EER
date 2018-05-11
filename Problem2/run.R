library(ReadPDF);library(XML)
invisible(lapply(list.files("../../ReadPDF/R", pattern = "\\.R$", full = TRUE), base::source))


doc = readPDFXML("Electric_A2A _DPL_08-19-13.xml")
page = doc[[2]]
#rr = getNodeSet(page, ".//rect")


hor = getLines(page)
plot(page)
abline(h = dim(page)[2] - hor$y0, col = "red")

vert = getLines(page, horiz = FALSE)
abline(v = unique(vert$x0), col = "red")
