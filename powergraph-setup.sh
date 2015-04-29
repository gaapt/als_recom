

# install dependencies across cluster
yum install -y openmpi-devel zlib-devel cmake
ln -s /usr/lib64/openmpi/bin/* /usr/bin/.
~/ephemeral-hdfs/bin/slaves.sh yum install -y openmpi-devel zlib-devel cmake
~/ephemeral-hdfs/bin/slaves.sh ln -s /usr/lib64/openmpi/bin/* /usr/bin/.

export GL_MASTER=https://github.com/graphlab-code/graphlab.git
export GL_BRANCH=https://github.com/brkyvz/graphlab.git
# Master of graphlab
git clone $GL_MASTER /mnt/powergraph
cd /mnt/powergraph
git remote add brkyvz $GL_BRANCH
git fetch brkyvz
git merge brkyvz/mod

# make on /mnt because compiling requires a bunch of disk space
# and we kept running out on the 8GB ec2 root volume


./configure --no_tcmalloc
cd release/toolkits/collaborative_filtering
# -j8 means use parallel compilation with 8 threads. Adjust to the number of cores you have available.
make -j8
cd /mnt
# copy binary to all nodes in cluster
~/spark-ec2/copy-dir /mnt/powergraph

cd ~/

