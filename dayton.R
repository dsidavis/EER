library(ReadPDF);library(XML)
invisible(lapply(list.files("../ReadPDF/R", pattern = "\\.R$", full = TRUE), base::source))

f = "2014-02-03_Dayton_Power_&_Light.xml"
doc = readPDFXML(f)
p = doc[[1]]

# Find the horizontal lines, but only the ones that are not black.
rr = getNodeSet(p, ".//line[not(@stroke.color = '0,0,0')]")
bb = getBBox(rr)

h = bb[ bb[, "y0"] == bb[, "y1"], ]
v = bb[ bb[, "x0"] == bb[, "x1"], ]

plot(p)
pageHeight = dim(p)[2]
abline(h = pageHeight - unique(h[, "y0"]), col = "red")
abline(v = unique(v[, "x0"]), col = "red")

txtNodes = getNodeSet(p, ".//text")
bb2 = getBBox2(txtNodes, asDataFrame = TRUE)[, 1:4]

rows = split(txtNodes, cut(bb2[, "top"], c(0, unique(h[, "y0"]))))

# For page 1, we discard the first row. This is all of the text above the
# first grey line of the table.

rows = rows[-1]

# Now we split each of the rows based on the vertical lines

cells = lapply(rows, function(x) {
                 bb = getBBox2(x)
                 split(x, cut(bb[, "left"], c(unique(v[, "x0"], Inf))))
               })

numCols = sapply(cells, length)
cols = lapply(1:max(numCols), function(i) sapply(lapply(cells, `[[`, i), xmlValue))
df = as.data.frame(do.call(cbind, cols))
names(df) = sapply(cells[[1]], function(x) sapply(x, xmlValue))
df = df[-1,]

# Look at the columns
df[[1]]

df[[2]]

df[[3]]

df[[4]]


# To get the company name
sapply(df[[1]], `[`, 1)


# For the subsequent pages






######################################################################################################

# Find the horizontal lines that span the margins.
mar = margins(p)

h1 = h[  abs(h[, "x0"] - mar[1]) < 8 & abs(h[, "x1"] - mar[2]) < 8, ]

# Unfortunately, no line spans the width of the text. This is because ther are
# a bunch of smaller line segments that connect to make a longer line.
# We'll assemble these.



h2 = by(h, h[, "y0"], assembleLine)





