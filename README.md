# aws-organizations-terraform

## Replace variables in terraform.tfvars

## Step 1: Create AWS Org, OU's & SCP's using Initialize, Review Plan and Apply
```
$ terraform init
$ terraform fmt
$ terraform validate
$ terraform plan
$ terraform apply
```

## Step 2: Check your email to finish verifying your management account
- We sent a verification email to hello@example.com. After you verify your email address, you can invite existing AWS accounts to your organization. Learn more

## Step 3.a Create new AWS Accounts using the console
### Production Account
- Account name        = "wknc-demo-prd"
- Email address       = "wknc-demo-prd@example.com"
- IAM role name       = "OrganizationAccountAccessRole"
- Tag > Name          = "wknc-demo-prd"
- Tag > Description   = "Demo production account"
- Tag > Environment   = "prd"

### Staging Account
- Account name        = "wknc-demo-stg"
- Email address       = "wknc-demo-stg@example.com"
- IAM role name       = "OrganizationAccountAccessRole"
- Tag > Name          = "wknc-demo-stg"
- Tag > Description   = "Demo staging account"
- Tag > Environment   = "stg"

## Step 3.b: Import Existing AWS Accounts
```
$ terraform import aws_organizations_account.my_org 111111111111
```

## Step 4: move wknc-aws-org to Organizational Unit: "org"

## Appendix: Best Practices
| # | Rule | Description |
| - | ---- | ----------- | 
| 1 | AWS Organizations In Use | Ensure Amazon Organizations is in use to consolidate all your AWS accounts into an organization. | 
| 2 | Enable All Features | Ensure AWS Organizations All Features is enabled for fine-grained control over which services and actions the member accounts of an organization can access. | 
| 3 | AWS Organizations Configuration Changes | AWS Organizations configuration changes have been detected within your Amazon Web Services account(s). | 

## Appendix: Multi AWS Account Recommendations
- Create Three (3) New Email aliases wknc-aws-org@, wknc-demo-stg@, wknc-demo-prd@ 

| # | Description | Alias |
| - | ----------- | ----- |
| 1 | AWS Org/Root AWS Account                 | wknc-aws-org      |
| 2 | Shared Services AWS Account              | wknc-aws-org      |
| 3 | Log Archive AWS Account                  | wknc-aws-org      |
| 4 | Security AWS Account                     | wknc-aws-org      |
| 5 | Identity & Access AWS or AWS SSO Account | wknc-aws-org      |
| 6 | Network/Direct Connect AWS Account       | wknc-aws-org      |
| 7 | Staging AWS Account                      | wknc-demo-stg     |
| 8 | Production AWS Account                   | wknc-demo-prd     |
| 9 | Engineer Sandbox AWS Account             | wknc-engrname-sbx |

## Appendix: Service Control Policies
- Prevent Users from Disabling AWS CloudTrail
- Prevent Users from Disabling Amazon CloudWatch or Altering Its Configuration
- Prevent Users from Deleting Amazon VPC Flow Logs
- Prevent Users from Disabling AWS Config or Changing Its Rules
- Denies Access to AWS Based on the Requested Region
- Require Encryption on Amazon S3 Buckets
- Denies the modification of the account contacts & settings via the Billing Portal and My Account Page
- Denies the account from leaving the organization
