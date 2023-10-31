# Manage file contents
## Viewing start or end of a file
`head`            -> displays the first 10 lines of a file. By default, it displays the first 10 lines of a file. For example, `head file`

`head -n`         -> displays the first n lines of a file. For example, `head -n 5 file`

`tail`            -> displays the last 10 lines of a file. By default, it displays the last 10 lines of a file. For example, `tail file`

`tail -f `        -> displays last 10 lines of a file in real time. For example, `tail -f file`

## Viewing entire contents of the file
`cat`            -> displays the contents of a file. For example, `cat file`

`cat -n`         -> displays the contents of a file with line numbers. For example, `cat -n file`

`cat -b`         -> displays the contents of a file with line numbers for non-blank lines. For example, `cat -b file`

`tac`            -> displays the contents of a file in reverse order. For example, `tac file`

`less and more`  -> displays the contents of a file one page at a time. For example, `less file` or `more file`

`less -N`        -> displays the contents of a file one page at a time with line numbers. For example, `less -N file`

`less -p`       -> displays the contents of a file one page at a time and highlights the search term. For example, `less -p "search term" file`


## Easier way to read binary files
`strings`        -> displays the printable characters in a file. For example, `strings file`

## Writing to a file
`cat > hot.txt << stop`       -> create file and write to it. For example, `cat > hot.txt << stop` and then type the contents of the file and then type `stop` to stop writing to the file.