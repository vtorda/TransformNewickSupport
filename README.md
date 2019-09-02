# TransformNewickSupport
An R script which transforms a newick treefile structure to be acceptable for the Notung program 

Notung (http://www.cs.cmu.edu/~durand/Notung/) is a tree reconcilation program. It also can rearrange some poorly supported 
region of a gene tree based on support values (bootstrap, SH-likelihood) and species tree.

RAxML create a newick file with where the support values are in the following format:
(Node1:Branchlength,Node2:Branchlength):Branchlength[SupportValue]
BUT Notung requires the following format:
(Node1:Branchlength,Node2:Branchlength)SupportValue:Branchlength

USAGE in BASH:

You need the following R packages:
stringr and readr

Run the script:
Rscript TransformNewickSupport.R \path\to\directory\of\trees pattern

The script has two argumentums:
1) A path to a directory where all the trees can be found
2) pattern: the pattern should be an R compatible regex which is TRUE only for those filenames you want to transform

Output:
1) It saves the new format with the source filename plus a ".notung" postfix.
2) It also gives a small report in the "bootstrap_transf_report.txt"

The script will give you a progressbar as well while it is running.
