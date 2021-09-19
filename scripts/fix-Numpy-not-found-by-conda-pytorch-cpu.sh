#!/bin/bash -x

#ref: https://www.edureka.co/community/66679/import-error-no-module-named-numpy

conda uninstall numpy
# uninstalling from conda also removed torch and torchvision.
# For conda, we need to put back pytorch-cpu and torchvision-cpu
# However, some  user said there is no need to re-install pytorch-cpu torchvision-cpu.
# Hence, the minimum is to 're-install numpy back to conda
#conda install pytorch-cpu torchvision-cpu -c pytorch
conda install numpy
