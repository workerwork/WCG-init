#!/bin/bash

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

#yum install createrepo
createrepo yum/repository --update

if [ ! -d /opt/repository ];then
    cp -rf yum/repository /opt
else
    echo "/opt/repository not empty, exit"
    rm -rf /opt/repository
    cp -rf yum/repository /opt
fi

rm -rf /etc/yum.repos.d/baicells-wcg.repo || true

cat>>/etc/yum.repos.d/baicells-wcg.repo<<EOF
[baicells-wcg]
name=baicells-wcg
baseurl=file:///opt/repository/
enable=1
gpgcheck=0
priority=1
EOF

yum clean all
yum makecache

yum install -y ansible

ansible-playbook ansible/playbooks/install-wcg.yaml
