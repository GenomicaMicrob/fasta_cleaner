# fasta_cleaner

Script to rename the headers of a multifasta file or files and clean the sequences.
A consecutive number will be added to each sequence header (>header_1, >header_2, etc.).
You can also change the name on the header.

It will also delete empty fasta sequences and convert multi-line sequences to only one line.

New files will be created with the extension .fna and a backup of the original files will be preserved in a new subdirectory (`original_files/`).

It will automatically recognize files with the following extensions: fna, fasta, fa, fsa, fas

This script is similar to the [fasta_header_renamer](https://github.com/GenomicaMicrob/fasta_renamer) but better.

## Installation
Just download the script to any directory and make it executable: `chmod +x fasta_cleaner.sh`

## Usage
`$ fasta_cleaner.sh`

It will give you an options menu:
```
Please select an option:
   1  Process one file, the fasta header will be the same as the filename
   2  Process one file and change the original header name with another
   3  Process all 8 files in this directory, the fasta header will be the same as their filenames
   x  exit
```
With the first two options, you will need to type in the name of the file to be changed, and with option 3, it will process all fasta files in the present directory.

You can get help with `fasta_cleaner.sh -h`, get the version with `fasta_cleaner.sh -v`, and usage with `fasta_cleaner.sh -u`
