d2 = readPDFXML("2017-12-29_Dayton_Power_&_Light.xml")

# By text matching
rt = xpathSApply(d2, "//text[starts-with(., 'Rate Type')]", xmlValue)
rt = gsub("Rate Type: ", "", rt)


# Get the lines on the second page
ll = getBBox(d2[[2]], color = TRUE, asDataFrame = TRUE)
h = ll[ ll$y0 == ll$y1, ]

plot(d2[[2]])
abline(h = dim(d2[[2]])[2] - ll$y0, col = "blue")

txt = getBBox2(d2[[2]], asDataFrame = TRUE)
blocks = split(txt, cut(txt$top, sort(unique(ll$y0))))
blocks = blocks[ sapply(blocks, nrow) > 0 ]

blocks[[1]]$text

# Price
price = sapply(blocks, function(x) x$text[6])
company = sapply(blocks, function(x) x$text[1])
rateType = sapply(blocks, function(x) x$text[3])
rateType = gsub("Rate Type: ", "", rateType)


# If by chance there weren't complete fields for each block
# e.g., we were missing the Monthly Fee we could group the nodes by line, then by column


# So split the nodes by the lines first.
txtNodes = getNodeSet(d2[[2]], ".//text")
txt.blocks = split(txtNodes, cut(txt$top, sort(unique(ll$y0))))
txt.blocks = txt.blocks[ sapply(txt.blocks, length) > 0 ]


# Now for each block of nodes assemble them by line
# Then  split by column.
# If there isn't enough information to find the 3 columns in a single block
# we can get this information across the page's blocks or even all of the pages.

tmp = getBBox2(txt.blocks[[1]], asDataFrame = TRUE)
splitBlock =
    function(nodes) {
        ll = nodesByLine(nodes)
         bb = getBBox2(nodes, asDataFrame = TRUE)
         cols = lapply(ll, function(x) split(x, cut(getBBox2(x)[,"left"], c(unique(bb$left) - 1, Inf))))
    }    
ans = lapply(txt.blocks, splitBlock)

sapply(ans, function(x) max(sapply(x,length)))
