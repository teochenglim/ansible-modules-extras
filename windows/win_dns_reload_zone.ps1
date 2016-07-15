#!powershell
# This file is part of Ansible
#
# Copyright 2016, Teo Cheng Lim <teochenglim@gmail.com>
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
#

# WANT_JSON
# POWERSHELL_COMMON

$ErrorActionPreference = "Stop"

$params = Parse-Args $args

# validate zone param
$zone = Get-Attr $params "zone"
If ($zone -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: zone"
}

# Verify all powershell modules exists
If (!(Get-Command dnscmd ))
{
    Fail-Json (New-Object psobject) "DNSCMD.exe is not installed at this machine"
}

# result
$result = New-Object psobject @{
    zone = New-Object psobject
    changed = $FALSE
}

# query existing record from DNS server
$zone_out = get-dnsserverzone -zonename $zone -erroraction 'silentlycontinue'

if (!$zone_out)
{
    dnscmd /zonereload $zone
    $result.changed = $TRUE
}
Set-Attr $result.zone "zone" "reload zone:$zone true:$TRUE"

Exit-Json $result
