# terraform-oci-arch-devops-deployment-strategies (bluegreen-deployments-oke)

## OCI Deployment on OKE with B/G strategy 

With a Blue-Green deployment strategy, DevOps teams want to release a new version of their application using two identical environments of OKE, where one of them is active at a given time. The current version of the application is provisioned on the active environment, whereas the new version gets deployed to the standby environment. Deploying to the standby environment does not impact the active instances or the user traffic. The DevOps release pipeline can run validation tests against the new version, and once approved, it gets promoted to production by simply switching the user traffic to the standby environment. This process will repeat for each new release of the application.

## Terraform Provider for Oracle Cloud Infrastructure
The OCI Terraform Provider is now available for automatic download through the Terraform Provider Registry. 
For more information on how to get started view the [documentation](https://www.terraform.io/docs/providers/oci/index.html) 
and [setup guide](https://www.terraform.io/docs/providers/oci/guides/version-3-upgrade.html).

* [Documentation](https://www.terraform.io/docs/providers/oci/index.html)
* [OCI forums](https://cloudcustomerconnect.oracle.com/resources/9c8fa8f96f/summary)
* [Github issues](https://github.com/terraform-providers/terraform-provider-oci/issues)
* [Troubleshooting](https://www.terraform.io/docs/providers/oci/guides/guides/troubleshooting.html)

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-devops-deployment-strategies/releases/latest/download/terraform-oci-arch-devops-deployment-strategies-bluegreen-deployments-oke-stack-latest.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Deploy Using the Terraform CLI

### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/oracle-devrel/terraform-oci-arch-devops-deployment-strategies
    cd terraform-oci-arch-devops-deployment-strategies/bluegreen-deployments-oke/
    ls

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Secondly, create a `terraform.tfvars` file and populate with the following information:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
compartment_ocid = "<compartment_ocid>"

# OCI User and Authtoken
oci_username       = "<oci_username> 
# For a federated user (single sign-on with an identity provider), enter the username in the following format: TenancyName/Federation/UserName. 
# For example, if you use OCI's identity provider, your login would be, Acme/oracleidentitycloudservice/alice.jones@acme.com. 
#If you are using OCI's direct sign-in, enter the username in the following format: TenancyName/YourUserName. For example, Acme/alice_jones. Your password is the auth token you created previously.

oci_user_authtoken = "<oci_user_authtoken>" 
# You can get the auth token from your Profile menu -> click User Settings -> On left side  click *Auth Tokens -> Generate Token

# Set a specific name for your deployments to prefix with a tag.
app_name = "<app_name>"
````

Deploy:

    terraform init
    terraform plan
    terraform apply

## Test the deployment.
Follow the link here to test the deployment - [procedure](https://github.com/oracle-devrel/oci-devops-examples/tree/main/oci-deployment-examples/oci-devops-deploy-with-blue-green-model#lets-test)


## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

- Ensure to delete all load balancers (by Nginx and Applications) via console before proceeding for destruction.


    terraform destroy



