# Open5GS 5GC & UERANSIM 

**UERANSIM** <small>(pronounced "ju-i ræn sɪm")</small>, is the open source state-of-the-art 5G UE and RAN (gNodeB)
simulator. UE and RAN can be considered as a 5G mobile phone and a base station in basic terms. The project can be used for
testing 5G Core Network and studying 5G System.

UERANSIM introduces the world's first and only open source 5G-SA UE and gNodeB implementation.

## Build Open5GS and UERANSIM

Please refer to the following for building Open5GS and UERANSIM respectively.

 - Open5GS - https://open5gs.org/open5gs/docs/guide/01-quickstart/
 - UERANSIM - https://github.com/aligungr/UERANSIM/wiki/Installation

Install MongoDB on Open5GS 5GC C-Plane machine and it is not required to install on U-Plane machines. The installation steps are also available on the Open5GS link.

# Table of Contents

- [Overview of Open5GS 5GC & UERANSIM Architecture]()
- [Changes in configuration files of Open5GS 5GC and UERANSIM UE/RAN]()
    - [Overview and Changes in configuration files of Open5GS 5GC C-Plane]()
        - [Changes in configuration of multiple SMFs]()
    - [Overview and Changes in configuration files of Open5GS 5GC U-Plane1]()
    - [Overview and Changes in configuration files of Open5GS 5GC U-Plane2]()
    - [Overview and Changes in configuration files of UERANSIM UE/RAN]()
- [Network settings of Open5GS 5GC and UERANSIM UE/RAN]()
    - [Network settings of Open5GS 5GC U-Plane1]()
    - [Network settings of Open5GS 5GC U-Plane2]()
- [Run Open5Gs 5GC and UERANSIM UE/RAN]()
    - [Run Open5GS 5GC C-Plane]()
    - [Run Open5GS 5GC U-Plane1 & U-Plane2]()
    - [Run UERANSIM]()
        - [Start gNB]()
        - [Start UE (UE0)]()
    - [Ping google.com]()
        - [Case for going through DN 10.45.0.0/16]()

# Overview of Open5GS 5GC & UERANSIM Architecture

The following explains the set up for the network
    - C-Plane (5G Core) set up with multiple SMFs in VM1
    - UE/RAN (UE and gNodeB) in VM2 with multiples of each
    - U-Plane1 set up in VM3
    - U-Plane2 set up in VM4

The Architecture is as follows 

![UERANSIM architecture](https://github.com/GurunagSai/5G-Stand-Alone-system-using-Open5GS-and-UERANSIM/assets/46021672/60ca6223-f48e-4a59-9b4c-ab8cab0f6d16)



Each VMs are as follows
| VM # | SW & Role | IP address | OS | Memory (Min) | HDD (Min) |
| --- | --- | --- | --- | --- | --- |
| VM1 | Open5GS 5GC C-Plane | 192.168.0.4 | Ubuntu 22.04 | 1GB | 20GB |
| VM2 | UE&RAN (gNodeB & UEs) | 192.168.0.6 | Ubuntu 22.04 | 1GB | 10GB |
| VM3 | Open5GS 5GC U-Plane1  | 192.168.0.7 | Ubuntu 22.04 | 1GB | 20GB |
| VM4 | Open5GS 5GC U-Plane2  | 192.168.0.9 | Ubuntu 22.04 | 1GB | 20GB |

Subscriber Information (other information is the same) is as follows. These User informations were registered with Open5GS WebUI

| UE # |	IMSI |	DNN	 |  OP/OPc  |
| --- | --- | --- | --- |
| UE0 | 901701234567890 |	internet | OPc |
| UE1 |	901701234567891 | internet2	 | OPc |
| UE2 | 901701234567892 | voip | OPc |
| UE3 | 901701234567893 | voip2	| OPc |

Each DNs are as follows.

| DN | TUNnel interface of DN |	APN/DNN	| TUNnel interface of UE | U-Plane # |
| --- | --- | --- | --- | --- |
| 10.45.0.0/16 | ogstun | internet | uesimtun0 | U-Plane1 |
| 10.46.0.0/16 | ogstun2 | internet2 | uesimtun1 | U-Plane1 |
| 10.55.0.0/16 | ogstun3 | voip | uesimtun2 | U-Plane2 |
| 10.56.0.0/16 | ogstun4 | voip2 | uesimtun3 | U-Plane2 |

## Changes in configuration files of Open5GS 5GC and UERANSIM UE/RAN

Please refer to the following for building Open5GS and UERANSIM respectively.

    - Open5GS - (Our link for Open5GS)
    - UERANSIM - (Link)

## Overview and Changes in configuration files of Open5GS 5GC C-Plane

The Basic Control Plane consists of AMF, NSSF, NRF, UDM, PCF, NEF, AUSF, SMF and each of them perform their respective tasks. Here in our architecture we have small changes where SMF is more than one. We have four SMFs and each with dedicated APN/DNN.

Starting with AMF configuration changes.
Note : Only the changes are mentioned here

- `amf.yaml`
~~~
amf:
    sbi:
      - addr: 127.0.0.5
        port: 7777
    ngap:
      - addr: 192.168.0.4
    metrics:
        addr: 127.0.0.5
        port: 9090
    guami:
      - plmn_id:
          mcc: 901
          mnc: 70
        amf_id:
          region: 2
          set: 1
    tai:
      - plmn_id:
          mcc: 901
          mnc: 70
        tac: 1
    plmn_support:
      - plmn_id:
          mcc: 901
          mnc: 70
        s_nssai:
          - sst: 1
      - plmn_id:
          mcc: 901
          mnc: 70
        s_nssai:
          - sst: 1
            sd: 000001
      - plmn_id:
          mcc: 901
          mnc: 70
        s_nssai:
          - sst: 1
            sd: 000002
      - plmn_id:
          mcc: 901
          mnc: 70
        s_nssai:
          - sst: 2
            sd: 000001
      - plmn_id:
          mcc: 901
          mnc: 70
        s_nssai:
          - sst: 2
            sd: 000002
~~~

- `nssf.yaml`
~~~
nssf:
    sbi:
      - addr: 127.0.0.14
        port: 7777
    nsi:
      - addr: 127.0.0.10
        port: 7777
        s_nssai:
          sst: 1
          sd: 000001
      - addr: 127.0.0.10
        port: 7777
        s_nssai:
          sst: 1
          sd: 000002
      - addr: 127.0.0.10
        port: 7777
        s_nssai:
          sst: 2
          sd: 000001
      - addr: 127.0.0.10
        port: 7777
        s_nssai:
          sst: 2
          sd: 000002
~~~

## Changes in configuration of multiple SMFs

As mentioned we have multiple SMFs, in order to achieve the SMF concept, we have initialized IP subnets for each SMF respectively mentioned as below:

| SMFs # | freeDiameter | IP Address | SST | SD | APN |
| --- | ---| --- | --- | --- | --- |
| SMF1 | smf.conf | 192.168.0.21 | 1 | 1 | Internet |
| SMF2 | smf1.conf | 192.168.0.22 | 1 | 2 | Internet2 |
| SMF3 |  smf2.conf | 192.168.0.23 | 2 | 1 | voip |
| SMF4 | smf3.conf | 192.168.0.24 | 2 | 2 | 2voip2 |


- `smf.yaml`
~~~
smf:
    sbi:
      - addr: 127.0.0.31
        port: 7777
    pfcp:
      - addr: 192.168.0.21
    gtpc:
      - addr: 127.0.0.31
    gtpu:
      - addr: 192.168.0.21
    metrics:
        addr: 127.0.0.31
        port: 9090
    subnet:
      - addr: 10.45.0.1/16
        dnn: internet
    dns:
      - 8.8.8.8
      - 8.8.4.4
      - 2001:4860:4860::8888
      - 2001:4860:4860::8844
    mtu: 1400
    ctf:
      enabled: auto
    freeDiameter: /etc/freeDiameter/smf.conf
    info:
      - s_nssai:
          - sst: 1
            sd: 000001
            dnn:
              - internet
~~~
freeDiameter file used in smf.yaml - `smf.conf`
~~~
ListenOn = "127.0.0.31"
~~~
- `smf2.yaml`
~~~
smf:
    sbi:
      - addr: 127.0.0.32
        port: 7777
    pfcp:
      - addr: 192.168.0.22
    gtpc:
      - addr: 127.0.0.32
    gtpu:
      - addr: 192.168.0.22
    metrics:
        addr: 127.0.0.32
        port: 9090
    subnet:
      - addr: 10.46.0.1/16
        dnn: internet2
    dns:
      - 8.8.8.8
      - 8.8.4.4
      - 2001:4860:4860::8888
      - 2001:4860:4860::8844
    mtu: 1400
    ctf:
      enabled: auto
    freeDiameter: /etc/freeDiameter/smf2.conf
    info:
      - s_nssai:
          - sst: 1
            sd: 000002
            dnn:
              - internet2
~~~
freeDiameter file used in smf2.yaml - `smf2.conf`
~~~
ListenOn = "127.0.0.32"
~~~
- `smf3yaml`
~~~
smf:
    sbi:
      - addr: 127.0.0.33
        port: 7777
    pfcp:
      - addr: 192.168.0.23
    gtpc:
      - addr: 127.0.0.33
    gtpu:
      - addr: 192.168.0.23
    metrics:
        addr: 127.0.0.33
        port: 9090
    subnet:
      - addr: 10.55.0.1/16
        dnn: voip
    dns:
      - 8.8.8.8
      - 8.8.4.4
      - 2001:4860:4860::8888
      - 2001:4860:4860::8844
    mtu: 1400
    ctf:
      enabled: auto
    freeDiameter: /etc/freeDiameter/smf3.conf
    info:
      - s_nssai:
          - sst: 2
            sd: 000001
            dnn:
              - voip
~~~
freeDiameter file used in smf3.yaml - `smf3.conf`
~~~
ListenOn = "127.0.0.33"
~~~
- `smf4.yaml`
~~~
smf:
    sbi:
      - addr: 127.0.0.34
        port: 7777
    pfcp:
      - addr: 192.168.0.24
    gtpc:
      - addr: 127.0.0.34
    gtpu:
      - addr: 192.168.0.24
    metrics:
        addr: 127.0.0.34
        port: 9090
    subnet:
      - addr: 10.56.0.1/16
        dnn: voip2
    dns:
      - 8.8.8.8
      - 8.8.4.4
      - 2001:4860:4860::8888
      - 2001:4860:4860::8844
    mtu: 1400
    ctf:
      enabled: auto
    freeDiameter: /etc/freeDiameter/smf4.conf
    info:
      - s_nssai:
          - sst: 2
            sd: 000002
            dnn:
              - voip2
~~~
freeDiameter file used in smf4.yaml - `smf4.conf`
~~~
ListenOn = "127.0.0.34"
~~~
## Overview and Changes in configuration files of Open5GS 5GC U-Plane1
~~~
upf:
    pfcp:
      - addr: 192.168.0.7
    gtpu:
      - addr: 192.168.0.7
    subnet:
      - addr: 10.45.0.1/16
        dnn: internet
        dev: ogstun
      - addr: 10.46.0.1/16
        dnn: internet2
        dev: ogstun2
~~~

## Overview and Changes in configuration files of Open5GS 5GC U-Plane2
~~~
upf:
    pfcp:
      - addr: 192.168.0.9
    gtpu:
      - addr: 192.168.0.9
    subnet:
      - addr: 10.55.0.1/16
        dnn: voip
        dev: ogstun3
      - addr: 10.56.0.1/16
        dnn: voip2
        dev: ogstun4
~~~

## Overview and Changes in configuration files of UERANSIM UE/RAN

Changes in configuration files of RAN (gNB)
~~~
mcc: '901'          # Mobile Country Code value
mnc: '70'           # Mobile Network Code value (2 or 3 digits)

nci: '0x000000010'  # NR Cell Identity (36-bit)
idLength: 32        # NR gNB ID length in bits [22...32]
tac: 1              # Tracking Area Code

linkIp: 192.168.0.6   # gNB's local IP address for Radio Link Simulation (Usually same with local IP)
ngapIp: 192.168.0.6   # gNB's local IP address for N2 Interface (Usually same with local IP)
gtpIp: 192.168.0.6   # gNB's local IP address for N3 Interface (Usually same with local IP)

# List of AMF address information
amfConfigs:
#  - address: 10.0.2.15
   - address: 192.168.0.4
     port: 38412

# List of supported S-NSSAIs by this gNB
slices:
  - sst: 1
    sd: 1
  - sst: 1
    sd: 2
  - sst: 2
    sd: 1
  - sst: 2
    sd: 2

~~~

## Changes in configuration files of UE0 (IMSI-901701234567890)
~~~
# IMSI number of the UE. IMSI = [MCC|MNC|MSISDN] (In total 15 digits)
supi: 'imsi-901701234567890'
# Mobile Country Code value of HPLMN
mcc: '901'
# Mobile Network Code value of HPLMN (2 or 3 digits)
mnc: '70'

# Permanent subscription key
key: '112233445566778899aabbccddeeff00'
# Operator code (OP or OPC) of the UE
op: '0102030405060708090a0b0c0d0e0f00'
# This value specifies the OP type and it can be either 'OP' or 'OPC'
opType: 'OPC'
# Authentication Management Field (AMF) value
amf: '8000'
# IMEI number of the device. It is used if no SUPI is provided
imei: '356938035643800'
# IMEISV number of the device. It is used if no SUPI and IMEI is provided
imeiSv: '4370816125816151'

# List of gNB IP addresses for Radio Link Simulation
gnbSearchList:
#  - 10.0.2.15
   - 192.168.0.6
# UAC Access Identities Configuration
uacAic:
  mps: false
  mcs: false

# UAC Access Control Class
uacAcc:
  normalClass: 0
  class11: false
  class12: false
  class13: false
  class14: false
  class15: false

# Initial PDU sessions to be established
sessions:
  - type: 'IPv4'
    apn: 'internet'
    slice:
      sst: 1
      sd: 000001

# Configured NSSAI for this UE by HPLMN
configured-nssai:
  - sst: 1
    sd: 000001

# Default Configured NSSAI for this UE
default-nssai:
  - sst: 1
    sd: 000001
~~~

## Changes in configuration files of UE1 (IMSI-901701234567891)
~~~
# IMSI number of the UE. IMSI = [MCC|MNC|MSISDN] (In total 15 digits)
supi: 'imsi-901701234567891'
# Mobile Country Code value of HPLMN
mcc: '901'
# Mobile Network Code value of HPLMN (2 or 3 digits)
mnc: '70'

# Permanent subscription key
key: '112233445566778899aabbccddeeff01'
# Operator code (OP or OPC) of the UE
op: '0102030405060708090a0b0c0d0e0f01'
# This value specifies the OP type and it can be either 'OP' or 'OPC'
opType: 'OPC'
# Authentication Management Field (AMF) value
amf: '8000'
# IMEI number of the device. It is used if no SUPI is provided
imei: '356938035643801'
# IMEISV number of the device. It is used if no SUPI and IMEI is provided
imeiSv: '4370816125816151'

# List of gNB IP addresses for Radio Link Simulation
gnbSearchList:
#  - 10.0.2.15
   - 192.168.0.6
# UAC Access Identities Configuration
uacAic:
  mps: false
  mcs: false

# UAC Access Control Class
uacAcc:
  normalClass: 0
  class11: false
  class12: false
  class13: false
  class14: false
  class15: false

# Initial PDU sessions to be established
sessions:
  - type: 'IPv4'
    apn: 'internet2'
    slice:
      sst: 1
      sd: 000002

# Configured NSSAI for this UE by HPLMN
configured-nssai:
  - sst: 1
    sd: 000002

# Default Configured NSSAI for this UE
default-nssai:
  - sst: 1
    sd: 000002
~~~
## Changes in configuration files of UE2 (IMSI-901701234567892)
~~~
# IMSI number of the UE. IMSI = [MCC|MNC|MSISDN] (In total 15 digits)
supi: 'imsi-901701234567892'
# Mobile Country Code value of HPLMN
mcc: '901'
# Mobile Network Code value of HPLMN (2 or 3 digits)
mnc: '70'

# Permanent subscription key
key: '112233445566778899aabbccddeeff02'
# Operator code (OP or OPC) of the UE
op: '0102030405060708090a0b0c0d0e0f02'
# This value specifies the OP type and it can be either 'OP' or 'OPC'
opType: 'OPC'
# Authentication Management Field (AMF) value
amf: '8000'
# IMEI number of the device. It is used if no SUPI is provided
imei: '356938035643802'
# IMEISV number of the device. It is used if no SUPI and IMEI is provided
imeiSv: '4370816125816151'

# List of gNB IP addresses for Radio Link Simulation
gnbSearchList:
#  - 10.0.2.15
   - 192.168.0.6
# UAC Access Identities Configuration
uacAic:
  mps: false
  mcs: false

# UAC Access Control Class
uacAcc:
  normalClass: 0
  class11: false
  class12: false
  class13: false
  class14: false
  class15: false

# Initial PDU sessions to be established
sessions:
  - type: 'IPv4'
    apn: 'voip'
    slice:
      sst: 2
      sd: 000001

# Configured NSSAI for this UE by HPLMN
configured-nssai:
  - sst: 2
    sd: 000001

# Default Configured NSSAI for this UE
default-nssai:
  - sst: 2
    sd: 000001
~~~
## Changes in configuration files of UE3 (IMSI-901701234567893)
~~~
# IMSI number of the UE. IMSI = [MCC|MNC|MSISDN] (In total 15 digits)
supi: 'imsi-901701234567893'
# Mobile Country Code value of HPLMN
mcc: '901'
# Mobile Network Code value of HPLMN (2 or 3 digits)
mnc: '70'

# Permanent subscription key
key: '112233445566778899aabbccddeeff03'
# Operator code (OP or OPC) of the UE
op: '0102030405060708090a0b0c0d0e0f03'
# This value specifies the OP type and it can be either 'OP' or 'OPC'
opType: 'OPC'
# Authentication Management Field (AMF) value
amf: '8000'
# IMEI number of the device. It is used if no SUPI is provided
imei: '356938035643803'
# IMEISV number of the device. It is used if no SUPI and IMEI is provided
imeiSv: '4370816125816151'

# List of gNB IP addresses for Radio Link Simulation
gnbSearchList:
#  - 10.0.2.15
   - 192.168.0.6
# UAC Access Identities Configuration
uacAic:
  mps: false
  mcs: false

# UAC Access Control Class
uacAcc:
  normalClass: 0
  class11: false
  class12: false
  class13: false
  class14: false
  class15: false

# Initial PDU sessions to be established
sessions:
  - type: 'IPv4'
    apn: 'voip2'
    slice:
      sst: 2
      sd: 000002

# Configured NSSAI for this UE by HPLMN
configured-nssai:
  - sst: 2
    sd: 000002

# Default Configured NSSAI for this UE
default-nssai:
  - sst: 2
    sd: 000002
~~~

# Network settings of Open5GS 5GC and UERANSIM UE/RAN

## Network settings of Open5GS 5GC C-Plane
First, uncomment the next line in the /etc/sysctl.conf file and reflect it in the OS.
~~~
net.ipv4.ip_forward=1
~~~
~~~
# sysctl -p
~~~
## Network settings of Open5GS 5GC U-Plane1

~~~
net.ipv4.ip_forward=1
~~~
~~~
# sysctl -p
~~~
Next, configure the TUNnel interface and NAPT.
~~~
ip tuntap add name ogstun mode tun
ip addr add 10.45.0.1/16 dev ogstun
ip link set ogstun up

iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE

ip tuntap add name ogstun2 mode tun
ip addr add 10.46.0.1/16 dev ogstun2
ip link set ogstun2 up

iptables -t nat -A POSTROUTING -s 10.46.0.0/16 ! -o ogstun2 -j MASQUERADE
~~~

## Network settings of Open5GS 5GC U-Plane2

~~~
net.ipv4.ip_forward=1
~~~
~~~
# sysctl -p
~~~
Next, configure the TUNnel interface and NAPT.
~~~
ip tuntap add name ogstun3 mode tun
ip addr add 10.55.0.1/16 dev ogstun3
ip link set ogstun3 up

iptables -t nat -A POSTROUTING -s 10.55.0.0/16 ! -o ogstun -j MASQUERADE

ip tuntap add name ogstun4 mode tun
ip addr add 10.56.0.1/16 dev ogstun4
ip link set ogstun4 up

iptables -t nat -A POSTROUTING -s 10.56.0.0/16 ! -o ogstun2 -j MASQUERADE
~~~

## Run Open5GS 5GC and UERANSIM UE/RAN
Run the 5GC, then UERANISM (UE & RAN implementation).

## Run Open5GS 5GC C-Plane
Run Open5GS 5GC C-Plane.

[Enter commands to run]

## Run Open5GS 5GC U-Plane1 & U-Plane2
Run Open5GS 5GC U-Plane1
[Commands]

Run Open5GS 5GC U-Plane2
[Commands to run]

## Run UERANSIM

First, do an NG Setup between gNodeB and 5GC, then register the UE with 5GC and establish a PDU session.

### Start gNB

Start gNB as follows.

/mobcom-project-bobcom/Project Output/UERANSIM+Open5GS/UE0/ueran-gnb.png

Start UE (UE0)

/mobcom-project-bobcom/Project Output/UERANSIM+Open5GS/UE0/ueran-ue.png

Ping test


[ping image]

## Configuration of Data Network
    ## OwnCast

    ## NextCloud
