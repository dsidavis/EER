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
    # Find the non-black lines.  The black lines are for underlining text
    #  The non-black lines are for the table row and column separators.
    rr = getNodeSet(page, ".//line[not(@stroke.color = '0,0,0')]")
    bb = getBBox(rr)

    # Get the horizontal and vertical lines
    h = bb[ bb[, "y0"] == bb[, "y1"], ]
    v = bb[ bb[, "x0"] == bb[, "x1"], ]


    # Get all of the text on the page and their locations
    txtNodes = getNodeSet(page, ".//text")
    bb2 = getBBox2(txtNodes, asDataFrame = TRUE)[, 1:4]

    # Organize the text by row.
    rows = split(txtNodes, cut(bb2[, "top"], c(0, unique(h[, "y0"]))))

    # For page 1, we discard the descriptive text above the first grey line.
    if(pageNum == 1)
       rows = rows[-1]

    # Group the text in each row by column, using the vertical line positions to identify
    # the start and end of each column.
    cells = lapply(rows, function(x) {
                 bb = getBBox2(x)
                 split(x, cut(bb[, "left"], c(unique(v[, "x0"], Inf))))
    })



    # For each row, process each cell which is a group of nodes.
    numCols = sapply(cells, length)
      # allow the caller specify a flexible function to process each cell
    cols = lapply(1:max(numCols), function(i) cellFun(lapply(cells, `[[`, i), i))
    df = as.data.frame(do.call(cbind, cols))

    if(pageNum == 1) {
        # Put the column names on the columns from the first row and discard that row.
        names(df) = sapply(cells[[1]], function(x) sapply(x, xmlValue))    
        df = df[-1,]
    }

    df
}


getDocTables =
    #
    # Given an XML file name, process each page assuming it contains
    # a table.
    #
function(file, cellFun = cellContents, doc = readPDFXML(file))
{
    tbls = lapply(doc, getPage, cellFun = cellFun)
    # use the column names from table 1 for all of the subsequent tables
    # since they don't have explicit column names on the subsequent pages.
    tbls[-1] = lapply(tbls[-1], function(x) { names(x) = names(tbls[[1]]); x})
    # Combine the tables into 1 single table.
    do.call(rbind, tbls)
}
