All configurations is under `backup` dir, you can use any part as you want.

Or you want to apply them all, you can run `./restore.sh`, your previous hosts' 
config will be saved into restore script `tmp` directory. `yq` utils is 
necessary to use the script.

For developers, the `backup_list.toml` is core config file for current project,
no matter if it's `backup.sh` or `restore.sh`, they both must comply with the 
`backup_list.toml` configuration.

You can pull requests in master you config if you just tweak author's(my) 
config, or you have to create new branch, `backup.sh` maybe helpful.