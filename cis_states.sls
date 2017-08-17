## andy.dustin@gmail.com [rev: a44f5c9]
## SaltStack states to help meet CIS CentOS 7 Linux Benchmarks

##
## Copyright 2017 Andy Dustin
##
## Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except 
## in compliance with the License. You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software distributed under the License is 
## distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and limitations under the License.
##

### Section 1 ###

## 1.1.1.x - Ensure mounting of filesystems is disabled
## 3.3.3 - Ensure IPv6 is disabled
## 3.5.x - Ensure <network_protocol> is disabled
/etc/modprobe.d/CIS.conf:
  file.managed:
#    - source: salt://{{ slspath }}/files/CIS.conf
    - source: salt://files/CIS.conf
    - user: root
    - group: root
    - mode: 644
    
## 1.1.3, 1.1.4, 1.1.5 - Ensure nodev, nosuid and noexec options set on /tmp partition
/tmp:
  mount.mounted:
    - device: tmpfs
    - fstype: tmpfs
    - opts: nodev,nosuid,noexec,size=512M,mode=777
    - dump: 0
    - pass_num: 0

## 1.1.15, 1.1.16, 1.1.17 - Ensure nodev, nosuid and noexec options set on /dev/shm partition
/dev/shm:
  mount.mounted:
    - device: tmpfs
    - fstype: tmpfs
    - opts: rw,nodev,nosuid,noexec,seclabel
    - dump: 0
    - pass_num: 0

## 1.3.1 - Ensure AIDE is installed
aide:
  pkg.installed
  
## 1.3.2 - Ensure filesystem integrity is regularly checked
/etc/cron.daily/aide:
  file.managed:
    - contents: /usr/sbin/aide --check
    
## 1.4.1 - Ensure permissions on /boot/grub2/grub.cfg are configured
/boot/grub2/grub.cfg:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - replace: False
    
## 1.5.1 - Ensure core dumps are restricted
/etc/security/limits.d/fs.suid_dumpable:
  file.managed:
    - content: "* hard core 0"

/etc/sysctl.d/fs.suid_dumpable:
  file.managed:
    - content: "fs.suid_dumpable = 0"
    
## 1.7.1.2 - Ensure local login warning banner is configured properly
/etc/issue:
  file.managed:
    - content: "Authorized users only. All activity may be monitored and reported."

## 1.7.1.3 - Ensure remote login warning banner is configured properly
/etc/issue.net:
  file.managed:
    - content: "Authorized users only. All activity may be monitored and reported."

### Section 3 ###

## 3.1.2 - Ensure packet redirect sending is disabled
## 3.2.1 - Ensure source routed packets are not accepted
## 3.2.3 - Ensure secure ICMP redirects are not accepted
{% for param in [ "send_redirects", "accept_source_route", "secure_redirects" ] %}
/etc/sysctl.d/{{ param }}:
  file.managed:
    - content: 
      - net.ipv4.conf.all.{{ param }} = 0
      - net.ipv4.conf.default.{{ param }} = 0
{% endfor %}

## 3.2.4 - Ensure suspicious packages are logged
/etc/sysctl.d/log_martians:
  file.managed:
    - content: 
      - net.ipv4.conf.all.log_martians = 1
      - net.ipv4.conf.default.log_martians = 1

## 3.2.2 - Ensure ICMP redirects are not accepted   
## 3.3.2 - Ensure IPv6 redirects are not accepted
/etc/sysctl.d/accept_redirects:
  file.managed:
    - content: 
      - net.ipv4.conf.all.accept_redirects = 0
      - net.ipv4.conf.default.accept_redirects = 0
      - net.ipv6.conf.all.accept_redirects = 0
      - net.ipv6.conf.default.accept_redirects = 0


## 3.3.1 - Ensure IPv6 router advertisements are not accepted
/etc/sysctl.d/accept_ra:
  file.managed:
    - content: 
      - net.ipv6.conf.all.accept_ra = 0
      - net.ipv6.conf.default.accept_ra = 0


## 5.1.2 - Ensure permissions on /etc/crontab are configured
/etc/crontab:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - replace: False

## 5.1.3 to 5.1.7 - Ensure permissions on /etc/cron* are configured
{% for dir in ["cron.hourly", "cron.daily", "cron.weekly", "cron.monthly", "cron.d" ] %}
/etc/{{ dir }}:
  file.directory:
    - user: root
    - group: root
    - mode: 700
{% endfor %}