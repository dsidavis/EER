cellContents =
function(nodes, col = NA)
{        
  lapply(nodes, xmlValue)    
}

getPage =
    #
    # Process a page into a data frame.
    #  If pageNum = 1, we get the names of the columns, discard the text above the table.
    #  Otherwise, we currently assume the text of the page is all of the table.
    #
    # The strategy is to find the non-black lines on the page. These are the horizontal and vertical
    # lines in the table - not those underlining the text in the regular part of the page.
    # We are only interested in the horizontal and vertical lines.
    #
    # We divide the text nodes first into rows, and then into columns. We identfy the rows and columns
    # via the vertical lines  we extracted/identified earlier, i.e. the gray horizontal and vertical lines.
    #
    #
    #
function(page, cellFun = cellContents,  pageNum = as.integer(xmlGetAttr(page, "number")))
{    
    rr = getNodeSet(page, ".//line[not(@stroke.color = '0,0,0')]")
    bb = getBBox(rr)

    h = bb[ bb[, "y0"] == bb[, "y1"], ]
    v = bb[ bb[, "x0"] == bb[, "x1"], ]


    txtNodes = getNodeSet(page, ".//text")
    bb2 = getBBox2(txtNodes, asDataFrame = TRUE)[, 1:4]
    rows = split(txtNodes, cut(bb2[, "top"], c(0, unique(h[, "y0"]))))

    if(pageNum == 1)
        rows = rows[-1]

    cells = lapply(rows, function(x) {
                 bb = getBBox2(x)
                 split(x, cut(bb[, "left"], c(unique(v[, "x0"], Inf))))
    })


    numCols = sapply(cells, length)
      # allow the caller specify a flexible function to process each cell
    cols = lapply(1:max(numCols), function(i) cellFun(lapply(cells, `[[`, i), i))
    df = as.data.frame(do.call(cbind, cols))

    if(pageNum == 1) {
        names(df) = sapply(cells[[1]], function(x) sapply(x, xmlValue))    
        df = df[-1,]
    }

    df
}


getDocTables =
function(file, cellFun = cellContents, doc = readPDFXML(file))
{
    tbls = lapply(doc, getPage, cellFun = cellFun)
    tbls[-1] = lapply(tbls[-1], function(x) { names(x) = names(tbls[[1]]); x})
    do.call(rbind, tbls)
}
