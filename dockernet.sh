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
        docker run --network=br0 --ip 172.28.5.1 -w /core_server -t cbnb:v2 \
            /root/.cargo/bin/cargo run -q  > Core_log &
       
        #Running Node Client 
        echo '#> Stariing the $2 CBnB Nodes' 
        for i in `seq 1 $2`;do
            sleep 0.5
            docker run --network=br0 -m 1GB -w /node_client -t cbnb:v2 \
                /root/.cargo/bin/cargo run -q  > Node_log_$i &
            done
        ;;

    stop)
        echo '#> Stopping all the test machines ' 
        for i in `docker ps|awk '/cbnb:v2/{print $1}'`;do docker kill $i;done
        rm Core_log Node_log*
        ;;

    *)
        echo "Usage: ./dockernet.sh start/stop [node_count (for start)]"
        ;;
esac

