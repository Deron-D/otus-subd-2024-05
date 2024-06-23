# **Лекция №6: Внутренняя архитектура СУБД PostgreSQL**
> _Разработка проекта_

## **Задание:**
Установка СУБД PostgreSQL

Цель:
Создать кластер PostgreSQL в докере или на виртуальной машине, запустить сервер и подключить клиента


Описание/Пошаговая инструкция выполнения домашнего задания:
Развернуть контейнер с PostgreSQL или установить СУБД на виртуальную машину.
Запустить сервер.
Создать клиента с подключением к базе данных postgres через командную строку.
Подключиться к серверу используя pgAdmin или другое аналогичное приложение.

Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены
---

## **Выполнено:**

1.ВМ с ОС Centos 7 поднимается помощью ПО Vagrant (версии 2.2.19). По окончании развертывания просходит автоматический 
запуск её провижионинга с установкой и настройкой СУБД PostrgreSQL 15
~~~bash
vagrant up
~~~

~~~console
Bringing machine 'master' up with 'virtualbox' provider...
==> master: Importing base box 'centos/7'...
==> master: Matching MAC address for NAT networking...
==> master: Checking if box 'centos/7' version '2004.01' is up to date...
==> master: Setting the name of the VM: hw03_master_1719172552108_92016
==> master: Clearing any previously set network interfaces...
==> master: Preparing network interfaces based on configuration...
    master: Adapter 1: nat
    master: Adapter 2: hostonly
==> master: Forwarding ports...
    master: 5432 (guest) => 5432 (host) (adapter 1)
    master: 22 (guest) => 2222 (host) (adapter 1)
==> master: Running 'pre-boot' VM customizations...
==> master: Booting VM...
==> master: Waiting for machine to boot. This may take a few minutes...
    master: SSH address: 127.0.0.1:2222
    master: SSH username: vagrant
    master: SSH auth method: private key
    master: 
    master: Vagrant insecure key detected. Vagrant will automatically replace
    master: this with a newly generated keypair for better security.
    master: 
    master: Inserting generated public key within guest...
    master: Removing insecure key from the guest if it's present...
    master: Key inserted! Disconnecting and reconnecting using new SSH key...
==> master: Machine booted and ready!
==> master: Checking for guest additions in VM...
    master: No guest additions were detected on the base box for this VM! Guest
    master: additions are required for forwarded ports, shared folders, host only
    master: networking, and more. If SSH fails on this machine, please install
    master: the guest additions and repackage the box to continue.
    master: 
    master: This is not an error message; everything may continue to work properly,
    master: in which case you may ignore this message.
==> master: Setting hostname...
==> master: Configuring and enabling network interfaces...
==> master: Running provisioner: shell...
    master: Running: inline script
==> master: Running provisioner: ansible...
    master: Running ansible-playbook...
PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' ansible-playbook --connection=ssh --timeout=30 --limit="all" --inventory-file=/home/dpp/Документы/Otus/otus-subd-2024-05/hw03/.vagrant/provisioners/ansible/inventory -vv --vault-password-file=~/.ansible/vault.key ansible/playbook.yml
ansible-playbook 2.10.8
  config file = None
  configured module search path = ['/home/dpp/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]
No config file found; using defaults
redirecting (type: modules) ansible.builtin.postgresql_user to community.general.postgresql_user
[WARNING]: Collection community.general does not support Ansible version 2.10.8
redirecting (type: modules) community.general.postgresql_user to community.postgresql.postgresql_user
Skipping callback 'default', as we already have a stdout callback.
Skipping callback 'minimal', as we already have a stdout callback.
Skipping callback 'oneline', as we already have a stdout callback.

PLAYBOOK: playbook.yml *********************************************************
1 plays in ansible/playbook.yml

PLAY [Configure host master] ***************************************************
META: ran handlers

TASK [Install EPEL Repo package] ***********************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:24
changed: [master] => {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python"}, "changed": true, "changes": {"installed": ["epel-release"]}, "msg": "warning: /var/cache/yum/x86_64/7/extras/packages/epel-release-7-11.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY\nImporting GPG key 0xF4A80EB5:\n Userid     : \"CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>\"\n Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5\n Package    : centos-release-7-8.2003.0.el7.centos.x86_64 (@anaconda)\n From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n", "rc": 0, "results": ["Loaded plugins: fastestmirror\nDetermining fastest mirrors\n * base: centos-mirror.rbc.ru\n * extras: mirror.hyperdedic.ru\n * updates: mirror.hyperdedic.ru\nResolving Dependencies\n--> Running transaction check\n---> Package epel-release.noarch 0:7-11 will be installed\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package                Arch             Version         Repository        Size\n================================================================================\nInstalling:\n epel-release           noarch           7-11            extras            15 k\n\nTransaction Summary\n================================================================================\nInstall  1 Package\n\nTotal download size: 15 k\nInstalled size: 24 k\nDownloading packages:\nPublic key for epel-release-7-11.noarch.rpm is not installed\nRetrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Installing : epel-release-7-11.noarch                                     1/1 \n  Verifying  : epel-release-7-11.noarch                                     1/1 \n\nInstalled:\n  epel-release.noarch 0:7-11                                                    \n\nComplete!\n"]}

TASK [Install postgres repo] ***************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:29
changed: [master] => {"ansible_facts": {"pkg_mgr": "yum"}, "changed": true, "changes": {"installed": ["/home/vagrant/.ansible/tmp/ansible-tmp-1719172605.2592006-42276-2731362539973/pgdg-redhat-repo-latest.noarchBYUBb2.rpm"]}, "msg": "", "rc": 0, "results": ["Loaded plugins: fastestmirror\nExamining /home/vagrant/.ansible/tmp/ansible-tmp-1719172605.2592006-42276-2731362539973/pgdg-redhat-repo-latest.noarchBYUBb2.rpm: pgdg-redhat-repo-42.0-38PGDG.noarch\nMarking /home/vagrant/.ansible/tmp/ansible-tmp-1719172605.2592006-42276-2731362539973/pgdg-redhat-repo-latest.noarchBYUBb2.rpm to be installed\nResolving Dependencies\n--> Running transaction check\n---> Package pgdg-redhat-repo.noarch 0:42.0-38PGDG will be installed\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package         Arch   Version     Repository                             Size\n================================================================================\nInstalling:\n pgdg-redhat-repo\n                 noarch 42.0-38PGDG /pgdg-redhat-repo-latest.noarchBYUBb2  12 k\n\nTransaction Summary\n================================================================================\nInstall  1 Package\n\nTotal size: 12 k\nInstalled size: 12 k\nDownloading packages:\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Installing : pgdg-redhat-repo-42.0-38PGDG.noarch                          1/1 \n  Verifying  : pgdg-redhat-repo-42.0-38PGDG.noarch                          1/1 \n\nInstalled:\n  pgdg-redhat-repo.noarch 0:42.0-38PGDG                                         \n\nComplete!\n"]}

TASK [Install postgres pkgs] ***************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:34
changed: [master] => {"changed": true, "changes": {"installed": ["postgresql15-server", "python-psycopg2", "unzip"]}, "msg": "warning: /var/cache/yum/x86_64/7/epel/packages/libzstd-1.5.5-1.el7.x86_64.rpm: Header V4 RSA/SHA256 Signature, key ID 352c64e5: NOKEY\nwarning: /var/cache/yum/x86_64/7/pgdg15/packages/postgresql15-libs-15.7-1PGDG.rhel7.x86_64.rpm: Header V4 RSA/SHA1 Signature, key ID 73e3b907: NOKEY\nImporting GPG key 0x73E3B907:\n Userid     : \"PostgreSQL RPM Repository <pgsql-pkg-yum@lists.postgresql.org>\"\n Fingerprint: f245 f0bf 96ac 1827 44ca ff2e 64fa ce11 73e3 b907\n Package    : pgdg-redhat-repo-42.0-38PGDG.noarch (@/pgdg-redhat-repo-latest.noarchBYUBb2)\n From       : /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL7\nImporting GPG key 0x352C64E5:\n Userid     : \"Fedora EPEL (7) <epel@fedoraproject.org>\"\n Fingerprint: 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5\n Package    : epel-release-7-11.noarch (@extras)\n From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7\n", "rc": 0, "results": ["Loaded plugins: fastestmirror\nLoading mirror speeds from cached hostfile\n * base: centos-mirror.rbc.ru\n * epel: fedora-mirror02.rbc.ru\n * extras: mirror.hyperdedic.ru\n * updates: mirror.hyperdedic.ru\nResolving Dependencies\n--> Running transaction check\n---> Package postgresql15-server.x86_64 0:15.7-1PGDG.rhel7 will be installed\n--> Processing Dependency: postgresql15-libs(x86-64) = 15.7-1PGDG.rhel7 for package: postgresql15-server-15.7-1PGDG.rhel7.x86_64\n--> Processing Dependency: postgresql15(x86-64) = 15.7-1PGDG.rhel7 for package: postgresql15-server-15.7-1PGDG.rhel7.x86_64\n--> Processing Dependency: libzstd.so.1()(64bit) for package: postgresql15-server-15.7-1PGDG.rhel7.x86_64\n--> Processing Dependency: libpq.so.5()(64bit) for package: postgresql15-server-15.7-1PGDG.rhel7.x86_64\n---> Package python-psycopg2.x86_64 0:2.5.1-4.el7 will be installed\n---> Package unzip.x86_64 0:6.0-24.el7_9 will be installed\n--> Running transaction check\n---> Package libzstd.x86_64 0:1.5.5-1.el7 will be installed\n---> Package postgresql15.x86_64 0:15.7-1PGDG.rhel7 will be installed\n---> Package postgresql15-libs.x86_64 0:15.7-1PGDG.rhel7 will be installed\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package                  Arch        Version                Repository    Size\n================================================================================\nInstalling:\n postgresql15-server      x86_64      15.7-1PGDG.rhel7       pgdg15       5.8 M\n python-psycopg2          x86_64      2.5.1-4.el7            base         132 k\n unzip                    x86_64      6.0-24.el7_9           updates      172 k\nInstalling for dependencies:\n libzstd                  x86_64      1.5.5-1.el7            epel         292 k\n postgresql15             x86_64      15.7-1PGDG.rhel7       pgdg15       1.6 M\n postgresql15-libs        x86_64      15.7-1PGDG.rhel7       pgdg15       286 k\n\nTransaction Summary\n================================================================================\nInstall  3 Packages (+3 Dependent packages)\n\nTotal download size: 8.3 M\nInstalled size: 35 M\nDownloading packages:\nPublic key for libzstd-1.5.5-1.el7.x86_64.rpm is not installed\nPublic key for postgresql15-libs-15.7-1PGDG.rhel7.x86_64.rpm is not installed\n--------------------------------------------------------------------------------\nTotal                                              925 kB/s | 8.3 MB  00:09     \nRetrieving key from file:///etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL7\nRetrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Installing : postgresql15-libs-15.7-1PGDG.rhel7.x86_64                    1/6 \n  Installing : libzstd-1.5.5-1.el7.x86_64                                   2/6 \n  Installing : postgresql15-15.7-1PGDG.rhel7.x86_64                         3/6 \n  Installing : postgresql15-server-15.7-1PGDG.rhel7.x86_64                  4/6 \n  Installing : python-psycopg2-2.5.1-4.el7.x86_64                           5/6 \n  Installing : unzip-6.0-24.el7_9.x86_64                                    6/6 \n  Verifying  : postgresql15-15.7-1PGDG.rhel7.x86_64                         1/6 \n  Verifying  : libzstd-1.5.5-1.el7.x86_64                                   2/6 \n  Verifying  : postgresql15-libs-15.7-1PGDG.rhel7.x86_64                    3/6 \n  Verifying  : postgresql15-server-15.7-1PGDG.rhel7.x86_64                  4/6 \n  Verifying  : unzip-6.0-24.el7_9.x86_64                                    5/6 \n  Verifying  : python-psycopg2-2.5.1-4.el7.x86_64                           6/6 \n\nInstalled:\n  postgresql15-server.x86_64 0:15.7-1PGDG.rhel7                                 \n  python-psycopg2.x86_64 0:2.5.1-4.el7                                          \n  unzip.x86_64 0:6.0-24.el7_9                                                   \n\nDependency Installed:\n  libzstd.x86_64 0:1.5.5-1.el7                                                  \n  postgresql15.x86_64 0:15.7-1PGDG.rhel7                                        \n  postgresql15-libs.x86_64 0:15.7-1PGDG.rhel7                                   \n\nComplete!\n"]}

TASK [PostgreSQL database init] ************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:39
changed: [master] => {"changed": true, "cmd": ["/usr/pgsql-15/bin/postgresql-15-setup", "initdb"], "delta": "0:00:00.889498", "end": "2024-06-23 23:00:54.998986", "rc": 0, "start": "2024-06-23 23:00:54.109488", "stderr": "", "stderr_lines": [], "stdout": "Initializing database ... OK", "stdout_lines": ["Initializing database ... OK"]}

TASK [Start postgres service] **************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:44
changed: [master] => {"changed": true, "enabled": true, "name": "postgresql-15", "state": "started", "status": {"ActiveEnterTimestampMonotonic": "0", "ActiveExitTimestampMonotonic": "0", "ActiveState": "inactive", "After": "systemd-journald.socket network-online.target basic.target syslog.target system.slice", "AllowIsolate": "no", "AmbientCapabilities": "0", "AssertResult": "no", "AssertTimestampMonotonic": "0", "Before": "shutdown.target", "BlockIOAccounting": "no", "BlockIOWeight": "18446744073709551615", "CPUAccounting": "no", "CPUQuotaPerSecUSec": "infinity", "CPUSchedulingPolicy": "0", "CPUSchedulingPriority": "0", "CPUSchedulingResetOnFork": "no", "CPUShares": "18446744073709551615", "CanIsolate": "no", "CanReload": "yes", "CanStart": "yes", "CanStop": "yes", "CapabilityBoundingSet": "18446744073709551615", "ConditionResult": "no", "ConditionTimestampMonotonic": "0", "Conflicts": "shutdown.target", "ControlPID": "0", "DefaultDependencies": "yes", "Delegate": "no", "Description": "PostgreSQL 15 database server", "DevicePolicy": "auto", "Documentation": "https://www.postgresql.org/docs/15/static/", "Environment": "PGDATA=/var/lib/pgsql/15/data/ PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj PG_OOM_ADJUST_VALUE=0", "ExecMainCode": "0", "ExecMainExitTimestampMonotonic": "0", "ExecMainPID": "0", "ExecMainStartTimestampMonotonic": "0", "ExecMainStatus": "0", "ExecReload": "{ path=/bin/kill ; argv[]=/bin/kill -HUP $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "ExecStart": "{ path=/usr/pgsql-15/bin/postmaster ; argv[]=/usr/pgsql-15/bin/postmaster -D ${PGDATA} ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "ExecStartPre": "{ path=/usr/pgsql-15/bin/postgresql-15-check-db-dir ; argv[]=/usr/pgsql-15/bin/postgresql-15-check-db-dir ${PGDATA} ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "FailureAction": "none", "FileDescriptorStoreMax": "0", "FragmentPath": "/usr/lib/systemd/system/postgresql-15.service", "Group": "postgres", "GuessMainPID": "yes", "IOScheduling": "0", "Id": "postgresql-15.service", "IgnoreOnIsolate": "no", "IgnoreOnSnapshot": "no", "IgnoreSIGPIPE": "yes", "InactiveEnterTimestampMonotonic": "0", "InactiveExitTimestampMonotonic": "0", "JobTimeoutAction": "none", "JobTimeoutUSec": "0", "KillMode": "mixed", "KillSignal": "2", "LimitAS": "18446744073709551615", "LimitCORE": "18446744073709551615", "LimitCPU": "18446744073709551615", "LimitDATA": "18446744073709551615", "LimitFSIZE": "18446744073709551615", "LimitLOCKS": "18446744073709551615", "LimitMEMLOCK": "65536", "LimitMSGQUEUE": "819200", "LimitNICE": "0", "LimitNOFILE": "4096", "LimitNPROC": "3904", "LimitRSS": "18446744073709551615", "LimitRTPRIO": "0", "LimitRTTIME": "18446744073709551615", "LimitSIGPENDING": "3904", "LimitSTACK": "18446744073709551615", "LoadState": "loaded", "MainPID": "0", "MemoryAccounting": "no", "MemoryCurrent": "18446744073709551615", "MemoryLimit": "18446744073709551615", "MountFlags": "0", "Names": "postgresql-15.service", "NeedDaemonReload": "no", "Nice": "0", "NoNewPrivileges": "no", "NonBlocking": "no", "NotifyAccess": "main", "OOMScoreAdjust": "-1000", "OnFailureJobMode": "replace", "PermissionsStartOnly": "no", "PrivateDevices": "no", "PrivateNetwork": "no", "PrivateTmp": "no", "ProtectHome": "no", "ProtectSystem": "no", "RefuseManualStart": "no", "RefuseManualStop": "no", "RemainAfterExit": "no", "Requires": "system.slice basic.target", "Restart": "no", "RestartUSec": "100ms", "Result": "success", "RootDirectoryStartOnly": "no", "RuntimeDirectoryMode": "0755", "SameProcessGroup": "no", "SecureBits": "0", "SendSIGHUP": "no", "SendSIGKILL": "yes", "Slice": "system.slice", "StandardError": "inherit", "StandardInput": "null", "StandardOutput": "journal", "StartLimitAction": "none", "StartLimitBurst": "5", "StartLimitInterval": "10000000", "StartupBlockIOWeight": "18446744073709551615", "StartupCPUShares": "18446744073709551615", "StatusErrno": "0", "StopWhenUnneeded": "no", "SubState": "dead", "SyslogLevelPrefix": "yes", "SyslogPriority": "30", "SystemCallErrorNumber": "0", "TTYReset": "no", "TTYVHangup": "no", "TTYVTDisallocate": "no", "TasksAccounting": "no", "TasksCurrent": "18446744073709551615", "TasksMax": "18446744073709551615", "TimeoutStartUSec": "0", "TimeoutStopUSec": "1h", "TimerSlackNSec": "50000", "Transient": "no", "Type": "notify", "UMask": "0022", "UnitFilePreset": "disabled", "UnitFileState": "disabled", "User": "postgres", "WatchdogTimestampMonotonic": "0", "WatchdogUSec": "0"}}

TASK [Set listen address for postgresql] ***************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:51
changed: [master] => {"backup": "", "changed": true, "msg": "line replaced"}

TASK [Modify pga_hba.conf] *****************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:57
changed: [master] => {"backup": "", "changed": true, "msg": "line replaced"}

TASK [Restart postgres service] ************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:63
changed: [master] => {"changed": true, "name": "postgresql-15", "state": "started", "status": {"ActiveEnterTimestamp": "Sun 2024-06-23 23:00:55 MSK", "ActiveEnterTimestampMonotonic": "297683771", "ActiveExitTimestampMonotonic": "0", "ActiveState": "active", "After": "systemd-journald.socket basic.target system.slice syslog.target network-online.target", "AllowIsolate": "no", "AmbientCapabilities": "0", "AssertResult": "yes", "AssertTimestamp": "Sun 2024-06-23 23:00:55 MSK", "AssertTimestampMonotonic": "297636158", "Before": "multi-user.target shutdown.target", "BlockIOAccounting": "no", "BlockIOWeight": "18446744073709551615", "CPUAccounting": "no", "CPUQuotaPerSecUSec": "infinity", "CPUSchedulingPolicy": "0", "CPUSchedulingPriority": "0", "CPUSchedulingResetOnFork": "no", "CPUShares": "18446744073709551615", "CanIsolate": "no", "CanReload": "yes", "CanStart": "yes", "CanStop": "yes", "CapabilityBoundingSet": "18446744073709551615", "ConditionResult": "yes", "ConditionTimestamp": "Sun 2024-06-23 23:00:55 MSK", "ConditionTimestampMonotonic": "297636158", "Conflicts": "shutdown.target", "ControlGroup": "/system.slice/postgresql-15.service", "ControlPID": "0", "DefaultDependencies": "yes", "Delegate": "no", "Description": "PostgreSQL 15 database server", "DevicePolicy": "auto", "Documentation": "https://www.postgresql.org/docs/15/static/", "Environment": "PGDATA=/var/lib/pgsql/15/data/ PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj PG_OOM_ADJUST_VALUE=0", "ExecMainCode": "0", "ExecMainExitTimestampMonotonic": "0", "ExecMainPID": "4130", "ExecMainStartTimestamp": "Sun 2024-06-23 23:00:55 MSK", "ExecMainStartTimestampMonotonic": "297652372", "ExecMainStatus": "0", "ExecReload": "{ path=/bin/kill ; argv[]=/bin/kill -HUP $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", "ExecStart": "{ path=/usr/pgsql-15/bin/postmaster ; argv[]=/usr/pgsql-15/bin/postmaster -D ${PGDATA} ; ignore_errors=no ; start_time=[Sun 2024-06-23 23:00:55 MSK] ; stop_time=[n/a] ; pid=4130 ; code=(null) ; status=0/0 }", "ExecStartPre": "{ path=/usr/pgsql-15/bin/postgresql-15-check-db-dir ; argv[]=/usr/pgsql-15/bin/postgresql-15-check-db-dir ${PGDATA} ; ignore_errors=no ; start_time=[Sun 2024-06-23 23:00:55 MSK] ; stop_time=[Sun 2024-06-23 23:00:55 MSK] ; pid=4125 ; code=exited ; status=0 }", "FailureAction": "none", "FileDescriptorStoreMax": "0", "FragmentPath": "/usr/lib/systemd/system/postgresql-15.service", "Group": "postgres", "GuessMainPID": "yes", "IOScheduling": "0", "Id": "postgresql-15.service", "IgnoreOnIsolate": "no", "IgnoreOnSnapshot": "no", "IgnoreSIGPIPE": "yes", "InactiveEnterTimestampMonotonic": "0", "InactiveExitTimestamp": "Sun 2024-06-23 23:00:55 MSK", "InactiveExitTimestampMonotonic": "297636827", "JobTimeoutAction": "none", "JobTimeoutUSec": "0", "KillMode": "mixed", "KillSignal": "2", "LimitAS": "18446744073709551615", "LimitCORE": "18446744073709551615", "LimitCPU": "18446744073709551615", "LimitDATA": "18446744073709551615", "LimitFSIZE": "18446744073709551615", "LimitLOCKS": "18446744073709551615", "LimitMEMLOCK": "65536", "LimitMSGQUEUE": "819200", "LimitNICE": "0", "LimitNOFILE": "4096", "LimitNPROC": "3904", "LimitRSS": "18446744073709551615", "LimitRTPRIO": "0", "LimitRTTIME": "18446744073709551615", "LimitSIGPENDING": "3904", "LimitSTACK": "18446744073709551615", "LoadState": "loaded", "MainPID": "4130", "MemoryAccounting": "no", "MemoryCurrent": "18446744073709551615", "MemoryLimit": "18446744073709551615", "MountFlags": "0", "Names": "postgresql-15.service", "NeedDaemonReload": "no", "Nice": "0", "NoNewPrivileges": "no", "NonBlocking": "no", "NotifyAccess": "main", "OOMScoreAdjust": "-1000", "OnFailureJobMode": "replace", "PermissionsStartOnly": "no", "PrivateDevices": "no", "PrivateNetwork": "no", "PrivateTmp": "no", "ProtectHome": "no", "ProtectSystem": "no", "RefuseManualStart": "no", "RefuseManualStop": "no", "RemainAfterExit": "no", "Requires": "basic.target system.slice", "Restart": "no", "RestartUSec": "100ms", "Result": "success", "RootDirectoryStartOnly": "no", "RuntimeDirectoryMode": "0755", "SameProcessGroup": "no", "SecureBits": "0", "SendSIGHUP": "no", "SendSIGKILL": "yes", "Slice": "system.slice", "StandardError": "inherit", "StandardInput": "null", "StandardOutput": "journal", "StartLimitAction": "none", "StartLimitBurst": "5", "StartLimitInterval": "10000000", "StartupBlockIOWeight": "18446744073709551615", "StartupCPUShares": "18446744073709551615", "StatusErrno": "0", "StopWhenUnneeded": "no", "SubState": "running", "SyslogLevelPrefix": "yes", "SyslogPriority": "30", "SystemCallErrorNumber": "0", "TTYReset": "no", "TTYVHangup": "no", "TTYVTDisallocate": "no", "TasksAccounting": "no", "TasksCurrent": "18446744073709551615", "TasksMax": "18446744073709551615", "TimeoutStartUSec": "0", "TimeoutStopUSec": "1h", "TimerSlackNSec": "50000", "Transient": "no", "Type": "notify", "UMask": "0022", "UnitFilePreset": "disabled", "UnitFileState": "enabled", "User": "postgres", "WantedBy": "multi-user.target", "WatchdogTimestamp": "Sun 2024-06-23 23:00:55 MSK", "WatchdogTimestampMonotonic": "297683737", "WatchdogUSec": "0"}}

TASK [Create database users] ***************************************************
task path: /home/dpp/Документы/Otus/otus-subd-2024-05/hw03/ansible/playbook.yml:68
redirecting (type: modules) ansible.builtin.postgresql_user to community.general.postgresql_user
redirecting (type: modules) community.general.postgresql_user to community.postgresql.postgresql_user
changed: [master] => (item={'name': 'otus_superuser', 'password': '12345', 'flags': 'SUPERUSER'}) => {"ansible_loop_var": "item", "changed": true, "item": {"flags": "SUPERUSER", "name": "otus_superuser", "password": "12345"}, "queries": ["CREATE USER \"otus_superuser\" WITH ENCRYPTED PASSWORD %(password)s SUPERUSER"], "user": "otus_superuser", "warnings": ["Module remote_tmp /var/lib/pgsql/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as another user. To avoid this, create the remote_tmp dir with the correct permissions manually"]}
[WARNING]: Module remote_tmp /var/lib/pgsql/.ansible/tmp did not exist and was
created with a mode of 0700, this may cause issues when running as another
user. To avoid this, create the remote_tmp dir with the correct permissions
manually
META: ran handlers
META: ran handlers

PLAY RECAP *********************************************************************
master                     : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0    Running ansible-playbook...
~~~

2.Создание клиента с подключением к базе данных postgres через командную строку.
~~~bash
vagrant ssh
sudo su postgres
cd
psql -c '\c'
~~~

```console
Last login: Sun Jun 23 23:00:57 2024 from 10.0.2.2
sudo su postgres
cd
psql -c '\c'
[vagrant@master ~]$ sudo su postgres
bash-4.2$ cd
bash-4.2$ psql -c '\c'
You are now connected to database "postgres" as user "postgres".
```

3.Подключение к серверу используя pgAdmin или другое аналогичное приложение: `DBeaver`
![img.png](pngs/img.png)

![img_1.png](pngs/img_1.png)

