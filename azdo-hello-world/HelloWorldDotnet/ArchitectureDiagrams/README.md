## Diagram Breakdown

### Azure Repos to Azure Pipelines (CI):

- Code is pushed to Azure Repos and triggers Azure Pipelines (CI).

### Build Stage:

- Uses .NET SDK.
- Checks out code.
- Sets and displays the short commit ID.
- Builds and pushes the Docker image to Azure Container Registry.

### Test Stage:

- Uses .NET SDK.
- Checks out code.
- Creates a test project.
- Restores test dependencies.
- Runs tests and collects code coverage.
- Publishes code coverage results.

### Deploy Stage:

#### Deploy to Staging:

- Deploys to staging environment.
- Displays file structure and variables.
- Performs Helm deployment to staging.
- Monitors the deployment using Prometheus.
- Runs integration tests in staging.

#### Deploy to Production:

- Deploys to production environment.
- Sets production short commit ID.
- Performs Helm deployment to production.
- Monitors the deployment using Prometheus.
- Runs integration tests in production.

### Monitoring and Traffic:

- Monitors the deployments using Prometheus.
- Visualizes monitoring data in Grafana.
- Switches and routes traffic using AKS Load Balancer to users.

This diagram integrates the stages and tasks of your Azure DevOps pipeline in a cohesive flow, connecting all relevant stages and monitoring components.
