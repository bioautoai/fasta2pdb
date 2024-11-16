#!/bin/bash
# HOWTO USE THIS SCRIPT
# Change the variable PROTEIN=.... to the name of your own protein, e.g., PROTEIN=sod; no space are allowed;
# Replace the variable FASTA="...." with the sequence of your own protein; e.g.,FASTA="ASDF"

# Generate the README.md file"
touch README.md
echo "HOWTO USE THIS SCRIPT" > README.md
echo "# Change the variable PROTEIN=demo to the name of your own protein, e.g., PROTEIN=This-is-a-demo; no space are allowed;" >> README.md
echo "# Replace the variable FASTA="...." with the sequence of your own protein; e.g., FASTA="ASDF" " >> README.md

# Genarate the needed (demo) files with which to run the scripts
touch sequence.fasta
echo ">This-is-a-demo" > sequence.fasta
echo "PLEASELVEME" >> sequence.fasta

echo "Get protein structure from sequence with API of Meta's esmfold.v1"

PROTEIN=$(head -n1 sequence.fasta | cut -c2-)
FASTA=$(tail -n1 sequence.fasta)
PROTEIN_LEN=${#FASTA}
LIMIT=400
STRUCTURE=$PROTEIN.esmFold_v1

if (($PROTEIN_LEN <= $LIMIT))
    then
       echo "Protein is $PROTEIN"
       echo "Protein length is $PROTEIN_LEN"
       SUB_FASTA=$FASTA 
	   echo "You will get the structure file $STRUCTURE.pdb of full length in $PWD"
    else
	   echo "Protein is $PROTEIN"
	   echo "Protein length is $PROTEIN_LEN"
       echo "Your protein is too long(<= 400 aa!)"
	   echo "You will get the structure file of THE FIRST 400 AMINO ACIDS"
	   SUB_FASTA=$(echo $FASTA | cut -c1-400)
	   echo "You will get the structure file $STRUCTURE.pdb of FIRST 400 AA in $PWD"
fi

curl -X POST --data $SUB_FASTA https://api.esmatlas.com/foldSequence/v1/pdb/ > $STRUCTURE.pdb
