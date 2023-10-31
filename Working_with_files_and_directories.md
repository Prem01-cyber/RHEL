# Working with files and directories
## Knowing our current working directory
`pwd`         -> print working directory

`echo $PWD`   -> print working directory

## Lisitng files and directories
`ls`          -> list files

`ls -l`       -> list files in long format

`ls -a `      -> list all files including hidden files

`ls -la`      -> list all files in long format including hidden files

`ls -lh`      -> list all files in long format with human readable file sizes

`ls -lS`      -> list all files in long format sorted by file size

`ls -ltr`     -> list all files in long format sorted by time in reverse order

## Creating Files 
`touch`               -> create empty file. It also replaces the timestamp of the file if the file already exists.

`touch -t`            -> change timestamp of the file to a specific date. For example, `touch -t 202001010000 file`

`touch -d`            -> change timestamp of the file to a specific date. For example, `touch -d "2020-01-01 00:00:00" file`

`touch {1..2}.txt`    -> create multiple files. For example, `touch {1..3}.txt` creates 3 files named 1.txt, 2.txt and 3.txt.

`cat`         -> display file contents

`cat > file`  -> create file and write to it

`cat >> file` -> append to file

## Knowing file type and locations
`file`        -> determine file type. For example, `file /bin/bash`

`type`        -> determine command type. For example, `type ls`

`which`       -> determine command location. For example, `which ls`

- The system doesn't recognise the file type based on the extension. It recognises the file type based on the file contents.
- There are many file types. For example, text file, binary file, etc.

## Moving through directories
`cd`         -> change directory

`cd -`       -> change to previous directory

## CRUD operations on directories and files
`mkdir`      -> make directory

`mkdir -p`   -> make parent directories as needed

`rmdir`      -> remove directory, fails if not empty. The directory must be empty.

`rmdir -p`   -> remove parent directories as needed

`rm -rf`     -> remove directory and files recursively and forcefully eventhough if they are not empty.

`mv`        -> move or rename file or directory

`mv -i`     -> move or rename file or directory and prompt before overwriting

`cp`        -> copy file or directory

`cp -i`     -> copy file or directory and prompt before overwriting

`cp -r`     -> copy directory recursively

`cp -a`     -> copy directory recursively and preserve all attributes

`cp -p`     -> copy directory recursively and preserve all attributes and permissions

`cp -u`     -> copy directory recursively and preserve all attributes and permissions and only copy if the source is newer than the destination

## Creating alias to commands for easier usage
`alias`    -> create alias for a command. For example, `alias ll='ls -l'`

- to make the alias permanent, add the alias to the **.bashrc** file in the home directory

`unalias`  -> remove alias for a command. For example, `unalias ll`
