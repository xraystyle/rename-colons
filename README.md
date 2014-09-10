Recursively find and rename files and folders that match a specific pattern.
-------------------------------------------------------------------------------

This is a script I wrote to solve a specific problem. I have a file server on which there were a number of files and directories that contained colons in the names. Some were nested within others. 

These folders were named on sharepoints that were shared to Macs over AFP. I later switched to SMB/CIFS when Apple moved toward it as a standard, but sharing the same files and folders over CIFS resulted in garbled names and unlistable directories because colons are a reserved character on Windows systems. 

On a NAS with tens of thousands of directories and files, I needed a way to find every directory and file with a colon in it's name and rename it in place with a hyphen in the name in place of the colon.

Also, I wanted to try to avoid recursion so that the script would be scalable.

As much as I love testing in production, I thought it would be wiser in this case to create a directory tree to test the script on. Included here is a second script, make_dirs.rb, which makes stacks of nested directories until the script is interrupted. The script puts a colon in the names of approximately 25% of the entries it creates.  When interrupted it states how many directories it created, and how many it named with colons.

To run the rename.rb script, make it executable and run it with the directory containing the items to be renamed as the first argument.

