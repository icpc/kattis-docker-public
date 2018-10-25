<img align="right" src="kattis-docker.png">

# Kattis in a Container

The same ICPC test/run/build configuration that kattis.com uses for problem solvers and problem makers.

If want to practice for or contribute to the [ICPC](https://icpc.foundation) regional contests which runs on [katts](https://open.kattis.com), then you need to make sure your code builds and runs as expected.  This project makes that easy using containers runing on docker.

## Problem Solver

Welcome! Use the `--slim` setup option below.  You don't need the validator or latex tools.  Only the -slim and -web tests should pass with `tests/all`.

## Problem Contributor.

Thanks! Use the `--fat` (default) option below.  You do need the validator and latex tools.  All the tests should pass with `tests/all`.


## Setup

### Step 0 - Docker Toolbox

You need Docker Toolbox [win](https://docs.docker.com/toolbox/toolbox_install_windows/)|[mac](https://docs.docker.com/toolbox/toolbox_install_mac/).  Or docker CE in [linux](https://docs.docker.com/install/).  Docker CE is a poor experience in windows, so don't do that.

I assume you are running all commands from a terminal (max/linux) or a Docker CLI bash shell in windows.  Basically `echo $(pwd)` and `docker ps` should work.


### Step 1 - Download ([tar](https://api.github.com/repos/icpc/kattis-docker/tarball/master)|[zip](https://api.github.com/repos/icpc/kattis-docker/zipball/master)), [fork](https://help.github.com/articles/fork-a-repo/) or [clone](https://help.github.com/articles/cloning-a-repository/) this repository.

* Clone is a pretty good option, because then it's easy to update later with `git pull`
* Fork is a pretty good option if you are a chief judge getting ready to make a new problem set for a contest, and want to make it easy to test for you and other judges.
* Download is simple.

### Step 2 - Setup

In the root of this project directory in the docker shell from step 0, run setup.

* `bin/setup` Full pulled setup (prebuilt downloads from docker hub)
* `bin/setup --build` Build the containers locally.  Useful if you want a tweaked container.  Be patient.
* `bin/setup --slim` Skip the fat container verification container (latex + compilers + problemtools) just have the slim (gcc, java, etc.) containers for the languages to compile and run code.

You can redo this step as often as you want, but once per dev system should be enough unless there are updates to incorporate, like from a `git pull` of this repository.

## Use

After setup, **NOTICE THE DOT** `. context` in project will set your path, while `. uncontext` resets it.  

After this, the dev tools,

`make`,`g++`,`gcc`,`java`,`javac`,`python`,`python3`, `kotlin`, `kotlinc`

the fat container (no `--slim`) provides

`pdflatex`,`problem2pdf`,`problem2html`

and the kattis verification tool,

`verifyproblem`

map to running with the kattis container. The shell command

```bash

kattis-docker command args... # fat container (no --slim setup)
gcc-docker command args... # gcc/g++/make/cmake
java-docker command args... # java/kotlin
python-docker command args... # python/pypy
python3-docker command args... # python3

```

## Tests

After setup

```bash
cd tests
./all
```

should pass all tests (except the `*-kattis` tests with the slim setup).

