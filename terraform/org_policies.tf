# Copyright 2023 Chris Farris <chrisf@primeharbor.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


resource "aws_organizations_policy" "vault_protection_scp" {
  name        = "vault_protection_scp"
  description = "Prevent Deletion of Backup Vaults and Recovery Points"
  type        = "SERVICE_CONTROL_POLICY"
  content     = file("${path.module}/../backup-policies/AWSBackupVault-ServiceControlPolicy.json")
}
resource "aws_organizations_policy_attachment" "vault_protection_scp" {
  policy_id = aws_organizations_policy.vault_protection_scp.id
  target_id = data.aws_organizations_organization.my_organization.roots[0].id
}


resource "aws_organizations_policy" "bcp_tier1_backup_policy" {
  name        = "bcp_tier1_backup_policy"
  description = "BCP Tier 1 Backup Policy"
  type        = "BACKUP_POLICY"
  content     = file("${path.module}/../backup-policies/bcp-tier1-BackupPolicy.json")
}
resource "aws_organizations_policy_attachment" "bcp_tier1_backup_policy" {
  policy_id = aws_organizations_policy.bcp_tier1_backup_policy.id
  target_id = data.aws_organizations_organization.my_organization.roots[0].id
}


resource "aws_organizations_policy" "bcp_tier2_backup_policy" {
  name        = "bcp_tier2_backup_policy"
  description = "BCP Tier 2 Backup Policy"
  type        = "BACKUP_POLICY"
  content     = file("${path.module}/../backup-policies/bcp-tier2-BackupPolicy.json")
}
resource "aws_organizations_policy_attachment" "bcp_tier2_backup_policy" {
  policy_id = aws_organizations_policy.bcp_tier2_backup_policy.id
  target_id = data.aws_organizations_organization.my_organization.roots[0].id
}


resource "aws_organizations_policy" "bcp_tier3_backup_policy" {
  name        = "bcp_tier3_backup_policy"
  description = "BCP Tier 3 Backup Policy"
  type        = "BACKUP_POLICY"
  content     = file("${path.module}/../backup-policies/bcp-tier3-BackupPolicy.json")
}
resource "aws_organizations_policy_attachment" "bcp_tier3_backup_policy" {
  policy_id = aws_organizations_policy.bcp_tier3_backup_policy.id
  target_id = data.aws_organizations_organization.my_organization.roots[0].id
}


resource "aws_organizations_policy" "bcp_tier4_backup_policy" {
  name        = "bcp_tier4_backup_policy"
  description = "BCP Tier 4 Backup Policy"
  type        = "BACKUP_POLICY"
  content     = file("${path.module}/../backup-policies/bcp-tier4-BackupPolicy.json")
}
resource "aws_organizations_policy_attachment" "bcp_tier4_backup_policy" {
  policy_id = aws_organizations_policy.bcp_tier4_backup_policy.id
  target_id = data.aws_organizations_organization.my_organization.roots[0].id
}
