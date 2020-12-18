# AWS Organizations
resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    // tag policies
    // aws artifact
    // aws backup
    // cloudformation stacksets
    "cloudtrail.amazonaws.com",
    // compute optimizer
    "config.amazonaws.com",
    // directory service
    // firewall manager
    // license manager
    // resource access manager
    // service catalog
    "sso.amazonaws.com",
    // systems manager
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
    "AISERVICES_OPT_OUT_POLICY",
  ]

  feature_set = "ALL"
}

# Organizational Units
resource "aws_organizations_organizational_unit" "org" {
  name      = "org"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "prd" {
  name      = "prd"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "stg" {
  name      = "stg"
  parent_id = aws_organizations_organization.this.roots[0].id
}

# Tag Policies
resource "aws_organizations_policy" "ProductDomainTag" {
  name        = "ProductDomainTag"
  description = "Product Domain tag policy"
  type        = "TAG_POLICY"

  content = <<CONTENT
{
    "tags": {
        "ProductDomain": {
            "tag_key": {
                "@@assign": "ProductDomain"
            },
            "tag_value": {
                "@@assign": [
                    "org",
                    "adm",
                    "sup",
                    "cus",
                    "pro",
                    "inv",
                    "car",
                    "ord",
                    "bil",
                    "pay",
                    "not",
                    "rec",                    
                    "sea",
                    "pro",
                    "sup",
                    "rev",
                    "ima",
                    "cur",
                    "adv" 
                ]
            }
        }
    }
}
CONTENT

  depends_on = [
    aws_organizations_organization.this,
  ]
}

resource "aws_organizations_policy_attachment" "root_ProductDomainTag" {
  policy_id = aws_organizations_policy.ProductDomainTag.id
  target_id = aws_organizations_organization.this.roots[0].id
}

# AI Opt Out Policy
resource "aws_organizations_policy" "DefaultOptOutPolicy" {
  name        = "DefaultOptOutPolicy"
  description = "Prevent all AWS AI services from accessing our data"
  type        = "AISERVICES_OPT_OUT_POLICY"

  content = <<CONTENT
{
    "services": {
        "@@operators_allowed_for_child_policies": [
            "@@none"
        ],
        "default": {
            "@@operators_allowed_for_child_policies": [
                "@@none"
            ],
            "opt_out_policy": {
                "@@operators_allowed_for_child_policies": [
                    "@@none"
                ],
                "@@assign": "optOut"
            }
        }
    }
}
CONTENT

  depends_on = [
    aws_organizations_organization.this,
  ]
}

resource "aws_organizations_policy_attachment" "root_DefaultOptOutPolicy" {
  policy_id = aws_organizations_policy.DefaultOptOutPolicy.id
  target_id = aws_organizations_organization.this.roots[0].id
}

# Service Control Policies
resource "aws_organizations_policy" "DenySpecificAWSServices" {
  name        = "DenySpecificAWSServices"
  description = "Deny access to specific AWS Services"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<CONTENT
{
    "Version": "2012-10-17",
    "Id": "DenySpecificAWSServices",
    "Statement": [
        {
            "Sid": "DenyChime",
            "Effect": "Deny",
            "Action": "chime:*",
            "Resource": "*"
        },
        {
            "Sid": "DenyAlexa",
            "Effect": "Deny",
            "Action": "a4b:*",
            "Resource": "*"
        },
        {
            "Sid": "DenyAppStream",
            "Effect": "Deny",
            "Action": "appstream:*",
            "Resource": "*"
        },
        {
            "Sid": "DenyDirectoryService",
            "Effect": "Deny",
            "Action": "ds:*",
            "Resource": "*"
        },
        {
            "Sid": "DenyWorkServices",
            "Effect": "Deny",
            "Action": [
                "workspaces:*",
                "workmail:*",
                "workdocs:*",
                "wam:*"
            ],
            "Resource": "*"
        }
    ]
}
CONTENT

  depends_on = [
    aws_organizations_organization.this,
  ]
}

resource "aws_organizations_policy_attachment" "root_DenySpecificAWSServices" {
  policy_id = aws_organizations_policy.DenySpecificAWSServices.id
  target_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_policy" "DenyAWSServicesInOtherRegions" {
  name        = "DenyAWSServicesInOtherRegions"
  description = "Deny access to AWS Services in other regions"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<CONTENT
{
    "Version": "2012-10-17",
    "Id": "DenyServicesInOtherRegions",
    "Statement": [
        {
            "Sid": "DenyServicesInOtherRegions",
            "Effect": "Deny",
            "NotAction": [
                "a4b:*",
                "acm:*",
                "aws-marketplace-management:*",
                "aws-marketplace:*",
                "aws-portal:*",
                "awsbillingconsole:*",
                "budgets:*",
                "ce:*",
                "chime:*",
                "cloudfront:*",
                "config:*",
                "cur:*",
                "directconnect:*",
                "ec2:DescribeRegions",
                "ec2:DescribeTransitGateways",
                "ec2:DescribeVpnGateways",
                "fms:*",
                "globalaccelerator:*",
                "health:*",
                "iam:*",
                "importexport:*",
                "kms:*",
                "mobileanalytics:*",
                "networkmanager:*",
                "organizations:*",
                "pricing:*",
                "route53:*",
                "route53domains:*",
                "s3:GetAccountPublic*",
                "s3:ListAllMyBuckets",
                "s3:PutAccountPublic*",
                "shield:*",
                "sts:*",
                "support:*",
                "trustedadvisor:*",
                "waf-regional:*",
                "waf:*",
                "wafv2:*",
                "wellarchitected:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringNotEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "ap-southeast-1"
                    ]
                }
            }
        }
    ]
}
CONTENT

  depends_on = [
    aws_organizations_organization.this,
  ]
}

resource "aws_organizations_policy_attachment" "root_DenyAWSServicesInOtherRegions" {
  policy_id = aws_organizations_policy.DenyAWSServicesInOtherRegions.id
  target_id = aws_organizations_organization.this.roots[0].id
}