<#
.SYNOPSIS
    An inventory script for local host.

.DESCRIPTION
    This script is designed to be run from the commandline.

    To use this script, run it like:
    custom_facts.ps1

    it should output a key value style of inventory items.

.EXAMPLE

    To test the local machine, execute with no parameters.

    custom_facts.ps1

.NOTES

    Script is designed to machine audit vaules and display in a KEY : VALUE format.
    Format is required for ansible to consume.
    Ansible will use output to consume inside its GATHER FACTS routine and extend the FACTS source from the local machine.

#>


#############################
##  Preferences Passed
#############################

#$errorActionPreference = "Continue"
$errorActionPreference = "Stop"
#$errorActionPreference = "SilentlyContinue"
$error.clear()

$DebugPreference = "SilentlyContinue"
# $DebugPreference = "Continue"

$VerbosePreference = "SilentlyContinue"
# $VerbosePreference = "Continue"
# $VerbosePreference = "Stop"
# $VerbosePreference = "Inquire"

# =====================
# Win32 Repository
# =====================

$Win32_ComputerSystem = Get-WMIObject Win32_ComputerSystem -Property *
$Win32_Bios = Get-WMIObject Win32_Bios -Property *
$Win32_SystemEnclosure = Get-WMIObject Win32_SystemEnclosure -Property *
$Win32_DiskDrive0 = Get-WMIObject Win32_DiskDrive -Filter 'Index = "0"'
$Win32_DiskDrive1 = Get-WMIObject Win32_DiskDrive -Filter 'Index = "1"'
$Win32_DiskDrive2 = Get-WMIObject Win32_DiskDrive -Filter 'Index = "2"'
$Win32_Processor = Get-WMIObject Win32_Processor -Property *
$Win32_PhysicalMemory = Get-WMIObject Win32_PhysicalMemory -Property *
$Win32_OperatingSystem = Get-WMIObject Win32_OperatingSystem -Property *
$Win32_NetworkAdapterConfiguration = Get-WMIObject Win32_NetworkAdapterConfiguration -Property * -Filter IPEnabled=true


# =====================
# Main
# =====================

$Name = $Win32_ComputerSystem.Name # WIN2016-1
$FullName = $Win32_ComputerSystem.Name + "." + $Win32_ComputerSystem.Domain

Write-Debug "Name: $Name"
Write-Debug "FullName: $FullName"

# =====================
# Configuration
# =====================

$IsVirtual = ($Win32_ComputerSystem.model -eq 'VMware Virtual Platform' -or ($Win32_ComputerSystem.model -eq 'Virtual Machine'))
$InDMZ = $null
$Make = $Win32_ComputerSystem.Manufacturer
$ModelID = $Win32_ComputerSystem.Model
$AssetTag = $Win32_SystemEnclosure.SMBIOSAssetTag
$SerialNumber = $Win32_Bios.SerialNumber
$ClusterMode = $null
$Environment = $null
$OSDomain = $Win32_ComputerSystem.Domain
$IPAddress = $Win32_NetworkAdapterConfiguration.IPAddress[0]
$BackupPolicy = $null
$HardwareRemote = $null
$Aliases = $null
$OperatingSystem = $Win32_OperatingSystem.Caption
$OSVersion = $Win32_OperatingSystem.Version
$OSServicePack = $Win32_OperatingSystem.BuildNumber
$editions = @{
    0 = 'Undefined'
    1 = 'Ultimate Edition'
    2 = 'Home Basic Edition'
    3 = 'Home Premium Edition'
    4 = 'Enterprise Edition'
    5 = 'Home Basic N Edition'
    6 = 'Business Edition'
    7 = 'Standard Server Edition'
    8 = 'Datacenter Server Edition'
    9 = 'Small Business Server Edition'
    10 = 'Enterprise Server Edition'
    11 = 'Starter Edition'
    12 = 'Datacenter Server Core Edition'
    13 = 'Standard Server Core Edition'
    14 = 'Enterprise Server Core Edition'
    15 = 'Enterprise Server Edition for Itanium-Based Systems'
    16 = 'Business N Edition'
    17 = 'Web Server Edition'
    18 = 'Cluster Server Edition'
    19 = 'Home Server Edition'
    20 = 'Storage Express Server Edition'
    21 = 'Storage Standard Server Edition'
    22 = 'Storage Workgroup Server Edition'
    23 = 'Storage Enterprise Server Edition'
    24 = 'Server For Small Business Edition'
    25 = 'Small Business Server Premium Edition'
    29 = 'Web Server, Server Core'
    39 = 'Datacenter Edition without Hyper-V, Server Core'
    40 = 'Standard Edition without Hyper-V, Server Core'
    41 = 'Enterprise Edition without Hyper-V, Server Core'
    42 = 'Hyper-V Server'
}


[int]$sku = $Win32_OperatingSystem.OperatingSystemSKU
$FormFactor = '{0}' -f $editions[$sku]
$RackUnit = $null
$RackPosition = $null
$ChassisSlot = $null
$PDUAPort = $null
$PDUBPort = $null


Write-Debug "Is Virtual: $IsVirtual " # true
Write-Debug "In DMZ: $InDMZ" # false
Write-Debug "Make: $Make" # VMware,Inc.
Write-Debug "Model ID: $ModelID" # VMware Virtual Platform
Write-Debug "Asset tag: $AssetTag" #
Write-Debug "Serial Number: $SerialNumber" # VMware-42 2d a2 df b9 31 85 67-f9 73 43 b7 ca 51 7c 0b
Write-Debug "Cluster Mode: $ClusterMode" # --None--
Write-Debug "Environment: $Environment" # PROD
Write-Debug "OS Domain: $OSDomain" # corp.auspost.local
Write-Debug "IP Address: $IPAddress" # 10.5.163.33
Write-Debug "Backup Policy: $BackupPolicy" # VM-DC1-MGT-c9100
Write-Debug "Hardware Remote: $HardwareRemote" #
Write-Debug "Aliases: $Aliases" # 
Write-Debug "Operating System: $OperatingSystem" # Windows 2016 Standard
Write-Debug "OS Version: $OSVersion" # 10.0.14393
Write-Debug "OS Service Pack: $OSServicePack" #
Write-Debug "Form factor: $FormFactor" # Server
Write-Debug "Rack units in use: $RackUnit" #
Write-Debug "Starting rack position: $RackPosition" #
Write-Debug "Chassis slot: $ChassisSlot" #
Write-Debug "PDU A port: $PDUAPort" #
Write-Debug "PDU B port: $PDUBPort" #

# =====================================
# PATCHING
# =====================================
# Write-Debug "Patching week: " # PROD
# Write-Debug "Patch window: " # Thursday 9PM
# Write-Debug "Snapshot required: " # Yes
# Write-Debug "Deployment tool: " # SCCM PROD POST
# Write-Debug "Exemption Reason: " #
# Write-Debug "Special instructions: " #
# Write-Debug "Phase: " # 2
# Write-Debug "Patching cycle: " # Monthly
# Write-Debug "Auto reboot: " # Yes
# Write-Debug "Date added: " # 19-06-2019
# Write-Debug "Last patch date: " # 29-04-2021

# =====================================
# DISK and CPU
# =====================================

$Disk1Name = $Win32_DiskDrive0.Name
$Disk1Size = $Win32_DiskDrive0.Size
$Disk1SizeGB = "{0:f2}" -f [math]::round($Disk1Size / 1GB)
$Disk2Name = $Win32_DiskDrive1.Name
$Disk2Size = $Win32_DiskDrive1.Size
$Disk2SizeGB = "{0:f2}" -f [math]::round($Disk2Size / 1GB)
$Disk3Name = $Win32_DiskDrive2.Name
$Disk3Size = $Win32_DiskDrive2.Size
$Disk3SizeGB = "{0:f2}" -f [math]::round($Disk3Size / 1GB)

Write-Debug "Disk 1 Name: $Disk1Name" # \\.\PHYSICALDRIVE1
Write-Debug "Disk 1 Size: $Disk1SizeGB" # 204797
Write-Debug "Disk 2 Name: $Disk2Name" # \\.\PHYSICALDRIVE0
Write-Debug "Disk 2 Size: $Disk2SizeGB" # 81917
Write-Debug "Disk 3 Name: $Disk3Name" # \\.\PHYSCIALDRIVE2
Write-Debug "Disk 3 Size: $Disk3SizeGB" # 61436
Write-Debug "Bitlocker: " #


$CPUManufacturer = $Win32_Processor.Manufacturer
$CPUCount = $Win32_Processor.NumberOfCores[0]
$CPUType = $Win32_Processor.Name[0]
$CPUCoreCount = $Win32_Processor.NumberOfCores[0]
$RamCapacity = $Win32_ComputerSystem.TotalPhysicalMemory
$Ram = "{0:f2}" -f [math]::round($RamCapacity / 1MB)
$RamGB = "{0:f2}" -f [math]::round($RamCapacity / 1GB)


Write-Debug "CPU Manufacturer: $CPUManufacturer" # GenuineIntel
Write-Debug "CPU count: $CPUCount" # 4
Write-Debug "CPU type: $CPUType" # Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GH
Write-Debug "CPU core count: $CPUCoreCount" # 1
Write-Debug "Ram (MB): $Ram" # 16,383
Write-Debug "RamGB (GB): $RamGB" # 16.38

# =====================================
# NETWORK
# =====================================

$Adapters_count = $Win32_NetworkAdapterConfiguration.count
Write-Debug "Adapter Count: $Adapters_count"

If ($Win32_NetworkAdapterConfiguration.Count -eq 2) {

    $NetAdapter1_DHCPEnabled = $Win32_NetworkAdapterConfiguration[0].DHCPEnabled
    $NetAdapter1_IPAddress = $Win32_NetworkAdapterConfiguration[0].IPAddress[0]
    $NetAdapter1_IPSubnet = $Win32_NetworkAdapterConfiguration[0].IPSubnet[0]
    $NetAdapter1_IPGateway = $Win32_NetworkAdapterConfiguration[0].DefaultIPGateway[0]
    $NetAdapter1_MACAddress = $Win32_NetworkAdapterConfiguration[0].IPAddress[1]

    Write-Debug "Network Adapter 1 DHCP Enabled: $NetAdapter1_DHCPEnabled" # false
    Write-Debug "Network Adapter 1 IP Address: $NetAdapter1_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 1 IP Subnet: $NetAdapter1_IPSubnet" # 255.255.255.0
    Write-Debug "Network Adapter 1 IP Gateway: $NetAdapter1_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 1 MAC Address: $NetAdapter1_MACAddress" # 00:50:56:AD:A3:A3

    $NetAdapter2_DHCPEnabled = $Win32_NetworkAdapterConfiguration[1].DHCPEnabled
    $NetAdapter2_IPAddress = $Win32_NetworkAdapterConfiguration[1].IPAddress[0]
    $NetAdapter2_IPSubnet = $Win32_NetworkAdapterConfiguration[1].IPSubnet[0]
    # $NetAdapter2_IPGateway = $Win32_NetworkAdapterConfiguration[1].DefaultIPGateway[0]
    $NetAdapter2_MACAddress = $Win32_NetworkAdapterConfiguration[1].IPAddress[1]

    Write-Debug "Network Adapter 2 DHCP Enabled: $NetAdapter2_DHCPEnabled" # false
    Write-Debug "Network Adapter 2 IP Address: $NetAdapter2_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 2 IP Subnet: $NetAdapter2_IPSubnet" # 255.255.255.0
    # Write-Debug "Network Adapter 2 IP Gateway: $NetAdapter2_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 2 MAC Address: $NetAdapter2_MACAddress" # 00:50:56:AD:A3:A3

    $NetAdapter3_DHCPEnabled = $null
    $NetAdapter3_IPAddress = $null
    $NetAdapter3_IPSubnet = $null
    # $NetAdapter3_IPGateway = $null
    $NetAdapter3_MACAddress = $null
    
    Write-Debug "Network Adapter 3 DHCP Enabled: $NetAdapter3_DHCPEnabled" # false
    Write-Debug "Network Adapter 3 IP Address: $NetAdapter3_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 3 IP Subnet: $NetAdapter3_IPSubnet" # 255.255.255.0
    # Write-Debug "Network Adapter 3 IP Gateway: $NetAdapter3_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 3 MAC Address: $NetAdapter3_MACAddress" # 00:50:56:AD:A3:A3

}
elseif ($Win32_NetworkAdapterConfiguration.Count -eq 3) {

    $NetAdapter1_DHCPEnabled = $Win32_NetworkAdapterConfiguration[0].DHCPEnabled
    $NetAdapter1_IPAddress = $Win32_NetworkAdapterConfiguration[0].IPAddress[0]
    $NetAdapter1_IPSubnet = $Win32_NetworkAdapterConfiguration[0].IPSubnet[0]
    $NetAdapter1_IPGateway = $Win32_NetworkAdapterConfiguration[0].DefaultIPGateway[0]
    $NetAdapter1_MACAddress = $Win32_NetworkAdapterConfiguration[0].IPAddress[1]

    Write-Debug "Network Adapter 1 DHCP Enabled: $NetAdapter1_DHCPEnabled" # false
    Write-Debug "Network Adapter 1 IP Address: $NetAdapter1_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 1 IP Subnet: $NetAdapter1_IPSubnet" # 255.255.255.0
    Write-Debug "Network Adapter 1 IP Gateway: $NetAdapter1_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 1 MAC Address: $NetAdapter1_MACAddress" # 00:50:56:AD:A3:A3

    $NetAdapter2_DHCPEnabled = $Win32_NetworkAdapterConfiguration[1].DHCPEnabled
    $NetAdapter2_IPAddress = $Win32_NetworkAdapterConfiguration[1].IPAddress[0]
    $NetAdapter2_IPSubnet = $Win32_NetworkAdapterConfiguration[1].IPSubnet[0]
    # $NetAdapter2_IPGateway = $Win32_NetworkAdapterConfiguration[1].DefaultIPGateway[0]
    $NetAdapter2_MACAddress = $Win32_NetworkAdapterConfiguration[1].IPAddress[1]

    Write-Debug "Network Adapter 2 DHCP Enabled: $NetAdapter2_DHCPEnabled" # false
    Write-Debug "Network Adapter 2 IP Address: $NetAdapter2_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 2 IP Subnet: $NetAdapter2_IPSubnet" # 255.255.255.0
    # Write-Debug "Network Adapter 2 IP Gateway: $NetAdapter2_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 2 MAC Address: $NetAdapter2_MACAddress" # 00:50:56:AD:A3:A3
    
    $NetAdapter3_DHCPEnabled = $Win32_NetworkAdapterConfiguration[2].DHCPEnabled
    $NetAdapter3_IPAddress = $Win32_NetworkAdapterConfiguration[2].IPAddress[0]
    $NetAdapter3_IPSubnet = $Win32_NetworkAdapterConfiguration[2].IPSubnet[0]
    # $NetAdapter3_IPGateway = $Win32_NetworkAdapterConfiguration[2].DefaultIPGateway[0]
    $NetAdapter3_MACAddress = $Win32_NetworkAdapterConfiguration[2].IPAddress[1]
    
    Write-Debug "Network Adapter 3 DHCP Enabled: $NetAdapter3_DHCPEnabled" # false
    Write-Debug "Network Adapter 3 IP Address: $NetAdapter3_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 3 IP Subnet: $NetAdapter3_IPSubnet" # 255.255.255.0
    # Write-Debug "Network Adapter 3 IP Gateway: $NetAdapter3_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 3 MAC Address: $NetAdapter3_MACAddress" # 00:50:56:AD:A3:A3
}
else {

    $NetAdapter1_DHCPEnabled = $Win32_NetworkAdapterConfiguration.DHCPEnabled
    $NetAdapter1_IPAddress = $Win32_NetworkAdapterConfiguration.IPAddress[0]
    $NetAdapter1_IPSubnet = $Win32_NetworkAdapterConfiguration.IPSubnet[0]
    $NetAdapter1_IPGateway = $Win32_NetworkAdapterConfiguration.DefaultIPGateway
    $NetAdapter1_MACAddress = $Win32_NetworkAdapterConfiguration.IPAddress[1]
    
    Write-Debug "Network Adapter 1 DHCP Enabled: $NetAdapter1_DHCPEnabled" # false
    Write-Debug "Network Adapter 1 IP Address: $NetAdapter1_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 1 IP Subnet: $NetAdapter1_IPSubnet" # 255.255.255.0
    Write-Debug "Network Adapter 1 IP Gateway: $NetAdapter1_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 1 MAC Address: $NetAdapter1_MACAddress" # 00:50:56:AD:A3:A3

    $NetAdapter2_DHCPEnabled = $null
    $NetAdapter2_IPAddress = $null
    $NetAdapter2_IPSubnet = $null
    # $NetAdapter2_IPGateway = $null
    $NetAdapter2_MACAddress = $null

    Write-Debug "Network Adapter 2 DHCP Enabled: $NetAdapter2_DHCPEnabled" # false
    Write-Debug "Network Adapter 2 IP Address: $NetAdapter2_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 2 IP Subnet: $NetAdapter2_IPSubnet" # 255.255.255.0
    # Write-Debug "Network Adapter 2 IP Gateway: $NetAdapter2_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 2 MAC Address: $NetAdapter2_MACAddress" # 00:50:56:AD:A3:A3

    $NetAdapter3_DHCPEnabled = $null
    $NetAdapter3_IPAddress = $null
    $NetAdapter3_IPSubnet = $null
    # $NetAdapter3_IPGateway = $null
    $NetAdapter3_MACAddress = $null
    
    Write-Debug "Network Adapter 3 DHCP Enabled: $NetAdapter3_DHCPEnabled" # false
    Write-Debug "Network Adapter 3 IP Address: $NetAdapter3_IPAddress" # 10.5.163.33
    Write-Debug "Network Adapter 3 IP Subnet: $NetAdapter3_IPSubnet" # 255.255.255.0
    # Write-Debug "Network Adapter 3 IP Gateway: $NetAdapter3_IPGateway" # 10.5.163.1
    Write-Debug "Network Adapter 3 MAC Address: $NetAdapter3_MACAddress" # 00:50:56:AD:A3:A3

}



$obj = [PSCustomObject][ordered]@{
    Name = $Win32_ComputerSystem.Name
    FullName = $Win32_ComputerSystem.Name + "." + $Win32_ComputerSystem.Domain
    IsVirtual = ($Win32_ComputerSystem.model -eq 'VMware Virtual Platform' -or ($Win32_ComputerSystem.model -eq 'Virtual Machine'))
    InDMZ = $null
    Make = $Win32_ComputerSystem.Manufacturer
    ModelID = $Win32_ComputerSystem.Model
    AssetTag = $Win32_SystemEnclosure.SMBIOSAssetTag
    SerialNumber = $Win32_Bios.SerialNumber
    ClusterMode = $null
    Environment = $null
    OSDomain = $Win32_ComputerSystem.Domain
    IPAddress = $Win32_NetworkAdapterConfiguration.IPAddress[0]
    BackupPolicy = $null
    HardwareRemote = $null
    Aliases = $null
    OperatingSystem = $Win32_OperatingSystem.Caption
    OSVersion = $Win32_OperatingSystem.Version
    OSServicePack = $Win32_OperatingSystem.BuildNumber
    FormFactor = '{0}' -f $editions[$sku]
    RackUnit = $null
    RackPosition = $null
    ChassisSlot = $null
    PDUAPort = $null
    PDUBPort = $null
    Disk1Name = $Win32_DiskDrive0.Name
    Disk1Size = $Win32_DiskDrive0.Size
    Disk1SizeGB = "{0:f2}" -f [math]::round($Disk1Size / 1GB)
    Disk2Name = $Win32_DiskDrive1.Name
    Disk2Size = $Win32_DiskDrive1.Size
    Disk2SizeGB = "{0:f2}" -f [math]::round($Disk2Size / 1GB)
    Disk3Name = $Win32_DiskDrive2.Name
    Disk3Size = $Win32_DiskDrive2.Size
    Disk3SizeGB = "{0:f2}" -f [math]::round($Disk3Size / 1GB)
    CPUManufacturer = $Win32_Processor.Manufacturer
    CPUCount = $Win32_Processor.NumberOfCores[0]
    CPUType = $Win32_Processor.Name[0]
    CPUCoreCount = $Win32_Processor.NumberOfCores[0]
    RamCapacity = $Win32_ComputerSystem.TotalPhysicalMemory
    Ram = "{0:f2}" -f [math]::round($RamCapacity / 1MB)
    RamGB = "{0:f2}" -f [math]::round($RamCapacity / 1GB)

    
    NetAdapter1_DHCPEnabled = $NetAdapter1_DHCPEnabled
    NetAdapter1_IPAddress = $NetAdapter1_IPAddress
    NetAdapter1_IPSubnet = $NetAdapter1_IPSubnet
    NetAdapter1_IPGateway = $NetAdapter1_IPGateway
    NetAdapter1_MACAddress = $NetAdapter1_MACAddress

    NetAdapter2_DHCPEnabled = $NetAdapter2_DHCPEnabled
    NetAdapter2_IPAddress = $NetAdapter2_IPAddress
    NetAdapter2_IPSubnet = $NetAdapter2_IPSubnet
    NetAdapter2_IPGateway = $null
    NetAdapter2_MACAddress = $NetAdapter2_MACAddress

    NetAdapter3_DHCPEnabled = $NetAdapter3_DHCPEnabled
    NetAdapter3_IPAddress = $NetAdapter3_IPAddress
    NetAdapter3_IPSubnet = $NetAdapter3_IPSubnet
    NetAdapter3_IPGateway = $null
    NetAdapter3_MACAddress = $NetAdapter3_MACAddress

}

$obj