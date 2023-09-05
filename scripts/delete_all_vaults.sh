#!/bin/bash
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


REGIONS=`aws ec2 describe-regions --query Regions[].RegionName  --output text`

for r in $REGIONS ; do
	VAULTS=`aws backup list-backup-vaults --query BackupVaultList[].BackupVaultName --output text --region $r`

	for v in $VAULTS ; do
		RECOVERY_POINTS=`aws backup list-recovery-points-by-backup-vault --backup-vault-name $v --query RecoveryPoints[].RecoveryPointArn --output text --region $r --max-results 1000`
		for a in $RECOVERY_POINTS ; do
			echo "Deleting RecoveryPoint $a from $v"
			aws backup delete-recovery-point --backup-vault-name $v --recovery-point-arn $a --region $r
		done
		echo "Deleting Vault $v in $r"
		aws backup delete-backup-vault --backup-vault-name $v --region $r
	done
done