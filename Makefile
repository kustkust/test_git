logs-s:
	@minikube kubectl -- logs $p -n arc-systems -f
logs-r:
	@minikube kubectl -- logs $p -n arc-runners -f
get-s:
	@minikube kubectl -- get pods -n arc-systems
get-r:
	@minikube kubectl -- get pods -n arc-runners