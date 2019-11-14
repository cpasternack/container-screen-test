## Docker containers and screen

Sometimes you don't need a container for a nice web application. Sometimes you just need to test
packaging or building in an environment that isn't a virtual machine, ephemerally. Sometimes you
need a quick and easy container to punt stuff into, then see what damage it causes. This is exactly
what that is for.

I did some testing on Ubuntu 18.04, from 16.04, and needed to replicate the manual work I was doing
with 16.04 in development, in an automated fashion for 18.04. Working with GNU screen, I learned that
you can send commands, and script a bunch of things from the startup. 

This is a skeleton project for working with building and running such containers. I orchestrated with
ansible previously, and you can still do that here (it runs sshd, just ad python3 package to the install)

Might be useful, might not. I learned a lot more about screen and container environments that I expected
to by doing this.

## Warning

Do not use this in a production environment. No user is created, and the entrypoint script runs as PID 1,
with whatever commands you dump in. This is useful for testing purposes only, and you want to inject an
ssh-key for real security. This is provided only as a skeleton, and a learning tool.

## License

License for files in the repo are MIT, software licenses from built container are many and varied.
