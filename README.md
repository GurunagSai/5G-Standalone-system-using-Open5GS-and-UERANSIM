# 5G Network & Architecture
5G is the 5th generation mobile network. It is a new global wireless standard after 1G, 2G, 3G, and 4G networks. 5G enables a new kind of network that is designed to connect virtually everyone and everything together including machines, objects, and devices.
5G wireless technology is meant to deliver higher multi-Gbps peak data speeds, ultra low latency, more reliability, massive network capacity, increased availability, and a more uniform user experience to more users. Higher performance and improved efficiency empower new user experiences and connects new industries.

# Group-specific Project Description

# Introduction to Open5gs 
The Open5gs is an open source project that provides 4G and 5G mobile packet core network functionalities for building a private LTE/5G network under the GNU AGPL 3.0 license. Currently, it supports 3GPP Release 16 with providing 5G Core (AMF, SMF+PGW-c, UPF+PGW-u, PCF, UDR, UDM, AUSF, NRF) network functions and Evolved Packet Core (MME, SGW-c, SGW-u, HSS, and PCRF) network functions.

# Open5gs and srsRAN 
5G end to end (SA) communication with Open5gs and srsRAN

# Open5gs 
Open5GS contains a series of software components and network functions that implement the 4G/ 5G NSA and 5G SA core functions. Here we focus on 5G SA core function.
The Open5GS 5G SA Core contains the following functions:
NRF - NF Repository Function
SCP - Service Communication Proxy
AMF - Access and Mobility Management Function
SMF - Session Management Function
UPF - User Plane Function
AUSF - Authentication Server Function
UDM - Unified Data Management
UDR - Unified Data Repository
PCF - Policy and Charging Function
NSSF - Network Slice Selection Function
BSF - Binding Support Function

5G SA uses a Service Based Architecture (SBA), Control Plane and User Plane. Service-Based Architectures provide a modular framework from which common applications can be deployed using components of varying sources and suppliers. Control plane functions are configured to register with the NRF, and the NRF then helps them discover the other core functions. The AMF handles connection and mobility management. The NSSF provides a way to select the network slice, and PCF is used for charging and enforcing subscriber policies. Finally there is the SCP that enable indirect communication. The 5G SA core user plane contains a single function. The UPF carries user data packets between the gNB and the external WAN. It connects back to the SMF too.

# srsRAN
It is a complete RAN solution compliant with 3GPP and O-RAN Alliance specifications. The srsRAN Project includes the full L1/2/3 stack with minimal external dependencies. The software is portable across processor architectures and scalable from low-power embedded systems to cloudRAN, providing a powerful platform for mobile wireless research and development.

# Developer guide to Open5gs with srsRAN

