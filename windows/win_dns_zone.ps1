#!powershell
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
#

# WANT_JSON
# POWERSHELL_COMMON

$ErrorActionPreference = "Stop"

$params = Parse-Args $args

# validate state param
$state = Get-Attr $params "state"
$state = $state.ToLower()
If ($state -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: state"
}
If ($state) {
    $state = $state.ToLower()
    If (($state -ne "present") -and ($state -ne "absent") -and ($state -ne "reload")) {
        Fail-Json (New-Object psobject) "state must be reload/present/absent , your value: $state"
    }
}

# validate zone param
$zone = Get-Attr $params "zone"
If ($zone -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: zone"
}

# Verify DNSCMD.exe binary modules exists
If (!(Get-Command dnscmd ))
{
    Fail-Json (New-Object psobject) "DNSCMD.exe is not found at this machine"
}

# Verify powershell DNS Server modules exists
If (!(Get-Command Add-DnsServerPrimaryZone ))
{
    Fail-Json (New-Object psobject) "Windows features DNS Server is not installed at this machine"
}

# result
$result = New-Object psobject @{
    zone = New-Object psobject
    changed = $FALSE
}

# query existing record from DNS server
$zone_out = get-dnsserverzone -zonename $zone -erroraction 'silentlycontinue'

Set-Attr $result.zone "zone 1" "zone:$zone state:$state"
if ($state -eq "reload")
{
    Set-Attr $result.zone "zone 2" "zone:$zone state:$state"
    if (!$zone_out)
    {
        Set-Attr $result.zone "zone 3" "zone:$zone state:$state"
        $result.changed = $FALSE
        Fail-Json (New-Object psobject) "No such zone at this server: $zone"
    }
    else
    {
        Set-Attr $result.zone "zone 3.5" "zone:$zone state:$state"
        dnscmd /zonereload $zone
        $result.changed = $TRUE
    }
}

if ($state -eq "present")
{
    Set-Attr $result.zone "zone 4" "zone:$zone state:$state"
    if(!$zone_out)
    {
        Set-Attr $result.zone "zone 5" "zone:$zone state:$state"
        Add-DnsServerPrimaryZone -Name $zone -ReplicationScope "Forest" -erroraction 'silentlycontinue'
    }
    else
    {
        Set-Attr $result.zone "zone 6" "zone:$zone state:$state"
        Remove-DnsServerZone $zone -force -erroraction 'silentlycontinue'
        Add-DnsServerPrimaryZone -Name $zone -ReplicationScope "Forest" -erroraction 'silentlycontinue'
    }
    $result.changed = $TRUE
}

if ($state -eq "absent")
{
    Set-Attr $result.zone "zone 7" "zone:$zone state:$state zone_out:$zone_out"
    if(!$zone_out)
    {
        $result.changed = $FALSE
    }
    else
    {
        Set-Attr $result.zone "zone 8" "zone:$zone state:$state"
        Remove-DnsServerZone $zone -force -erroraction 'silentlycontinue'
        $result.changed = $TRUE
    }
}

Set-Attr $result.zone "zone 9" "zone:$zone state:$state"

Exit-Json $result
