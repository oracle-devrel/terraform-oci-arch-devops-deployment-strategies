# terraform-oci-arch-devops-deployment-strategies

In this reference architecture, we will be building and deploying a modern application with blue-green and canary deployment strategies. Deployment strategies are mode and practises which enable modification or upgrade of application. Deployment strategies allow DevOps teams to define how applications get deployed to the production environment. Choosing between different deployment strategies allows admins to make the right trade-off between the risk of deploying a new release, the impact of the new release on its users, and the infrastructure overhead needed to implement the strategy. We want to enable our customers with more options to make the right trade-off given their application needs.

* [bluegreen-deployment-instances](bluegreen-deployment-instances) - with a Blue-Green deployment strategy, DevOps teams want to release a new version of their application using two identical environments of compute instances, where one of them is active at a given time.

* [bluegreen-deployment-oke](bluegreen-deployment-oke) - with a Blue-Green deployment strategy, DevOps teams want to release a new version of their application using two identical environments in OKE, where one of them is active at a given time.

* [canary-deployments-instances](canary-deployments-instances) - with a Canary deployment strategy, the application release happens incrementally to a subset of users. Initially, the new version gets deployed to a canary environment based on compute instances with no user traffic. The DevOps release pipeline can run validation tests against the new version and, once ready, route only a subset of users to the canary environment.

* [canary-deployments-oke](canary-deployments-oke) - with a Canary deployment strategy, the application release happens incrementally to a subset of users. Initially, the new version gets deployed to a canary environment in OKE with no user traffic. The DevOps release pipeline can run validation tests against the new version and, once ready, route only a subset of users to the canary environment.

Please follow the instructions in [bluegreen-deployment-instances](bluegreen-deployment-instances), [bluegreen-deployment-oke](bluegreen-deployment-oke), [canary-deployments-instances](canary-deployments-instances) or [canary-deployments-oke](canary-deployments-oke) folders to deploy.
