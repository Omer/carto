# carto

*A location library for the Appleton Tower computers.*

Each machine is a database entry containing the machine's name, lab, floor, and a coordinate location. This coordinate system is a simple letter and number system, with the machine in the south east corner of each lab being the first (A0).

## Installation
No need for installation, you may add the `bin/carto_util` to your path if you wish.

## Options
The following flags can be used with `carto`:

* `-f`, `--floor`: Find by a given floor.
* `-r`, `--room`: Find by a given floor.
* `-l`, `--hostname`: Find by a given hostname.
* `-n`, `neighbours`: Find remaining machines on the level of a given hostname.
* `-c`, `--cache`: Flush the cache.
* `-h`, `--help`: Display this screen.

## Usage
For example you could get the location of of `zonda` by:
      carto_util -l "zonda"