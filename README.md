# Pipeline network

## Requirements
Please make sure that you have : 
- A solver, one between CPLEX and GLPK (with a preference for CPLEX)
- Anaconda
- Docker 
- R 
- pip2 & 3 
- gringo python module (shipped with gringo from http://potassco.sourceforge.net)

If you don't have them a makefile and a conf are in progress.

## Installation

Once every requirement intalled you just have to put your data inside data/ repository and launch the following command line : 

```sh
bash network_pip.sh
```
You can use the data in data/minitoy_Rsolanacearum/ repository to verify your installation.


## Results 

You will found your results in repository you named previously using the pipe, inside result/ e.g. : result/Assimil_pkn

## Documentations 
This repository still in progress. If you notice major issues do not hesitate to open an issue. 

To go further in details : 

Detailed documentation for **FlexFlux** is available at : http://lipm-bioinfo.toulouse.inra.fr/flexflux/documentation.html#general

Detailed documentation about **caspo** is available at http://caspo.readthedocs.io.

Detailed documentation about **caspots** is available at https://github.com/pauleve/caspots

For file format description of midas and sif: https://www.ebi.ac.uk/saezrodriguez/cno/doc/cnodocs/midas.html and https://www.ebi.ac.uk/saezrodriguez/cno/doc/cnodocs/sif.html
