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
module: win_dns_add
version_added: "1.0.0"
short_description: Reload a windows DNS zone (After added/edited/deleted IP).
description:
     - reload a windows DNS zone (After added/edited/deleted IP).
notes:
    - See also M(win_dns_arecord)
requirements: [ ]
author: "Teo Cheng Lim (teochenglim@gmail.com)"
options:
  zone:
    description:
      - 'Reload DNS zone, for example if FQND is abc.example.com, then this is example.com'
    required: true
    default: []
'''

EXAMPLES = '''
#
# Create a DNS record at local server
# The zone must exists first, example "example.com"
# To reload a windows DNS zone (After added/edited/deleted IP).
- win_dns_reload_zone: zone="example.com"
'''
