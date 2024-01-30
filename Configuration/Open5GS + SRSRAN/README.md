# Open5GS 5GC & srsRAN 
It is an open-source project that provides 5G mobile packet core network functionalities with an AGPLv3 or commercial license. It can be used to build private 5G telecom networks by individuals or telecom network operators.

## srsRAN
srsRAN is a free and open source 4G and 5G software radio suite. Featuring both UE and eNodeB/gNodeB applications, srsRAN can be used with third-party core network solutions to build complete end-to-end mobile wireless networks.


## Build Open5GS and srsRAN

Please refer to the following for building Open5GS and UERANSIM respectively.

 - Open5GS - https://open5gs.org/open5gs/docs/guide/02-building-open5gs-from-sources/
 - srsRAN - https://docs.srsran.com/projects/4g/en/latest/app_notes/source/5g_sa_E2E/source/index.html

Install MongoDB on Open5GS 5GC machine. The installation steps are also available on the Open5GS link.

# Table of Contents

- [Overview of Open5GS 5GC & srsRAN Architecture](#Overview)
  - [Changes in configuration of Open5GS 5GC](#5GC)
  - [Changes in configuration of srsRAN](#SrsRAN)
- [Network settings of Open5GS 5GC and srsRAN](#Networksrsran)
- [Run Open5GS and srsRAN](#Run)
  - [Start eNB](#Startenb)
  - [Start UE (UE0)](#Startue)
- [Ping google.com](#Testing)

<h2 id="Overview"> Overview of Open5GS 5GC & srsRAN Architecture</h2>
The following architecture has been set up in a single VM.

![SRSRAN Architecture](https://user-images.githubusercontent.com/46021672/221928853-5ef08f65-d322-41f9-851d-ee593505d6a8.png)

<h2 id="5GC"> Changes in configuration of Open5GS 5GC </h2> 

### AMF section
~~~
amf:
    sbi:
      - addr: 127.0.0.5
        port: 7777
    ngap:
      - addr: 127.0.0.2
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
        tac: 7
    plmn_support:
      - plmn_id:
          mcc: 901
          mnc: 70
        s_nssai:
          - sst: 1
    security:
        integrity_order : [ NIA2, NIA1, NIA0 ]
        ciphering_order : [ NEA0, NEA1, NEA2 ]
    network_name:
        full: Open5GS
    amf_name: open5gs-amf0
~~~
### UPF Section
~~~
upf:
    pfcp:
      - addr: 127.0.0.7
    gtpu:
      - addr: 127.0.0.2
    subnet:
      - addr: 10.45.0.1/16
      - addr: 2001:db8:cafe::1/48
    metrics:
      - addr: 127.0.0.7
        port: 9090
~~~
### SMF Section
~~~
smf:
    sbi:
      - addr: 127.0.0.4
        port: 7777
    pfcp:
      - addr: 127.0.0.4
    gtpc:
      - addr: 127.0.0.4
      - addr: ::1
    gtpu:
      - addr: 127.0.0.4
      - addr: ::1
    metrics:
      addr: 127.0.0.4
      port: 9090
    subnet:
      - addr: 10.45.0.1/16
      - addr: 2001:db8:cafe::1/48
    dns:
      - 8.8.8.8
      - 8.8.4.4
      - 2001:4860:4860::8888
      - 2001:4860:4860::8844
    mtu: 1400
    freeDiameter:
      identity: smf.localdomain
      realm: localdomain
      listen_on: 127.0.0.4
      no_fwd: true
      load_extension:
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dbg_msg_dumps.fdx
          conf: 0x8888
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dict_rfc5777.fdx
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dict_mip6i.fdx
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dict_nasreq.fdx
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dict_nas_mipv6.fdx
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dict_dcca.fdx
        - module: /home/mobcom1/open5gs/build/subprojects/freeDiameter/extensions/dict_dcca_3gpp/dict_dcca_3gpp.fdx
      connect:
        - identity: pcrf.localdomain
          addr: 127.0.0.9
~~~
<h2 id="SrsRAN"> Changes in configuration of srsRAN</h2> 
### enb.conf

Make sure PLMN (MNC and MCC) are changed to match used by Open5gs and make sure these modifications are changed or matched as mentioned in sections below:
  ~~~
  [enb]
  enb_id = 0x19B
  mcc = 901
  mnc = 70
  mme_addr = 127.0.0.2
  gtp_bind_addr = 127.0.1.1
  s1c_bind_addr = 127.0.1.1
  s1c_bind_port = 0
  n_prb = 50
  ~~~
  ~~~
  [rf]
  #dl_earfcn = 3350
  tx_gain = 80
  rx_gain = 40
  ~~~
  ### ue.conf
  ~~~
  [rf]
  freq_offset = 0
  tx_gain = 80
  srate = 11.52e6

  device_name = zmq
  device_args = tx_port=tcp://*:2001,rx_port=tcp://localhost:2000,id=ue,base_srate=11.52e6
  ~~~
  ~~~
  [rat.eutra]
  dl_earfcn = 3350
  nof_carriers = 0
  ~~~
  ~~~
  [rat.nr]
  bands = 3,78
  nof_carriers = 1
  ~~~
  ~~~
  [usim]
  mode = soft
  algo = milenage
  opc  = 000102030405060708090a0b0c0d0e0f
  k    = 00112233445566778899aabbccddeeff
  imsi = 901700123456789
  imei = 353490069873319
  ~~~
  ~~~
  [rrc]
  release           = 15
  ~~~
  ~~~
  [nas]
  apn = internet
  apn_protocol = ipv4v6
  ~~~
  ~~~
  [gw]
  netns = ue1
  ~~~
  ### rr.conf
  ~~~
  nr_cell_list =
  (
    {
      rf_port = 0;
      cell_id = 1;
      root_seq_idx = 1;
      tac = 7;
      pci = 500;
      dl_arfcn = 368500;
      coreset0_idx = 6;
      band = 3; 
    }
  );
  ~~~
  Note:  Please make sure these changes are made as mentioned and leave the commented lines as it is.

<h2 id="Networksrsran"> Network settings of Open5GS 5GC and srsRAN</h2> 
This is bridge connection between UPF and WAN (Internet). Enabling IP forwarding and adding NAT rule to IP Tables

### Enable IPv4/IPv6 Forwarding
~~~
 sudo sysctl -w net.ipv4.ip_forward=1
 sudo sysctl -w net.ipv6.conf.all.forwarding=1
~~~

### Add NAT Rule
~~~
 sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
 sudo ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE
~~~

Note : Only IPv4 forwarding was performed here.

### To Ensure that the packets in the `INPUT` chain to the `ogstun` interface are accepted
~~~
 sudo iptables -I INPUT -i ogstun -j ACCEPT
~~~

### Prevent UE's from connecting to the host on which UPF is running
~~~
 sudo iptables -I INPUT -s 10.45.0.0/16 -j DROP
 sudo ip6tables -I INPUT -s 2001:db8:cafe::/48 -j DROP
~~~
<h2 id="Run"> Run Open5GS and srsRAN</h2> 

bash file

<h2 id="Startenb"> Start eNB</h2>

~~~
mobcom1@mobcom1-VirtualBox: $ sudo srsenb 
[sudol password for mobconi:
Active RF plugins: libsrsran_rf_zmq.so
Inactive RF plugins:
Software Radio Systems LTE eNodeB
Couldn't open , trying /root/.config/srsran/enb.conf
Reading configuration file /root/.config/srsran/enb.conf...
Couldn't open sib.conf, trying /root/.config/srsran/sib.conf
Couldn't open rr.conf, trying /root/.config/srsran/rr.conf Couldn't open rb.conf, trying /root/.config/srsran/rb.conf
Built in Release mode using commit 254c719a on branch master.
Opening 1 channels in RF device=zmq with args=fail_on_disconnect=true, tx_port=tc: / /*: 2000, r_port=tc: / /localhost: 2001, id=enb, base_sra te=11.526
Supported RF device list: zmq file
CH× base_ srate=11.526
CH id=enb
Current sample rate is 1.92 MHz with a base rate of 11.52 MHz (x6 decimation)
CHO r×_port=tcp: / /localhost: 2001
CHO t×_ port=tcp: / /*: 2000
CHO fail on disconnect=true
NG connection successful
==== eNodeB started ===
Type <t> to view trace
Current sample rate is 11.52 MHz with a base rate of 11.52 MHz (x1 decimation)
Current sample rate is 11.52 MHz with a base rate of 11.52 MHz (x1 decimation)
Setting frequency: DL=1842.5 Mhz, DL_SSB=1842.05 Mhz (SSB-ARFCN-368410), UL=1747.5 MHz for cc_idx=0 nof_prb=52 RACH:
slot=971, cc=0, preamble-0, offset=0, temp_crnti=0x4601
~~~

<h2 id="Startue"> Start UE</h2>

~~~
mobcom1@mobcom1-VirtualBox: $ sudo srsue 
[sudo] password for mobcom1:
Active RF plugins: libsrsran_rf_zmq.so
Inactive RF plugins:
Couldn't open , trying /root/ .config/srsran/ue.conf
Reading configuration file /root/.config/srsran/ue.conf...
Built in Release mode using commit 254c719a on branch master.
srsLog error - Unable to create log file "/tmp/ue.log": Permission denied
Opening 1 channels in RF device=zmq wtth args=tx_port=tc: //*:2001, r×_port=tc: / /localhost:2000, td=ue,base_srate=11.52e6
Supported RF device list: zmq file
CH base_ srate=11.52e6
Current sample rate is 1.92 MHz with a base rate of 11.52 MHz (x6 decimation)
CHO r×_ port=tcp: / /localhost: 2000
CHO t×_port=tcp: / /*:2001
Current sample rate is 11.52 MHz wtth a base rate of 11.52 MHz (x1 dectmation)
Current sample rate is 11.52 MHz with a base rate of 11.52 MHz (x1 decimation)
Waiting PHY to initialize ... done!
Attaching UE...
Random Access Transmisston: prach_occaston=0, preamble_index=0, ra-rnti=oxf, tti=971
Random Access Complete.
c-rnti=0x4601, ta=o
RRC Connected
RRC NR reconfiguration successful.
PDU Session Establishment successful. IP: 10.45.0.2
RRC NR reconfiguration successful.
Received RRC Release
~~~
<h2 id="Testing"> Testing the Network</h2>


Testing using iPerf3. In this setup the client will run on the UE side with the server on the network side

## Network Side

Start the iPerf Server

~~~
iperf3 -s -i 1
~~~

## UE Side

With the network and the iPerf server up and running
~~~
sudo ip netns exec ue1 iperf3 -c 10.45.0.1 -b 10M -i 1 -t 60
~~~

## Client iPerf Output:
[image]()
## Server iPerf Output:
[image]()
