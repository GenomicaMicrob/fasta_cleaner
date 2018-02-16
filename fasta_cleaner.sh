#!/bin/bash
AUTHOR='Bruno Gomez-Gil, Lab. Genomica Microbiana, CIAD.'
LINK='https://github.com/GenomicaMicrob/fasta_cleaner'
NAME='fasta_cleaner'
VER='v0.0.1' # script for github
REV='Feb. 16, 2018'
DEP='none'
TODO='Not much'

display_help(){
echo -e "
____________________ $NAME $VER ____________________________________

Script to rename the headers of a multifasta file or files.
A consecutive number will be added to each sequence header (>header_1, 
>header_2, etc.). You can also change the name on the header.
It will also delete empty fasta sequences.
\e[91mIMPORTANT.\e[0m It will also convert multi-line sequences to only one line.

New files will be created with the extension .fna and the original files
will not be changed and copied to a new subdirectory (original_files/).

USAGE: $NAME

It will recognize files with the following extensions: fna, fasta, fa, fsa, fas
_______________________________________________________________________________
"
} # -h is typed, display_help
if [ "$1" == "-h" ]
then
	display_help
	exit 1
fi

display_version(){
echo "
____________________________________________________________________

Script name:    $NAME
Version:        $VER
Author:         $AUTHOR
Last revisited: $REV
Dependencies:   $DEP
More info at:   $LINK
Still to do:    $TODO
____________________________________________________________________

"
} # -v is typed, displays version
if [ "$1" == "-v" ]
then
	display_version
	exit 1
fi

display_usage(){
echo -e "
____________________ $NAME $VER __________________________

\e[1mUSAGE\e[0m: $NAME

The files have to have any of these extension: fna,fasta,fa,fsa,fas
and be in the current directory.
For more information type $NAME -h
____________________________________________________________________

"
} # -u display usage 
if [  "$1" == "-u" ] 
then 
	display_usage
	exit 1
fi

FASTA=$(ls -l *.{fna,fasta,fa,fsa,fas} 2>/dev/null | wc -l) # variable to count the number of fasta files in this directory, no files with any of these extension, sends no error message (2>/dev/null) to stdout

available_files(){
echo "Available files are:"
ls *.{fna,fasta,fa,fsa,fas} 2>/dev/null
echo
} # lists available files in the current directoy

echo -n -e "Please select an option:\n   1  Process one file, the fasta header will be the same as the filename\n   2  Process one file and change the original header name with another\n   3  Process all \e[1m$FASTA\e[0m files in this directory, the fasta header will be the same as their filenames\n   x  exit "
echo
read character
case $character in
    1 ) echo
		available_files
		read -e -p "Name of the fasta file: " FILE
		NORIG_SEQS=$(grep -c ">" $FILE | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts the number of sequences in the original file
		mkdir -p original_files
		BASENAME=$(echo $FILE | rev | cut -f 2- -d '.' | rev) # variable to extract the name of file without the extension.
		mv $FILE original_files
		awk '/^>/{print ">'$BASENAME'_"++i; next}{print}' original_files/$FILE > $BASENAME.fna # adds a _ and a consecutive number to the new sequence header.
		awk 'BEGIN {RS = ">" ; FS = "\n" ; ORS = ""} $2 {print ">"$0}' $BASENAME.fna > tmp && mv tmp $BASENAME.fna # Deletes empty fasta sequences
		awk '/^>/{print s? s"\n"$0:$0;s="";next}{s=s sprintf("%s",$0)}END{if(s)print s}' $BASENAME.fna  > tmp && mv tmp $BASENAME.fna # converts a multiline sequence to just one line
		SEQS=$(grep -c ">" $BASENAME.fna | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts number of sequences and displays them with thousand comma separators
		echo "File $FILE with $NORIG_SEQS sequences was processed and saved as $BASENAME.fna with $SEQS clean sequences."
		echo "The original file was saved in original_files/"
	;;
		
    2 ) echo
		available_files
		read -e -p "Name of the fasta file: " FILE
		NORIG_SEQS=$(grep -c ">" $FILE | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts the number of sequences in the original file
		read -p "Type a new header name: " SAMPLE
		mkdir -p original_files
		BASENAME=$(echo $FILE | rev | cut -f 2- -d '.' | rev) # variable to extract the name of file without the extension.
		mv $FILE original_files
		awk '/^>/{print ">'$SAMPLE'_"++i; next}{print}' original_files/$FILE > $BASENAME.fna #  adds a _ and a consecutive number to the new sequence header.
		awk 'BEGIN {RS = ">" ; FS = "\n" ; ORS = ""} $2 {print ">"$0}' $BASENAME.fna > tmp && mv tmp $BASENAME.fna # Deletes empty fasta sequences
		awk '/^>/{print s? s"\n"$0:$0;s="";next}{s=s sprintf("%s",$0)}END{if(s)print s}' $BASENAME.fna > tmp && mv tmp $BASENAME.fna # converts a multiline sequence to just one line
		SEQS=$(grep -c ">" $BASENAME.fna | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts number of sequences and displays them with thousand comma separators
		echo "File $FILE with $NORIG_SEQS sequences was processed and saved as $BASENAME.fna with $SEQS clean sequences."
		echo "The original file was saved in original_files/"
	;;
	
    3 ) echo
		mkdir -p original_files
		cp *.{fna,fasta,fa,fsa,fas} original_files/ 2>/dev/null || : # copy all fasta files for safekeeping
		# rename all .extension to .fasta without error warnings if files not present
		rename 's/.fna/.fasta/' *.fna 2>/dev/null || :
		rename 's/.fa/.fasta/' *.fa 2>/dev/null || :
		rename 's/.fas/.fasta/' *.fas 2>/dev/null || :
		rename 's/.fsa/.fasta/' *.fsa 2>/dev/null || :
		
		# RENAME HEADERS OF FASTA FILES
		for f in *.fasta
		do
			NORIG_SEQS=$(grep -c ">" $f | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts the number of sequences in the original file
			SAMPLE=$(basename $f .fasta) # obtains only the name of the file without the .fasta extension and saves it as the variable $SAMPLE
			awk '/^>/{print ">'$SAMPLE'_"++i; next}{print}' $f > $SAMPLE.fna
			awk 'BEGIN {RS = ">" ; FS = "\n" ; ORS = ""} $2 {print ">"$0}' $SAMPLE.fna > tmp && mv tmp $SAMPLE.fna # Deletes empty fasta sequences
			awk '/^>/{print s? s"\n"$0:$0;s="";next}{s=s sprintf("%s",$0)}END{if(s)print s}' $SAMPLE.fna > tmp && mv tmp $SAMPLE.fna # converts a multiline sequence to just one line
			SEQS=$(grep -c ">" $SAMPLE.fna | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L') # counts number of sequences and displays them with thousand comma separators
			rm -f *.fasta
			echo "File $f with $NORIG_SEQS sequences was processed and saved as $SAMPLE.fna with $SEQS clean sequences."
		done
		echo
		echo "The original files were saved in original_files/"
	;;
	
	* ) echo
		echo "Adios"
esac
echo
# This is the end.
