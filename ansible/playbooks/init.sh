#!/bin/bash -

# Copyright 2019 baicells Authors.
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

function copyright() {
cat << EOF > $1
# Copyright 2019 baicells Authors.
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
EOF
}

role=$1

if [ -z $1 ]; then
    echo "Usage: $0 [project name]"
    exit 0
fi

mkdir -pv roles/$1/{tasks,files,templates,meta,handlers,vars}

pushd roles/$1 &>/dev/null

for f in tasks templates handlers vars
do
   [[ ! -f $f/main.yaml ]] && copyright $f/main.yaml 
done

for f in files meta
do
   touch $f/.gitkeep
done

popd &>/dev/null

copyright ${role}.yaml
cat << EOF >> ${role}.yaml

- hosts: localhost
  roles:
  - role: {{project name}}
EOF


sed -i  "{/role:/s/{{project name}}/$1/g}" $1.yaml
