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

VAULT=$1

if [ -z "$VAULT" ] ; then
	echo "USAGE: $0 <vaultname>"
	exit 1
fi

RECOVERY_POINTS=`aws backup list-recovery-points-by-backup-vault --backup-vault-name $VAULT --query RecoveryPoints[].RecoveryPointArn --output text `
for a in $RECOVERY_POINTS ; do
	echo "Deleting $a"
	aws backup delete-recovery-point --backup-vault-name $VAULT --recovery-point-arn $a
done
echo "Deleting Vault $VAULT"
aws backup delete-backup-vault --backup-vault-name $VAULT
