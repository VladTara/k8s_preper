kubectl get pods -o wide
ssh [node_name]

ifconfig
docker ps
docker inspect --format '{{ .State.Pid }}' [container_id]
nsenter -t [container_pid] -n ip addr