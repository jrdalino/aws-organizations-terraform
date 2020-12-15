# AWS Organizations
resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    // tag policies
    // cloudformation stacksets
    // compute optimizer
    // firewall manager
    // resource access manager
    // service catalog
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
