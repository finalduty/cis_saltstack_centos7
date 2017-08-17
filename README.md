## CIS Saltstack States for CentOS 7

This repo provides state files for Saltstack which can help remediate issues for CIS Benchmark compliance. https://learn.cisecurity.org/benchmarks

It is recommended to use these states in conjunction with (finalduty/cis_benchmarks_audit)[https://github.com/finalduty/cis_benchmarks_audit]

_Please note that only CentOS 7 is supported at this time._

To include these on your own Salt Master, add this to your `/etc/salt/master` file:
```
gitfs_remotes:
  - https://github.com/finalduty/cis_saltstack_centos7.git:
    - mountpoint: cis
```

After reloading the master, you can then look at the states by running: `salt '*' state.apply cis test=True`