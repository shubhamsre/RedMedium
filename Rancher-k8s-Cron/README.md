# Rancher Memory/Image Nuke

Weekly cleanup of Rancher worker nodes memory and images from container.registry.io registry.
Please check the relevant [Blogpost](https://redshubh.medium.com/prune-container-images-from-rancher-using-kubernetes-cronjob-and-binaries-4bd3442c7be)

## Rancher Prune Task

The automated cleanup takes place using a Kubernetes Cron Job which runs a Shell Script on an alpine container with a scheduled trigger.

 - Clean unused images tags+digests from container.registry.io registry.
 - It needs access write file on host - can use emptydir in future.
 - It has a sleep of 5 seconds between consecutive worker node cleanup.
 - The cron is scheduled to trigger every Sunday 12:12 depending on cluster timezone.
 - The job execution time may vary on the number of nodes and container images to cleanup.
 - The resources like secrets and cron-jobs are created under **rancher-system** namespace.
 - The cronjob using Rancher cli to authenticate to the cluster, which makes the login process fast enough.

More Info on [Kubernetes CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#example)

## Implementation

The cronjob requires 3 input parameters
- Rancher Server URL 
- Rancher API Token
- Rancher Server Context

More info on [Rancher CLI authentication](https://rancher.com/docs/rancher/v2.5/en/cli/#cli-authentication)

### Using Runtime Environment Variables

Cronjob can be implemented by using the above parameters and passing them directly as the runtime env variables to the cron job container. Later on provising the job using some CI/CD tool, the values can be substituted using tokenization from some storage vault.

          containers:
          - name: rancherprune
            image: alpine
            env:
            - name: SERVERURL
              value: <Rancher Cluster URL>
            - name: TOKEN
              value: <Rancher API-Token with no scope>
            - name: CONTEXT
              value: <Rancher Server Context>

More Info on [Kubernetes Environment Variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/#define-an-environment-variable-for-a-container)

### Using Environment Variables with Secret Reference

Cronjob can be implemented by using the above parameters and creating the secret which then can be referenced into the container using the combination of key-value pairs. Later on provising the secret and the job using some CI/CD tool, the secret values can be substituted using tokenization from some storage vault.

**Note: The secret values stored in the Vault should be base64 encoded.**

Creating a Secret

	      data:
	        serverurl: <BASE64 Rancher Cluster URL>
	        token: <BASE64 Rancher API-Token>
	        context: <BASE64 Rancher Server Context>

Referencing Secret Values inside the container

          containers:
          - name: rancherprune
            image: alpine
            env:
            # Rancher Cluster URL
            - name: RANCHER_SERVERURL
              valueFrom:
                secretKeyRef:
                  name: rancher-secret
                  key: serverurl
            # Generate API-token with no scope
            - name: RANCHER_TOKEN
              valueFrom:
                secretKeyRef:
                  name: rancher-secret
                  key: token
            # Get the appropriate context
            - name: RANCHER_CONTEXT
              valueFrom:
                secretKeyRef:
                  name: rancher-secret
                  key: context

More info on [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)


## Further Improvements

It is a long shell-script which is doing lot of work. All this can be encapsulated using a dockerfile and pushed into a private registry or wrapped up as a binary with options providing to clear unused container images and clear node memory cache.




