# LOGS
logs-s:
	@minikube kubectl -- logs $p -n arc-systems -f
logs-r:
	@minikube kubectl -- logs $p -n arc-runners -f

# GET
get-s:
	@minikube kubectl -- get pods -n arc-systems
get-r:
	@minikube kubectl -- get pods -n arc-runners
get: get-s get-r

# ARC
install-arc:
	@helm install arc --namespace arc-systems --create-namespace \
		oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
uninstall-arc:
	@helm uninstall arc -n arc-systems

# RUNNER
build-runner:
	@docker build -f CustomRunner.Dockerfile -t my-runner .
	@echo "export to minikube"
	@minikube image load my-runner
	@echo "export complete"
install-runner-cached:
	@helm install arc-runner-cached \
		--namespace arc-runners \
		--create-namespace \
		-f values.yaml \
		oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
uninstall-runner-cached:
	@helm uninstall arc-runner-cached -n arc-runners

# CACHE
konvert-cache:
	@cd cache && kompose convert --suppress-warnings -f docker-compose.cache.yml
install-cache: konvert-cache
	@cd cache \
	&& minikube kubectl -- apply -n arc-runners \
		-f cache-data-persistentvolumeclaim.yaml,cache-server-deployment.yaml,cache-server-service.yaml
uninstall-cache:
	@cd cache \
	&& minikube kubectl -- delete -n arc-runners \
		-f cache-data-persistentvolumeclaim.yaml,cache-server-deployment.yaml,cache-server-service.yaml
