# icpc/kattis

## Thanks!

If you are reading this you are planning to contribute as a judge.  The goal
here is to make a common environment for judges to build problem sets that
will work with the kattis online judge system.

## Docker / VirtualBox

To create a dev environment with the proper compilers, verifiers,
and tex components, this setup uses docker (Docker CE is fine) to create a single large docker container with the required components, and some simple wrapper scripts that lets you run them from your own environment (mac, win, linux) to maintain a consistent environment for judges.

***WARNING*** Docker used to be a build-once run anywhere environment, but it has fractured into a windows vs. linux docker-container versions.  ***Get the VirtualBox based version*** because you want a linux VirtualBox-hosted docker-container.  This also means you need to disable Hyper-V in windows for these containers to work.
## Setup (Local Option - slower, but all yours)

Run `bin/setup --build` from the docker command line.

*Warning* this is slow (perhaps an hour) to create the required large container.  The good news is you only need to do this once.  But get it before going to bed.

On a linux/mac, once you have the docker whale running, the terminal works just fine.

On windows, there is "docker quickstart" that pops a command line tool that seems to work fine.

## Setup (Remote Option - faster, default, trust my build)

Run `bin/setup` pulls the same container from Docker Hub (setup creates icpc/kattis:latest from `dockers/kattis/Dockerfile`, while setup uses icpc/kattis:latest from Docker Hub)

## Use

After setup, **NOTICE THE DOT** `. context` in project will set your path, while `. uncontext` resets it.

After this, the dev tools,

`make`,`g++`,`gcc`,`java`,`javac`,`python`,`python3`, `kotlin`, `kotlinc`

the latex tools,

`pdflatex`,`problem2pdf`,`problem2html`

and the kattis verification tool,

`verifyproblem`

map to running with the kattis container. The shell command

`kattis-docker` command...

runs a comand within the kattis container (for example to execute a compiled executable).

## Tests

After setup

```bash
cd tests
./all
```

should pass all tests.

