getPage =
function(page, pageNum = as.integer(xmlGetAttr(page, "number")))
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
    cols = lapply(1:max(numCols), function(i) lapply(lapply(cells, `[[`, i), xmlValue))
    df = as.data.frame(do.call(cbind, cols))

    if(pageNum == 1) {
        names(df) = sapply(cells[[1]], function(x) sapply(x, xmlValue))    
        df = df[-1,]
    }

    df
}


getDocTables =
function(file, doc = readPDFXML(file))
{
    tbls = lapply(doc, getPage)
    tbls[-1] = lapply(tbls[-1], function(x) { names(x) = names(tbls[[1]]); x})
    do.call(rbind, tbls)
}
