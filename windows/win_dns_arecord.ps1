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

# validate state param
$state = Get-Attr $params "state"
If ($state -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: state"
}

# validate zone param
$zone = Get-Attr $params "zone"
If ($zone -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: zone"
}

# validate hostname param
$hostname = Get-Attr $params "hostname"
If ($hostname -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: hostname"
}

# validate ip param
$ip = Get-Attr $params "ip"
If ($ip -eq $FALSE)
{
    Fail-Json (New-Object psobject) "missing required argument: ip"
}

$ptr = Get-Attr $params "ptr"

# Verify all powershell modules exists
If (!(Get-Command Get-DnsServerResourceRecord ))
{
    Fail-Json (New-Object psobject) "Windows DNS server is not installed at this machine"
}

If (!(Get-Command Add-DnsServerResourceRecordA ))
{
    Fail-Json (New-Object psobject) "Windows DNS server is not installed at this machine"
}

If (!(Get-Command Remove-DnsServerResourceRecord ))
{
    Fail-Json (New-Object psobject) "Windows DNS server is not installed at this machine"
}

# JSON result setup
$result = New-Object psobject @{
    changed = $FALSE
}

# query existing record from DNS server
$dns_out = Get-DnsServerResourceRecord -ZoneName $zone -RRType A -name $hostname -erroraction 'silentlycontinue'

if ( $state.ToLower() -eq "present" )
{
    # Check if this is duplicated
    if (!$dns_out)
    {
        # adding new record
        If( $ptr -and $ptr -is [Boolean] )
        {
            Add-DnsServerResourceRecordA -Name $hostname -IPv4Address $ip -ZoneName $zone -CreatePtr
        }
        ElseIf ( $ptr -and $ptr.ToLower() -eq "true" )
        {
            # with PTR record
            Add-DnsServerResourceRecordA -Name $hostname -IPv4Address $ip -ZoneName $zone -CreatePtr
        }
        Else
        {
            # without PTR record
            Add-DnsServerResourceRecordA -Name $hostname -IPv4Address $ip -ZoneName $zone
        }
        $result.changed = $TRUE
    }
}

if ( $state.ToLower() -eq "absent" )
{
    # If the record exists
    if (!$dns_out)
    {
        $result.changed = $FALSE
    }
    else
    {
        # deleting the DNS A record
        Remove-DnsServerResourceRecord -ZoneName $zone -RRType A -Name $hostname -RecordData $ip -Confirm:$false -Force
        $result.changed = $TRUE
    }
}

Exit-Json $result
