assembleLine =
function(bb, threshold = 5)
{
    o = order(bb[, 1])
    bb = bb[o,]

    delta = bb[-nrow(bb), "x1"] - bb[-1, "x0"]
    if(any(w <- (delta < threshold))) {
        browser()
        g = cumsum(!w)
        by(bb
    }

    bb
}
