The initial challenge is to read the contents of the table(s) in the
PDF file 2014-02-03_Dayton_Power_&_Light.pdf.

We have 2 strategies for this.
1. convert the PDF to XML via pdftohtml 
1. convert the PDF to DOCX

For each of these 2 strategies, we will have to recover the relevant content.

# Using pdftohtml

The code is in dayFuns.R and dayton2.R
We can run this with
```
source("dayton2.R")
ans
```

The key is 
```
ans = getDocTables("2014-02-03_Dayton_Power_&_Light.xml")
```
We converted the PDF to XML using the (extended) version of pdftohtml.
(I think we need this to get the lines and rectangles, but I can't recall what changes we have made
to the original.)


The result in `ans` is a data.frame.
It has 4 columns.
```
dim(ans)
```

Each column is slightly unusual.
It is a list and each element is a cell in the table that spans the pages of the documents.
Each cell may have multiple lines.  This allows us to identify the lines of interest,
e.g., the company name being the first element of each cell in column 1.

So to get the company name we could use
```
unname(sapply(ans[[1]], `[`, 1))
```
(The unname() just discards the names of the elements that come from the mechanism 
we identify cells and these mean very little.)


So each cell may have multiple elements. We have to decide how we want to process these
in the resulting data frame.


The code that extracts the cells and collects the pages into a single table is
in dayFuns.R.   There are two functions: getDocTables() and getPage().
getPage() processes an individual page. This returns a data frame for the table
on that page.

getDocTables() is the highlevel  function that process an entire document
given a file name - the converted XML document.
It processes each page via getPage(). It also assembles the result into a single data frame.


```
library(ReadPDF)
source("dayFuns.R")
```

```
f = "2014-02-03_Dayton_Power_&_Light.xml"
ans = getDocTables(f)
```

To get the company name from the first column, we can use
```
apply(ans[[1]], `[[`, 1)
```
and, of course, we can assign it to a column of the
data frame as
```
ans$CompanyName = apply(ans[[1]], `[[`, 1)
```


# Convert to DOCX

The PDF has a nice, regular, structured table.
We can convert the PDF to a DOCX file using an application such
as PDFPenPro.
If you don't have this, then game over!

We can use the docxtractr to extract the contents of a table in a Word document.
Unfortunately, while convenient, it is not sufficiently flexible.

Instead, we will use the RWordXML package.

```
library(XML)
library(RWordXML)
```

```
doc = wordDoc("2014-02-03_Dayton_Power_&_Light.docx")
nodes = getTableNodes(doc)
```

```
source("docxFuns.R")
```

```
t1 = myReadTable(nodes[[1]], elFun = cell)
```


```
names(t1) = sapply(t1[1,], unlist)
t1 = t1[-1,]
```

As we pursue this, it becomes clearer that the 
PDF approach is somewhat more complex up-front, but then  simpler.
But we can follow this approach.

