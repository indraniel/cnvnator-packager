# Build Process for Ubuntu 10.04

Ubuntu 10.04 is [no longer supported][1];  however, it's currently the primary operating system on the computational cluster at the [McDonnell Genome Institute at Washington University][2].  This is a record of what was done to build the latest version of CNVnator for Ubuntu 10.04.

These instructions are based upon using a "default" untainted [Ubuntu 10.04 cloud image for OpenStack][3], and with a user and group both named `ubuntu`.

## Initial Image Setup

```
# Ensure that you're in the ubuntu user's home directory
cd $HOME

# get things up to date
sudo apt-get udpate

# basic things needed to invoke the build Makefile
sudo apt-get install build-essential git-core libmpc2

# things needed to build python 2.7.10
sudo apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev

# building of python 2.7.10

# setup pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
exec $SHELL

# install python 2.7.10 (needed by ROOT)
pyenv install 2.7.10
pyenv global 2.7.10

# get a newer version of gcc
scp idas@linus261:/gscmnt/gc2802/halllab/idas/cnvnator-packages/gcc*.deb .
sudo dpkg -i gcc_4.8.4-1ubuntu10.04.deb
```

## Building `CNVnator`

```
# Ensure that you're in the ubuntu user's home directory
cd $HOME

# get the builder/packager Makefile
git clone https://github.com/indraniel/cnvnator-packager.git
cd cnvnator-packager/
git checkout -b ubuntu10.04 origin/ubuntu10.04

# build cnvnator
make 2>&1 |tee out.log
make debian

# extract the CNVnator debian package to your host machine
scp /opt/cnvnator-0.3.2/cnvnator_0.3.2-1ubuntu10.04.deb idas@linus261:/gscmnt/gc2802/halllab/idas/cnvnator-packages
```

[1]: https://wiki.ubuntu.com/LTS
[2]: http://genome.wustl.edu
[3]: https://cloud-images.ubuntu.com
