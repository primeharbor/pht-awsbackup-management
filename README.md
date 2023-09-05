# pht-awsbackup-management
Scripts and IaC to create a ransomware resilient AWS Backup System

You can read more about this s[olution on our website](https://www.primeharbor.com/blog/awsbackup/).

## How to leverage this solution

The automated backup and protection of critical data is based on simple tagging. If the tag `aws_backup_bcp_tier` is applied to a database or EBS volume, it will be automatically backed up based on the tag's value.
`tier1` - backed up hourly, copied to a second region, retained for 180 days
`tier2` - backed up hourly, stored only in the original region, retained for 180 days
`tier3` - backed up daily, stored in the original region, retained for 90 days
`tier4` - backed up daily, stored in the original region, retained for 45 days
`none` - Not backed up, but an option to ensure all resources have been reviewed.


## Installation

### Prerequisites.

The following should be enabled via the AWS Organizations Management Account:
1. The CloudFormation StackSet to deploy the vaults requires an account with [CloudFormation Delegated admin](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacksets) access.
2. You must enable Backup Policies in the [Organizations Console](https://us-east-1.console.aws.amazon.com/organizations/v2/home/policies/backup-policy)
3. You must enable Service Control Policies in the [Organizations Console](https://us-east-1.console.aws.amazon.com/organizations/v2/home/policies/service-control-policy)
4. Enable [AWS Backup Delegated Administrator](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/settings), by selecting a secure account in your organization which will be able to monitor all backup jobs. First enable "Cross account monitoring", then add the account by "[Register Delegated Administrator](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#settings/delegatedadministrator)"
5. [Enable](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/settings) the Resource Types, in the Regions you care about **from your Organizations Management Account**.

## Deploy the Vaults

The Backups Vaults are deployed via AWS Organizations CloudFormation StackSets. This ensures every account in every (enabled) region has the target vaults. The StackSet template needs to be deployed only once, preferably from us-east-1, from an AWS account that is a [registered delegated administrator for CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-delegated-admin.html?icmpid=docs_cfn_console).

The only parameter that needs to be changes is the OU Target for your organization. You can get the Root OU identifier with this command:
```bash
aws organizations list-roots --query 'Roots[0].Id' --output text
```

The [AWSBackup-Vaults-StackSetTemplate.yaml](cloudformation/AWSBackup-Vaults-StackSetTemplate.yaml) template will create a StackSet and deploy the necessary vaults in all regions. Additionally, it will create the IAM Role `CentralAWSBackupRole` as part of the stack instance deployed to `us-east-1`.

Once the vaults are fully deployed, you can create the backup policies and SCP.

## Deploy the backup policies.

Due to [limitations](https://www.chrisfarris.com/post/organization-cloudformation/) with AWS CloudFormation's support for AWS Organizations, this part is implemented in terraform.

1. Create an S3 Bucket to store the state:
	```bash
	aws s3 mb s3://aws-backup-state-ACCOUNTID
	```
2. Create a file called MYORG.tfbackend with contents as such:
```
bucket="aws-backup-state-ACCOUNTID"
```
3. Run the Terraform
```bash
cd terraform
make env=MYORG tf-init
make env=MYORG tf-plan
make env=MYORG tf-apply
```

