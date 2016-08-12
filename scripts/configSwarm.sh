#!/bin/bash
managerIP=$(grep manager /etc/hosts | tail -n 1 | awk '{print $1}');

if [[ `hostname` = manager01 ]]; then
		 echo "docker swarm init --listen-addr ${managerIP}:2377 --advertise-addr ${managerIP}:2377";
     docker swarm init --listen-addr ${managerIP}:2377 --advertise-addr ${managerIP}:2377
			docker node ls
			export manager_token=$(docker swarm join-token manager -q)
			export worker_token=$(docker swarm join-token worker -q)
			echo "export manager_token=$manager_token" > /vagrant/scripts/swarm_token_init.sh
			echo "export worker_token=$worker_token" >> /vagrant/scripts/swarm_token_init.sh
else
    . /vagrant/scripts/swarm_token_init.sh
    if [[ "$worker_token" != "" ]]; then
    		export workerIP=$(grep `hostname` /etc/hosts | tail -n 1 | awk '{print $1}');
         docker swarm join \
						--token $worker_token \
						--listen-addr $workerIP \
						--advertise-addr $workerIP \
						${managerIP}:2377
						echo "docker swarm join --token $worker_token --listen-addr $workerIP --advertise-addr $workerIP ${managerIP}:2377";
						
    else 
        echo "swarm join command not found ";
    fi
fi


