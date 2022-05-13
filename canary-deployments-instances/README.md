# terraform-oci-arch-devops-deployment-strategies (canary-deployments-instances)

## OCI Deployment on instances with canary strategy 

With a Canary deployment strategy, the application release happens incrementally to a subset of users. Initially, the new version gets deployed to a canary environment with no user traffic. The DevOps release pipeline can run validation tests against the new version and, once ready, route only a subset of users to the canary environment.

This technique allows the DevOps team to evaluate the new application version against real user traffic. They can compare the two application versions side-by-side before rolling out the new version to a larger user base. It also offers risk mitigation as the new version is only enabled for a small subset of users—these users can easily switch back to the previous version in case of any issues.

## Terraform Provider for Oracle Cloud Infrastructure
The OCI Terraform Provider is now available for automatic download through the Terraform Provider Registry. 
For more information on how to get started view the [documentation](https://www.terraform.io/docs/providers/oci/index.html) 
and [setup guide](https://www.terraform.io/docs/providers/oci/guides/version-3-upgrade.html).

* [Documentation](https://www.terraform.io/docs/providers/oci/index.html)
* [OCI forums](https://cloudcustomerconnect.oracle.com/resources/9c8fa8f96f/summary)
* [Github issues](https://github.com/terraform-providers/terraform-provider-oci/issues)
* [Troubleshooting](https://www.terraform.io/docs/providers/oci/guides/guides/troubleshooting.html)

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-devops-deployment-strategies/releases/latest/download/terraform-oci-arch-devops-deployment-strategies-canary-deployments-instances-stack-latest.zip)

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
    cd terraform-oci-arch-devops-deployment-strategies/canary-deployments-instances/
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
Follow the link here to test the deployment - [procedure](https://github.com/oracle-devrel/oci-devops-examples/tree/main/oci-deployment-examples/oci-devops-deploy-instances-with-canary#lets-test)


## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

- Ensure to delete all  artifacts via `OCI Console` > `Artifact Registry` > `Artifact Repo Name` for the destroy action.


    terraform destroy

