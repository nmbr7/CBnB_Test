#!/bin/sh
case "$1" in
    start)
        if [[ $# -lt 2 ]];then
            echo "Usage: ./dockernet.sh start/stop [node_count (for start)]"
            exit
        fi
        echo '#> Starting the docker test machines'
        echo '#> Starting the CBnB CoreServer' 

        #Running Core Server
        docker run --network=br0 --ip 172.28.5.1 -w /core_server -t cbnbproxy:v2 \
            /root/.cargo/bin/cargo run --release   > Core_log &
       
        #Running Proxy Server
        docker run --network=br0 --ip 172.28.5.77 -w /proxy_server -t cbnbproxy:v2 \
            /root/.cargo/bin/cargo run  --release  > Proxy_log &
        
        
        #Running Node Client 
        echo '#> Stariing the $2 CBnB Nodes' 
        for i in `seq 1 $2`;do
            sleep 0.5
            docker container rm -f n_$i
            docker run --name=n_$i --memory=512M --memory-swap=1024M   --network=br0  -w /node_client -t cbnbproxy:v2 \
                /root/.cargo/bin/cargo run --release > Node_log_$i &
            sleep 0.25
            done
        ;;
    stop)
        echo '#> Stopping all the test machines ' 
        for i in `docker ps|awk '/root/{print $1}'`;do docker kill $i;done
        rm Core_log Proxy_log Node_log* 
        ;;

    *)
        echo "Usage: ./dockernet.sh start/stop [node_count (for start)]"
        ;;
esac

