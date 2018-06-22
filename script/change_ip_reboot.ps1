## Static IP 변경 함수 명시
 
Function Replace-NetIpAddress{
[cmdletbinding()]
Param(
    [int]$interfaceIndex,
    [IPaddress]$NewIp,
    [int]$Prefix,
    [IPaddress]$Gateway
)
 
$IpParams = @{}
 
$CurrentIpConf = Get-NetIPConfiguration -InterfaceIndex $interfaceIndex
 
if ($CurrentIpConf.IPv4Address.IPAddress -ne $NewIp){
 
 $IpParams.add('InterfaceIndex', $interfaceIndex)
 $IpParams.add('IPAddress',$NewIp)
 $IpParams.Add('PrefixLength' ,$Prefix)
 
    $Adapter = Get-NetAdapter -InterfaceIndex $interfaceIndex
    $Adapter | Remove-NetIPAddress -Confirm:$false | Out-Null
 
}else{
 
    Write-Warning "The ip $($NewIp) is already set."
 
}
 
 
if ($Gateway){
        $CurrentGateway = ($CurrentIpConf).Ipv4DefaultGateway.nexthop
    if ($CurrentGateway -ne $Gateway){
         
        Get-NetRoute -InterfaceIndex $interfaceIndex -NextHop $CurrentGateway | Remove-NetRoute -Confirm:$false
        $IpParams.add('DefaultGateway',$Gateway)
    }
     
    write-warning "Gateway $($Gateway) is already existing."
}
 
if ($IpParams.count -gt 0){
    New-NetIPAddress @IpParams
}else{
 
    Write-Warning "Ip configuration is identical as before"
}
 
}
 
 
 
## Softlayer 내의 Portable IP Pool에서 임의의 IP 할당
<추후 구현 예정>
 
 
## Static IP 변경 함수 실행
Replace-NetIpAddress 12 "192.168.56.121" 24 "192.168.56.1"
 
 
## Rebooting 수행
Restart-Computer
