#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright 2016, Teo Cheng Lim <teochenglim@gmail.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.


DOCUMENTATION = '''
---
module: win_dns_arecord
version_added: "1.0.0"
short_description: Creates Windows DNS Server A record and PTR record.
description:
     - Creates new DNS A record and optionally create PTR record.
notes:
    - See also M(win_dns_reload_zone)
requirements: [ ]
author: "Teo Cheng Lim (teochenglim@gmail.com)"
options:
  state:
    description:
      - State of the package on the system
    required: false
    choices:
      - present
      - absent
    default: present
  zone:
    description:
      - 'Create DNS at the existing zone, for example if FQND is abc.example.com, then this is example.com'
    required: true
    default: []
  hostname:
    description:
      - 'The hostname for example if FQND is abc.example.com, then this is abc'
    required: true
    default: []
  ip:
    description:
      - 'The ip address for example, 192.168.0.15'
    required: true
    default: []
  ptr:
    description:
      - 'Also create the PTR record at the same time?'
    required: false
    choices:
      - true
      - false
    default: false
'''

EXAMPLES = '''
#
# Create a DNS A record at local server (Not remote machine)
# The zone must exists first, for example "example.com"
# To create a DNS A record with abc.example.com with ip of 192.168.0.15
- win_dns_a: state="present" zone="example.com" hostname="abc" ip="192.168.0.15"
# To create a DNS A record with abc.xyz.example.com with ip of 192.168.0.15
- win_dns_arecord: state="present" zone="example.com" hostname="abc.xyz" ip="192.168.0.15"
#
#
# Remove a DNS A record at local server (Not remote machine)
# The zone must exists first, for example "example.com"
# To remove a DNS A record with abc.example.com with ip of 192.168.0.15
- win_dns_a: state="absent" zone="example.com" hostname="abc" ip="192.168.0.15"
# To remove a DNS A record with abc.xyz.example.com with ip of 192.168.0.15
- win_dns_arecord: state="absent" zone="example.com" hostname="abc.xyz" ip="192.168.0.15"
#
#
# Create a DNS A record at local server
# The zone must exists first "example.com" with reverse lookup (PTR record)
# To create a DNS A record with abc.example.com with ip of 192.168.0.15 with PTR record
# If a PTR is created together, when remove, it will be removed at the same time
- win_dns_arecord: zone="example.com" hostname="abc" ip="192.168.0.15" ptr="true"
'''
