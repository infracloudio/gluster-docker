# README #

### What is this repository for? ###

This repository is to demonstrate persistent storage for postgres container using gluster.
The objective is following 
*Create a 3 machine gluster cluster
* Create a gluster volume with replication factor of 3
* Mount the volume and use it as data directory for postgres container.
* Start an application stack ( postgresql db + db writer container + flask web app ) on one machine
* Verify the writer is writing to the DB
* Stop the stack and start it on a different machine.
* Verify that the DB contains old as well as new entries.

Version : 1.0


### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact