debug.lineage <- function(..., forward = F) {
  # Collect the arguments passed to the function
  args <- list(...)

  # This function is useless unless the adj.graph exists
  if(!debug.env$has.graph) {
    stop("debug.init must be run first")
  }

  # Collect possible results the user could ask for
  pos.vars <- get.data.nodes()
  pos.vars <- as.list(unique(pos.vars$name))
  #names(pos.vars) <- pos.vars

  # Make sure all the results passed by the user are valid
  # this produces a list of logicals, where TRUES
  #correspond to valid inputs
  pos.args <- lapply(args, function(arg, pos.vars){
    if(arg %in% pos.vars) {
      T
    } else {
      warning(paste(arg, " is not a possible result"))
    }
  }, pos.vars = pos.vars)

  # Any non-valid inputs will be removed as the list is subset
  # by logicals, TRUE corresponding to valid inputs
  args <- args[unlist(pos.args)]

  # If they did not provide any results themselve, list them out for them
  if(length(args) == 0) {
    print("Possible results:")
    print(pos.vars)
  } else {
    ls <- lapply(args, grab.lineage, pos.vars = pos.vars, forward = forward)
    names(ls) <- args
    return(ls)
  }
}

grab.lineage <- function(result, pos.vars, forward) {
  # The data nodes have all the information on the variables
  data.nodes <- get.data.nodes()
  proc.nodes <- get.proc.nodes()

  # Get all the nodes from the requested variable, but since
  # it's going either forward or backward grab the end
  node.label <- NULL
  if(!forward) {
    node.label <- tail(n=1,data.nodes[data.nodes$name == result, ])$label
  } else {
    node.label <- head(n=1,data.nodes[data.nodes$name == result, ])$label
  }

  # The assignment statement is inclusive when going backward, but not
  # forward. Therefore, it should be grabbed from the lineage separately
  if(forward) {
    # This code finds assignemnt state by running backwards lineage
    # But having to run backwards AND forwards for one variable is no bueno
    # Possibly grabbing first procedure node from edges may be better,
    # more testing required for now
    # assignemnt <- get.spine(node.label, FALSE)
    # assign.state <- assignemnt[grep("p[[:digit:]]", assignemnt)][[1]]
    proc.data.edges <- get.proc.data()
    edges <- proc.data.edges[proc.data.edges$entity == node.label, ]
    assign.state <- NA
    if(nrow(edges) > 0){
      assign.state <- edges$activity[[1]]
    }
  }

  # Grab the nodes that have connections to the chosen node from the adj graph
  spine <- get.spine(node.label, forward)

  # If moving forward the procedure node that contains the assignment
  # statement should be placed at the front of the spine to keep the order accurate
  if(forward && !is.na(assign.state)) {
    spine <- append(spine, assign.state, 0)
  }

  # Pull the lines from the proc nodes that are referenced
  # in the spine, each is stored as a row
  lines <- lapply(spine[grep("p[[:digit:]]", spine)], function(proc.node){
    list(proc.nodes[proc.nodes$label == proc.node, ]$startLine,
         proc.nodes[proc.nodes$label == proc.node, ]$name)
  })

  # Since each line is stored as a row and the wanted result is a
  # data frame, the columns need to be extracted so they can
  # be covnerted to a data frame. Find how many columns there
  # are so mapply can index through the rows the correct amount of times
  col.length <- 1:length(lines[[1]])

  # Grab each column as a list from the rows
  # then extract the values so they're a vector
  # when those columns are returned as a list of vectors
  # create a data frame from it
  df <- data.frame(lapply(col.length, function(x) {
    col <- mapply(`[`, lines, x)
    return(mapply(`[`, col, 1))
  }), stringsAsFactors = F)

  # The colnames are automatically assigned to
  # not descriptive values, replace them with
  # descriptive values
  colnames(df) <- c("line", "code")

  # Order of the columns so the lines go
  # from descending to ascending, if going backward
  # This keeps the results from always following
  # the flow of control
  df[with(df, order(line)), ]
}