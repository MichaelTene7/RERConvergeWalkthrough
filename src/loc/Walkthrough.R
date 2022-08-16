toytreefile = "subsetMammalGeneTrees.txt"
toyTrees=readTrees(paste(rerpath,"/extdata/",toytreefile,sep=""), max.read = 200)


data("logAdultWeightcm")
mamRERw = getAllResiduals(toyTrees,useSpecies=names(logAdultWeightcm),
                          transform = "sqrt", weighted = T, scale = T)
saveRDS(mamRERw, file="results/mamRERw.rds")
newmamRERW = readRDS("results/mamRERw.rds")

#make average and gene tree plots
#make string vector for names of the outgroup
noneutherians <- c("Platypus","Wallaby","Tasmanian_devil","Opossum")
#I don't know what this does, graphical parameter
par(mfrow=c(1,2))
#Plot a tree using the master tree, which means considering all variance; hl species and color determine highlights
avgtree=plotTreeHighlightBranches(toyTrees$masterTree, outgroup=noneutherians,
                                  hlspecies=c("Vole","Squirrel"), hlcols=c("blue","red"),
                                  main="Average tree") #plot average tree
#same as above, but using $trees$BEND3, which means that it is only looking at the variance in bend 3 
bend3tree=plotTreeHighlightBranches(toyTrees$trees$BEND3, outgroup=noneutherians,
                                    hlspecies=c("Vole","Squirrel"), hlcols=c("blue","red"),
                                    main="BEND3 tree") #plot individual gene trees

#plot RERs
par(mfrow=c(1,1))

phenvExample <- foreground2Paths(c("Vole","Squirrel"),toyTrees,clade="terminal")
plotRers(mamRERw,"BEND3",phenv=phenvExample) #plot RERs
?foreground2Paths()
?plotRers()

par(mfrow=c(1,1))
#generate a tree; using the data from toytrees, residuals drawn from mamRERw, with the residuals for the gene BEND3, and make a plot of it. You foreground group is phenvExample. 
bend3rers = returnRersAsTree(toyTrees, mamRERw, "BEND3", plot = TRUE,
                             phenv=phenvExample) #plot RERs
?returnRersAsTree()

#return formatted as paragraphs:
strwrap(
  #substitute ":" for ": " on the output of write.tree(bend3rers). this space probably helps with the paragraph formatting. 
  gsub(":",write.tree(bend3rers),replacement=": "))
write.tree(bend3rers, file='results/BEND3RER.nwk')
testTree = read.tree('results/BEND3RER.nwk')
plotTreeHighlightBranches(testTree,
                          hlspecies=c("Vole","Squirrel"), hlcols=c("blue","red"),
                          main="Average tree")


#produce a tree with branch length of RER for that gene for every gene; if you set a given foreground vs background group, these trees could then be analyzed to see if there are ones which have obvious RER differences between the foreground and the background 
#You'd probably want to make a series of plots of the RER ( plotRers() function) for each of these trees? No, the plot RER function wants an input of the gene name. How would you make a better visual demonstration of the RERs of multiple genes?
#you could make a a bunch of the plotRers graphs using a loop 
multirers = returnRersAsTreesAll(toyTrees,mamRERw)
write.tree(multirers, file='results/toyRERs.nwk', tree.names=TRUE)

#visualize RERs along branches as a heatmap; uses toytrees as a master tree; mamRERw for corrected data; the gene is bend3, the type is "c" aka "color" for a heatmap, nlevels is the number of colors. 

newbend3rers = treePlotRers(treesObj=toyTrees, rermat=mamRERw, index="BEND3",
                            type="c", nlevels=9, figwid=10)
#other arguments can be passed in, which are arugments for treePlotNew

