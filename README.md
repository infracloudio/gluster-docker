# README #

## What is this repository for? ##

This repository is to demonstrate persistent storage for postgres container using gluster.
The objective is following 

* Create a 3 machine gluster cluster 
* Create a gluster volume with replication factor of 3
* Mount the volume and use it as data directory for postgres container.
* Start an application stack ( postgresql db + db writer container + flask web app ) on one machine
* Verify the writer is writing to the DB. (The db writer container writes 1 entry every second and increments the counter)
* Stop the stack and start it on a different machine.
* Verify that the DB contains old as well as new entries.

## How do I get set up? ##

### Pre-requisites ###
* Virtual Box (5.0.12 or above)
* Vagrant (1.8.4 or above)

### Configuration Steps ###
* Copy this repo to your system.
```
  cd <PATH TO REPO>
  vagrant up
```
* This will do following:
  * Create 3 ubuntu VMs _manager01_ , _worker01_ , _worker02_
  * Install docker and gluster on them
  * Create host entries for each machine on others
* Now run below command first on manager01 , then on worker01 and then on worker 02
`sudo /vagrant/scripts/configGluster.sh step1` 
This will create a gluster cluster by connecting all hosts to each other.
* Now run below command first on manager01 , then on worker01 and then on worker 02
`sudo /vagrant/scripts/configGluster.sh step2`
This will stop and remove any existing gluster volume and then create it from scratch.
* Now run below command first on manager01 , then on worker01 and then on worker 02
`sudo /vagrant/scripts/configGluster.sh step3`
This will mount the gluster volume on all 3 machines.
* Now you have a filesystem `/mnt/data` which is shared across all 3 machines and will remain in sync. You can test it by writing a file to this FS and verifying on other machines.
* Now we start our docker application on *manager01* by running following commands
```
cd /vagrant
docker-compose -f gluster-compose.yml up -d
```
* This will pull all images from docker hub and start the required containers.
* The application will be accessible on [http://192.168.17.101](http://192.168.17.101)
* Check the system time on manager01 and then enter From time and To Time values in the webpage and hit Submit.
* You will see the container ID of postgreswriter container and the timestamp, counter which it has been writing to the database. 
* Now stop the stack on manager01 using these commands
``` 
cd /vagrant;
docker-compose -f gluster-compose.yml stop
```
* Start the stack on worker02 using the commands 
```
cd /vagrant
docker-compose -f gluster-compose.yml up -d
```
* The application will be accessible on [http://192.168.17.103](http://192.168.17.103)
* Query the database for the time when container was running on manager01 to the current system time, you will see writes from manager01 as well as worker02 both in the output. 
* This shows the persistence of postgresdb container on a gluster filesystem.