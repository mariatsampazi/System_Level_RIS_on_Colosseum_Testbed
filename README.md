# Energy_Efficient_RIS_on_Colosseum

If you use any part of the code, please cite:

**M. Tsampazi and T. Melodia, "System-Level Experimental Evaluation of Reconfigurable Intelligent Surfaces for NextG Communication Systems," IEEE Transactions on Vehicular Technology, vol. 74, no. 9, pp. 14138-14153, Sept. 2025.**

[IEEE Xplore](https://doi.org/10.1109/TVT.2025.3563184) | [arXiv](https://arxiv.org/abs/2412.12969)

## Citation

If you use this code, please cite:
```bibtex
@ARTICLE{10973151,
  author={Tsampazi, Maria and Melodia, Tommaso},
  journal={IEEE Transactions on Vehicular Technology}, 
  title={System-Level Experimental Evaluation of Reconfigurable Intelligent Surfaces for NextG Communication Systems}, 
  year={2025},
  volume={74},
  number={9},
  pages={14138-14153},
  doi={10.1109/TVT.2025.3563184}
}
```
## Abstract

Reconfigurable Intelligent Surfaces (RISs) are a promising technique for enhancing the performance of Next Generation (NextG) wireless communication systems in terms of both spectral and energy efficiency, as well as resource utilization. However, current RIS research has primarily focused on theoretical modeling and Physical (PHY) layer considerations only. Full protocol stack emulation and accurate modeling of the propagation characteristics of the wireless channel are necessary for studying the benefits introduced by RIS technology across various spectrum bands and use-cases. In this paper, we propose, for the first time: (i) accurate PHY layer RIS-enabled channel modeling through Geometry-Based Stochastic Models (GBSMs), leveraging the QUAsi Deterministic RadIo channel GenerAtor (QuaDRiGa) open-source statistical ray-tracer; (ii) optimized resource allocation with RISs by comprehensively studying energy efficiency and power control on different portions of the spectrum through a single-leader multiple-followers Stackelberg game theoretical approach; (iii) full-stack emulation and performance evaluation of RIS-assisted channels with SCOPE/srsRAN for Enhanced Mobile Broadband (eMBB) and Ultra Reliable and Low Latency Communications (URLLC) applications in the world's largest emulator of wireless systems with hardware-in-the-loop, namely Colosseum. Our findings indicate (i) the significant power savings in terms of energy efficiency achieved with RIS-assisted topologies, especially in the millimeter wave (mmWave) band; and (ii) the benefits introduced for Sub-6 GHz band User Equipments (UEs), where the deployment of a relatively small RIS (e.g., in the order of 100 RIS elements) can result in decreased levels of latency for URLLC services in resource-constrained environments.

## Acknowledgments

This work was partially supported by the U.S. National Science Foundation under grants CNS-1925601 and CNS-2112471.

## Overview

Briefly, a Hierarchical Game Theoretic Approach is adopted for the purposes of tesing the Energy Efficiency (E.E.) of a RIS assisted and UAV enabled topology on two 5G-bands, namely the Sub-6 GHz and the mmWAve. The generated "Energy Efficient" channels are installed on Colosseum. 
<!-- Copyright to creator Maria Tsampazi. -->

## Sequence of running the Scripts to get the channels with MATLAB

1. without_RIS_static.m (no RIS in the topology, the result is the generation of the `user_to_UAV.mat` file)
2. user_to_RIS_static.m (UE to RIS link, the result is the generation of the `user_to_RIS_new_format.mat` file)
3. RIS_to_UAV_static.m (RIS to UAV link, the result is the generation of the `RIS_to_UAV_new_format.mat` file)
   
**NOTE:** For reproducibility in the Performance Evaluation, the aforementioned MAT files are also saved in the `MAT_FILES_total_comparison` folder of this repository separately for the two bands.

## Scripts for the Performance Evaluation 
4. final_path_gains.m (to plot the generated path gains and produce the`metrics_sub6ghz.mat`, `metrics_mmwave.mat`). This script is
**very important**, since we run the Resource Allocation algorithm in there. The aforementioned MAT files are also present in the `MAT_FILES_total_comparison` folder and are also used as input in the `evaluation_plotters.m, mmwave_sub6ghz_comparison.m, topology_visualization.m` scripts. Lastly, the `colosseum_scenario_info.mat` is created for the installation of the scenario on Colosseum. More to follow, later. 
5. evaluation_plotters.m (to plot the results of the E.E. for each of the two bands in separate plots)
6. mmwave_sub6ghz_comparison.m (to compare the two bands in the same plots, in terms of the system capacity)
7. topology_visualization.m (to plot the topology, this is mainly for editing on powerpoint later)
8. `colosseum_scenario_.m`: to generate the scenarios for Colosseum, in terms of complex path gains for the links of interest and Time-of-Arrivals (ToAs). The framework focuses on the uplink but all the generated links are bi-directional, i.e., the same values for Uplink (UL) and Downlink (DL). For the ToAs, we calculate the values with the help of equation x = c &times; t, where c is the speed of light. The `colosseum-scenarios` folder contains the MAT files with the installed scenario on Colosseum. The scenario installed is the scenario referring to the links for the Sub-6 Ghz band.

## Geometry of the generated Topology

i: UE, R: RIS: U: UAV, d: Euclidean distance


- **File:** `static_5_positions_UAV.xlsx`
  **Code:** `without_RIS_static.m`

| X       | Y       | Z     | Description    |
|---------|---------|-------|----------------|
| 25      | 50      | 25   | UAV            |
| 89.5975 | 17.1909 | 1.524 | Vehicle 1      |
| 10.2218 | 37.5622 | 1.524 | Vehicle 2      |
| 72.9268 | 4.9029  | 1.524 | Vehicle 3      |
| 34.8773 | 44.9899 | 1.524 | Vehicle 4      |
| 48.169  | 13.9806 | 1.524 | Vehicle 5      |

---

- **File:** `static_5_positions_RIS.xlsx`
  **Code:** `user_to_RIS_static.m`

| X       | Y       | Z     | Description     |
|---------|---------|-------|-----------------|
| 30      | 40      | 20    | RIS (ID 1)      |
| 89.5975 | 17.1909 | 1.524 | Vehicle 1 (ID 2)|
| 10.2218 | 37.5622 | 1.524 | Vehicle 2 (ID 3)|
| 72.9268 | 4.9029  | 1.524 | Vehicle 3 (ID 4)|
| 34.8773 | 44.9899 | 1.524 | Vehicle 4 (ID 5)|
| 48.169  | 13.9806 | 1.524 | Vehicle 5 (ID 6)|

---

- **File:** `RIS_to_UAV.xlsx`
  **Code:** `RIS_to_UAV_static.m`

| X       | Y       | Z     | Description    |
|---------|---------|-------|----------------|
| 30      | 40      | 20    | RIS            |
| 25      | 50      | 25    | UAV            |

**d_iR**
- 66.4340
- 27.1750
- 58.4455
- 19.7497
- 36.7217

**d_Ru**
- 12.2474

---

### Combined distance toas

| d_iRU distance 	| ToAs              |
|-------------------|-------------------|
| 78.6814           | 2.62453e-7        |
| 39.4224           | 1.31499e-7        |
| 70.6929           | 2.35806e-7        |
| 31.9971           | 1.06731e-7        |
| 48.9691           | 1.63343e-7        |


## Description of `colosseum-scenarios` installed on Colosseum

1. `n10_sub6_800_v2.mat`: 10 elements on RIS, static
2. `n100_sub6_800_v2.mat`: 100 elements on RIS, static
3. `n1000_sub6_800_v2.mat`: 1000 elements on RIS, static
4. `nosu_sub6_800_static_v2.mat`: NO RIS, static

For all, the first entry is the TOA, the second is the complex path gain.

## Description of installed scenarios on Colosseum

For the paper, we experiment with the following by focuing on the sub-6 GHz band and the generated channels for this frequency. The scenario is installed at 1 GHz on Colosseum. All the links are bi-directional as mentioned. There is a 91 dB correction on the final values for the successful installation on Colosseum.

1. **43024	RIS 100 UAV scenario - 1 GHz + 91dB**
2. **43026	No RIS UAV scenario - 1 GHz + 91dB**

The traffic is slice based, the TGEN ID is 100730. For SCOPE, 6 nodes are present, the 1st node is the UAV and the other 5 are the Users (UEs). The `radio_interactive.conf' has been modified accordingly.

To create uniform traffic, the following ca be run:

1. Base station (BS)
`iperf3 -s -i 1`
2. UE
`iperf3 -c 172.16.0.1 -t 300`

## Mobility

Mobility is a work under progress. All the above concern a static topology.

## References

<!-- Contains the code for the performance evaluation of:  -->

This repository contains the code and the MAT files for the extension of the SMARTCOMP '21 paper: "Energy Efficient Multi-User Communications Aided by Reconfigurable Intelligent Surfaces and UAVs".

> M. Diamanti, M. Tsampazi, E. E. Tsiropoulou, and S. Papavassiliou, "Energy efficient multi-user communications aided by reconfigurable intelligent surfaces and UAVs," in *IEEE International Conference on Smart Computing (SMARTCOMP)*, pp. 371-376, 2021.


