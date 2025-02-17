.. Date: July 30 2020
.. Author: pramarao

.. _operator-release-notes-1.11.1:

*****************************************
Release Notes
*****************************************
This document describes the new features, improvements, fixed and known issues for the NVIDIA GPU Operator.

See the :ref:`Component Matrix<operator-component-matrix-1.11.1>` for a list of components included in each release.

.. note::

   GPU Operator beta releases are documented on `GitHub <https://github.com/NVIDIA/gpu-operator/releases>`_. NVIDIA AI Enterprise builds are not posted on GitHub.

----

1.11.1
=====

Improvements
------------

* Added ``startupProbe`` to NVIDIA driver container to allow RollingUpgrades to progress to other nodes only after driver modules are successfully loaded on current one.
* Added support for ``driver.rollingUpdate.maxUnavailable`` parameter to specify maximum nodes for simultaneous driver upgrades. Default is 1.
* NVIDIA driver container will auto-disable itself on the node with pre-installed drivers by applying label ``nvidia.com/gpu.deploy.driver=pre-installed``. This is useful for heterogeneous clusters where only some GPU nodes have pre-installed drivers(e.g. DGX OS).

Fixed issues
------------

* Apply tolerations to ``cuda-validator`` and ``device-plugin-validator`` Pods based on ``deamonsets.tolerations`` in `ClusterPolicy`. For more info refer `here <https://github.com/NVIDIA/gpu-operator/issues/360>`_.
* Fixed an issue causing ``cuda-validator`` Pod to fail when ``accept-nvidia-visible-devices-envvar-when-unprivileged = false`` is set with NVIDIA Container Toolkit. For more info refer `here <https://github.com/NVIDIA/gpu-operator/issues/365>`_.
* Fixed an issue which caused recursive mounts under ``/run/nvidia/driver`` when both ``driver.rdma.enabled`` and ``driver.rdma.useHostMofed`` are set to ``true``. This caused other GPU Pods to fail to start.

----

1.11.0
======

New Features
------------

* Support for NVIDIA Data Center GPU Driver version ``515.48.07``.
* Support for NVIDIA AI Enterprise 2.1.
* Support for NVIDIA Virtual Compute Server 14.1 (vGPU).
* Support for Ubuntu 22.04 LTS.
* Support for secure boot with GPU Driver version 515 and Ubuntu Server 20.04 LTS and 22.04 LTS.
* Support for Kubernetes 1.24.
* Support for :ref:`Time-Slicing GPUs in Kubernetes<gpu-sharing-1.11.1>`.
* Support for Red Hat OpenShift on AWS, Azure and GCP instances. Refer to the Platform Support Matrix for the supported instances.
* Support for Red Hat Openshift 4.10 on AWS EC2 G5g instances(ARM).
* Support for Kubernetes 1.24 on AWS EC2 G5g instances(ARM).
* Support for use with the NVIDIA Network Operator 1.2.
* [Technical Preview] - Support for :ref:`KubeVirt and Red Hat OpenShift Virtualization with GPU Passthrough and NVIDIA vGPU based products<gpu-operator-kubevirt-1.11.1>`.
* [Technical Preview] - Kubernetes on ARM with Server Base System Architecture (SBSA).

Improvements
------------

* GPUDirect RDMA is now supported with CentOS using MOFED installed on the node.
* The NVIDIA vGPU Manager can now be upgraded to a newer branch while using an older, compatible guest driver.
* DGX A100 and non-DGX servers can now be used within the same cluster.
* Improved user interface while deploying a ClusterPolicy instance(CR) for the GPU Operator through Red Hat OpenShift Console.
* Improved the container-toolkit to handle v1 containerd configurations.

Fixed issues
------------

* Fix for incorrect reporting of ``DCGM_FI_DEV_FB_USED`` where reserved memory is reported as used memory. For more details refer to `GitHub issue <https://github.com/NVIDIA/gpu-operator/issues/348>`_.
* Fixed nvidia-peermem sidecar container to correctly load the ``nvidia-peermem`` module when MOFED is directly installed on the node.
* Fixed duplicate mounts of ``/run/mellanox/drivers`` within the driver container which caused driver cleanup or re-install to fail.
* Fixed uncordoning of the node with k8s-driver-manager whenever ENABLE_AUTO_DRAIN env is disabled.
* Fixed readiness check for MOFED driver installation by the NVIDIA Network Operator. This will avoid the GPU driver containers to be in ``CrashLoopBackOff`` while waiting for MOFED drivers to be ready.

Known Limitations
------------------

* All worker nodes within the Kubernetes cluster must use the same operating system version.
* The NVIDIA GPU Operator can only be used to deploy a single NVIDIA GPU Driver type and version. The NVIDIA vGPU and Data Center GPU Driver cannot be used within the same cluster.
* See the :ref:`limitations<gpu-operator-kubevirt-1.11.1-limitations>` sections for the [Technical Preview] of GPU Operator support for KubeVirt.
* The ``clusterpolicies.nvidia.com`` CRD has to be manually deleted after the GPU Operator is uninstalled using Helm.
* ``nouveau`` driver has to be blacklisted when using the NVIDIA vGPU. Otherwise the driver will fail to initialize the GPU with the error ``Failed to enable MSI-X`` in the system journal logs and all GPU Operator pods will be stuck in ``init`` state.
* The ``gpu-operator:v1.11.0`` and ``gpu-operator:v1.11.0-ubi8`` images have been released with the following known HIGH Vulnerability CVEs.
  These are from the base images and are not in libraries used by GPU Operator:
    * ``xz-libs`` - `CVE-2022-1271 <https://access.redhat.com/security/cve/CVE-2022-1271>`_


----

1.10.1
=====

Improvements
------------
* Validated secure boot with signed NVIDIA Data Center Driver R510.
* Validated cgroup v2 with Ubuntu Server 20.04 LTS.

Fixed issues
------------
* Fixed an issue when GPU Operator was installed and MIG was already enabled on a GPU. The GPU Operator will now install sucessfully and MIG can either be disabled via the label ``nvidia.com/mig.config=all-disabled`` or configured with the required MIG profiles.

Known Limitations
------------------

* The ``gpu-operator:v1.10.1`` and ``gpu-operator:v1.10.1-ubi8`` images have been released with the following known HIGH Vulnerability CVEs.
  These are from the base images and are not in libraries used by GPU Operator:
    * ``openssl-libs`` - `CVE-2022-0778 <https://access.redhat.com/security/cve/CVE-2022-0778>`_
    * ``zlib`` - `CVE-2018-25032 <https://access.redhat.com/security/cve/CVE-2018-25032>`_
    * ``gzip`` - `CVE-2022-1271 <https://access.redhat.com/security/cve/CVE-2022-1271>`_

----

1.10.0
=====

New Features
-------------
* Support for NVIDIA Data Center GPU Driver version `510.47.03`.
* Support NVIDIA A2, A100X and A30X
* Support for A100X and A30X on the DPU’s Arm processor.
* Support for secure boot with Ubuntu Server 20.04 and NVIDIA Data Center GPU Driver version R470.
* Support for Red Hat OpenShift 4.10.
* Support for GPUDirect RDMA with Red Hat OpenShift.
* Support for NVIDIA AI Enterprise 2.0.
* Support for NVIDIA Virtual Compute Server 14 (vGPU).

Improvements
------------
* Enabling/Disabling of GPU System Processor (GSP) Mode through NVIDIA driver module parameters.
* Ability to avoid deploying GPU Operator Operands on certain worker nodes through labels. Useful for running VMs with GPUs using KubeVirt.

Fixed issues
------------
* Increased lease duration of GPU Operator to 60s to avoid restarts during etcd defrag. More details `here <https://github.com/NVIDIA/gpu-operator/issues/326>`_.
* Avoid spurious alerts generated of type ``GPUOperatorOpenshiftDriverToolkitEnabledNfdTooOld`` on RedHat OpenShift when there are no GPU nodes in the cluster.
* Avoid uncordoning nodes during driver pod startup when ``ENABLE_AUTO_DRAIN`` is set to ``false``.
* Collection of GPU metrics in MIG mode is now supported with 470+ drivers.
* Fabric Manager (required for NVSwitch based systems) with CentOS 7 is now supported.


Known Limitations
------------------
* Upgrading to a new NVIDIA AI Enterprise major branch:
Upgrading the vGPU host driver to a newer major branch than the vGPU guest driver will result in GPU driver pod transitioning to a failed state. This happens for instance when the Host is upgraded to vGPU version 14.x while the Kubernetes nodes are still running with vGPU version 13.x.

To overcome this situation, before upgrading the host driver to the new vGPU branch, apply the following steps:

  #. kubectl edit clusterpolicy
  #. modify the policy and set the environment variable DISABLE_VGPU_VERSION_CHECK to true as shown below:

      .. code-block:: yaml

        driver:
          env:
          - name: DISABLE_VGPU_VERSION_CHECK
            value: "true"

  #. write and quit the clusterpolicy edit
* The ``gpu-operator:v1.10.0`` and ``gpu-operator:v1.10.0-ubi8`` images have been released with the following known HIGH Vulnerability CVEs.
  These are from the base images and are not in libraries used by GPU Operator:
    * ``openssl-libs`` - `CVE-2022-0778 <https://access.redhat.com/security/cve/CVE-2022-0778>`_

----

1.9.1
=====

Improvements
------------
* Improved logic in the driver container for waiting on MOFED driver readiness. This ensures that ``nvidia-peermem`` is built and installed correctly.

Fixed issues
------------
* Allow ``driver`` container to fallback to using cluster entitlements on Red Hat OpenShift on build failures. This issue exposed itself when using GPU Operator with some Red Hat OpenShift 4.8.z versions and Red Hat OpenShift 4.9.8. GPU Operator 1.9+ with Red Hat OpenShift 4.9.9+ doesn't require entitlements.
* Fixed an issue when DCGM-Exporter didn't work correctly with using the separate DCGM host engine that is part of the standalone DCGM pod. Fixed the issue and changed the default behavior to use the DCGM Host engine that is embedded in DCGM-Exporter. The standalone DCGM pod will not be launched by default but can be enabled for use with DGX A100.
* Update to latest Go vendor packages to avoid any CVE's.
* Fixed an issue to allow GPU Operator to work with ``CRI-O`` runtime on Kubernetes.
* Mount correct source path for Mellanox OFED 5.x drivers for enabling GPUDirect RDMA.

----

1.9.0
=====

New Features
-------------
* Support for NVIDIA Data Center GPU Driver version `470.82.01`.
* Support for DGX A100 with DGX OS 5.1+.
* Support for preinstalled GPU Driver with MIG Manager.
* Removed dependency to maintain active Red Hat OpenShift entitlements to build the GPU Driver. Introduce entitlement free driver builds starting with Red Hat OpenShift 4.9.9.
* Support for GPUDirect RDMA with preinstalled Mellanox OFED drivers.
* Support for GPU Operator and operands upgrades using Red Hat OpenShift Lifecycle Manager (OLM).
* Support for NVIDIA Virtual Compute Server 13.1 (vGPU).

Improvements
-------------
* Automatic detection of default runtime used in the cluster. Deprecate the operator.defaultRuntime parameter.
* GPU Operator and its operands are installed into a single user specified namespace.
* A loaded Nouveau driver is automatically detected and unloaded as part of the GPU Operator install.
* Added an option to mount a ConfigMap of self-signed certificates into the driver container. Enables SSL connections to private package repositories.

Fixed issues
------------
* Fixed an issue when DCGM Exporter was in CrashLoopBackOff as it could not connect to the DCGM port on the same node.

Known Limitations
------------------
* GPUDirect RDMA is only supported with R470 drivers on Ubuntu 20.04 LTS and is not supported on other distributions (e.g. CoreOS, CentOS etc.)
* The GPU Operator supports GPUDirect RDMA only in conjunction with the Network Operator. The Mellanox OFED drivers can be installed by the Network Operator or pre-installed on the host.
* Upgrades from v1.8.x to v1.9.x are not supported due to GPU Operator 1.9 installing the GPU Operator and its operands into a single namespace. Previous GPU Operator versions installed them into different namespaces. Upgrading to GPU Operator 1.9 requires uninstalling pre 1.9 GPU Operator versions prior to installing GPU Operator 1.9
* Collection of GPU metrics in MIG mode is not supported with 470+ drivers.
* The GPU Operator requires all MIG related configurations to be executed by MIG Manager. Enabling/Disabling MIG and other MIG related configurations directly on the host is discouraged.
* Fabric Manager (required for NVSwitch based systems) with CentOS 7 is not supported.
.. * See the :ref:`operator-known-limitations-1.11.1` at the bottom of this page.

----

1.8.2
=====

Fixed issues
------------
* Fixed an issue where Driver Daemonset was spuriously updated on RedHat OpenShift causing repeated restarts in Proxy environments.
* The MIG Manager version was bumped to `v0.1.3` to fix an issue when checking whether a GPU was in MIG mode or not.
  Previously, it would always check for MIG mode directly over the PCIe bus instead of using NVML. Now it checks with NVML when it can, only falling back to the PCIe bus when NVML is not available.
  Please refer to the `Release notes <https://github.com/NVIDIA/mig-parted/releases/tag/v0.1.3>`_  for a complete list of fixed issues.
* Container Toolkit bumped to version `v1.7.1` to fix an issue when using A100 80GB.

Improvements
-------------
* Added support for user-defined MIG partition configuration via a `ConfigMap`.

----

1.8.1
=====

Fixed issues
------------
* Fixed an issue with using the `NVIDIA License System <https://docs.nvidia.com/license-system/latest/>`_ in NVIDIA AI Enterprise deployments.

----

1.8.0
=====

New Features
-------------
* Support for NVIDIA Data Center GPU Driver version `470.57.02`.
* Added support for NVSwitch systems such as HGX A100. The driver container detects the presence of NVSwitches
  in the system and automatically deploys the `Fabric Manager <https://docs.nvidia.com/datacenter/tesla/pdf/fabric-manager-user-guide.pdf>`_
  for setting up the NVSwitch fabric.
* The driver container now builds and loads the ``nvidia-peermem`` kernel module when GPUDirect RDMA is enabled and Mellanox devices are present in the system.
  This allows the GPU Operator to complement the `NVIDIA Network Operator <https://github.com/Mellanox/network-operator>`_ to enable GPUDirect RDMA in the
  Kubernetes cluster. Refer to the :ref:`RDMA<operator-rdma-1.11.1>` documentation on getting started.

  .. note::

    This feature is available only when used with R470 drivers on Ubuntu 20.04 LTS.
* Added support for :ref:`upgrades<operator-upgrades-1.11.1>` of the GPU Operator components. A new ``k8s-driver-manager`` component handles upgrades
  of the NVIDIA drivers on nodes in the cluster.
* NVIDIA DCGM is now deployed as a component of the GPU Operator. The standalone DCGM container allows multiple clients such as
  `DCGM-Exporter <https://docs.nvidia.com/datacenter/cloud-native/gpu-telemetry/dcgm-exporter.html>`_ and `NVSM <http://docs.nvidia.com/datacenter/nvsm/nvsm-user-guide/index.html>`_
  to be deployed and connect to the existing DCGM container.
* Added a ``nodeStatusExporter`` component that exports operator and node metrics in a Prometheus format. The component provides
  information on the status of the operator (e.g. reconciliation status, number of GPU enabled nodes).

Improvements
-------------
* Reduced the size of the ClusterPolicy CRD by removing duplicates and redundant fields.
* The GPU Operator now supports detection of the virtual PCIe topology of the system and makes the topology available to
  vGPU drivers via a configuration file. The driver container starts the ``nvidia-topologyd`` daemon in vGPU configurations.
* Added support for specifying the ``RuntimeClass`` variable via Helm.
* Added ``nvidia-container-toolkit`` images to support CentOS 7 and CentOS 8.
* ``nvidia-container-toolkit`` now supports configuring `containerd` correctly for K3s.
* Added new debug options (logging, verbosity levels) for ``nvidia-container-toolkit``


Fixed issues
------------
* The driver container now loads ``ipmi_devintf`` by default. This allows tools such as ``ipmitool`` that rely on ``ipmi`` char devices
  to be created and available.

Known Limitations
------------------
* GPUDirect RDMA is only supported with R470 drivers on Ubuntu 20.04 LTS and is not supported on other distributions (e.g. CoreOS, CentOS etc.)
* The operator supports building and loading of ``nvidia-peermem`` only in conjunction with the Network Operator. Use with pre-installed MOFED drivers
  on the host is not supported. This capability will be added in a future release.
* Support for DGX A100 with GPU Operator 1.8 will be available in an upcoming patch release.
* This version of GPU Operator does not work well on RedHat OpenShift when a cluster-wide proxy is configured and causes constant restarts of driver container.
  This will be fixed in an upcoming patch release `v1.8.2`.
.. * See the :ref:`operator-known-limitations-1.11.1` at the bottom of this page.

----

1.7.1
=====

Fixed issues
------------
* NFD version bumped to `v0.8.2` to support correct kernel version labelling on Anthos nodes. See `NFD issue <https://github.com/kubernetes-sigs/node-feature-discovery/pull/402>`_ for more details.

----

1.7.0
=====

New Features
-------------
* Support for NVIDIA Data Center GPU Driver version `460.73.01`.
* Added support for automatic configuration of MIG geometry on NVIDIA Ampere products (e.g. A100) using the ``k8s-mig-manager``.
* GPU Operator can now be deployed on systems with pre-installed NVIDIA drivers and the NVIDIA Container Toolkit.
* DCGM-Exporter now supports telemetry for MIG devices on supported Ampere products (e.g. A100).
* Added support for a new ``nvidia`` ``RuntimeClass`` with `containerd`.
* The Operator now supports ``PodSecurityPolicies`` when enabled in the cluster.

Improvements
-------------
* Changed the label selector used by the DaemonSets of the different states of the GPU Operator. Instead of having a global
  label ``nvidia.com/gpu.present=true``, each DaemonSet now has its own label, ``nvidia.com/gpu.deploy.<state>=true``. This
  new behavior allows a finer grain of control over the components deployed on each of the GPU nodes.
* Migrated to using the latest operator-sdk for building the GPU Operator.
* The operator components are deployed with ``node-critical`` ``PriorityClass`` to minimize the possibility of eviction.
* Added a spec for the ``initContainer`` image, to allow flexibility to change the base images as required.
* Added the ability to configure the MIG strategy to be applied by the Operator.
* The driver container now auto-detects OpenShift/RHEL versions to better handle node/cluster upgrades.
* Validations of the container-toolkit and device-plugin installations are done on all GPU nodes in the cluster.
* Added an option to skip plugin validation workload pod during the Operator deployment.

Fixed issues
------------
* The ``gpu-operator-resources`` namespace is now created by the Operator so that they can be used by both Helm
  and OpenShift installations.

Known Limitations
------------------
* DCGM does not support profiling metrics on RTX 6000 and RTX 8000. Support will be added in a future release of DCGM Exporter.
* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.
* When MIG strategy of ``mixed`` is configured, device-plugin-validation may stay in ``Pending`` state due to incorrect GPU resource request type. User would need to
  modify the pod spec to apply correct resource type to match the MIG devices configured in the cluster.

----

1.6.2
=====

Fixed issues
------------
* Fixed an issue with NVIDIA Container Toolkit 1.4.6 which causes an error with containerd as ``Error while dialing dial unix /run/containerd/containerd.sock: connect: connection refused``. NVIDIA Container Toolkit 1.4.7 now sets ``version`` as an integer to fix this error.
* Fixed an issue with NVIDIA Container Toolkit which causes nvidia-container-runtime settings to be persistent across node reboot and causes driver pod to fail. Now nvidia-container-runtime will fallback to using ``runc`` when driver modules are not yet loaded during node reboot.
* GPU Operator now mounts runtime hook configuration for CRIO under ``/run/containers/oci/hooks.d``.

----

1.6.1
=====

Fixed issues
------------
* Fixed an issue with NVIDIA Container Toolkit 1.4.5 when used with containerd and an empty containerd configuration which file causes error ``Error while dialing dial unix /run/containerd/containerd.sock: connect: connection refused``. NVIDIA Container Toolkit 1.4.6 now explicitly sets the ``version=2`` along with other changes when the default containerd configuration file is empty.

----

1.6.0
=====

New Features
-------------
* Support for Red Hat OpenShift 4.7.
* Support for NVIDIA Data Center GPU Driver version `460.32.03`.
* Automatic injection of Proxy settings and custom CA certificates into driver container for Red Hat OpenShift.

DCGM-Exporter support includes the following:

* Updated DCGM to v2.1.4
* Increased reporting interval to 30s instead of 2s to reduce overhead
* Report NVIDIA vGPU licensing status and row-remapping metrics for Ampere GPUs

Improvements
-------------
* NVIDIA vGPU licensing configuration (gridd.conf) can be provided as a ConfigMap
* ClusterPolicy CRD has been updated from v1beta1 to v1. As a result minimum supported Kubernetes version is 1.16 from GPU Operator 1.6.0 onwards.

Fixed issues
------------
* Fixes for DCGM Exporter to work with CPU Manager.
* nvidia-gridd daemon logs are now collected on host by rsyslog.

Known Limitations
------------------
* DCGM does not support profiling metrics on RTX 6000 and RTX 8000. Support will be added in a future release of DCGM Exporter.
* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.
* When MIG strategy of ``mixed`` is configured, device-plugin-validation may stay in ``Pending`` state due to incorrect GPU resource request type. User would need to
  modify the pod spec to apply correct resource type to match the MIG devices configured in the cluster.
* ``gpu-operator-resources`` project in Red Hat OpenShift requires label ``openshift.io/cluster-monitoring=true`` for Prometheus to collect DCGM metrics. User will need to add this
  label manually when project is created.

----

1.5.2
=====

Improvements
-------------
* Allow ``mig.strategy=single`` on nodes with non-MIG GPUs.
* Pre-create MIG related ``nvcaps`` at startup.
* Updated device-plugin and toolkit validation to work with CPU Manager.

Fixed issues
------------
* Fixed issue which causes GFD pods to fail with error ``Failed to load NVML`` error even after driver is loaded.

----

1.5.1
=====

Improvements
-------------
* Kubelet's cgroup driver as ``systemd`` is now supported.

Fixed issues
------------
* Device-Plugin stuck in ``init`` phase on node reboot or when new node is added to the cluster.

----

1.5.0
=====

New Features
-------------
* Added support for NVIDIA vGPU

Improvements
-------------
* Driver Validation container is run as an initContainer within device-plugin Daemonset pods. Thus driver installation on each NVIDIA GPU/vGPU node will be validated.
* GFD will label vGPU nodes with driver version and branch name of NVIDIA vGPU installed on Hypervisor.
* Driver container will perform automatic compatibility check of NVIDIA vGPU driver with the version installed on the underlying Hypervisor.

Fixed issues
------------
* GPU Operator will no longer crash when no GPU nodes are found.
* Container Toolkit pods wait for drivers to be loaded on the system before setting the default container runtime as `nvidia`.
* On host reboot, ordering of pods is maintained to ensure that drivers are always loaded first.
* Fixed device-plugin issue causing ``symbol lookup error: nvidia-device-plugin: undefined symbol: nvmlEventSetWait_v2`` error.

Known Limitations
------------------
* The GPU Operator v1.5.x does not support mixed types of GPUs in the same cluster. All GPUs within a cluster need to be either NVIDIA vGPUs, GPU Passthrough GPUs or Bare Metal GPUs.
* GPU Operator v1.5.x with NVIDIA vGPUs support Turing and newer GPU architectures.
* DCGM does not support profiling metrics on RTX 6000 and RTX 8000. Support will be added in a future release of DCGM Exporter.
* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.
* When MIG strategy of ``mixed`` is configured, device-plugin-validation may stay in ``Pending`` state due to incorrect GPU resource request type. User would need to
  modify the pod spec to apply correct resource type to match the MIG devices configured in the cluster.
* ``gpu-operator-resources`` project in Red Hat OpenShift requires label ``openshift.io/cluster-monitoring=true`` for Prometheus to collect DCGM metrics. User will need to add this
  label manually when project is created.

----

1.4.0
=====

New Features
-------------
* Added support for CentOS 7 and 8.

  .. note::

    Due to a known limitation with the GPU Operator's default values on CentOS, install the operator on CentOS 7/8
    using the following Helm command:

    .. code-block:: console

      $ helm install --wait --generate-name \
        nvidia/gpu-operator \
        --set toolkit.version=1.4.0-ubi8

    This issue will be fixed in the next release.

* Added support for airgapped enterprise environments.
* Added support for ``containerd`` as a container runtime under Kubernetes.

Improvements
-------------
* Updated DCGM-Exporter to ``2.1.2``, which uses DCGM 2.0.13.
* Added the ability to pass arguments to the NVIDIA device plugin to enable ``migStrategy`` and ``deviceListStrategy`` flags
  that allow addtional configuration of the plugin.
* Added more resiliency to ``dcgm-exporter``- ``dcgm-exporter`` would not check whether GPUs support profiling metrics and would result in a ``CrashLoopBackOff``
  state at launch in these configurations.

Fixed issues
------------
* Fixed the issue where the removal of the GPU Operator from the cluster required a restart of the Docker daemon (since the Operator
  sets the ``nvidia`` as the default runtime).
* Fixed volume mounts for ``dcgm-exporter`` under the GPU Operator to allow pod<->device metrics attribution.
* Fixed an issue where the GFD and ``dcgm-exporter`` container images were artificially limited to R450+ (CUDA 11.0+) drivers.

Known Limitations
------------------
* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.

----

1.3.0
=====

New Features
-------------
* Integrated `GPU Feature Discovery <https://github.com/NVIDIA/gpu-feature-discovery>`_ to automatically generate labels for GPUs leveraging NFD.
* Added support for Red Hat OpenShift 4.4+ (i.e. 4.4.29+, 4.5 and 4.6). The GPU Operator can be deployed from OpenShift OperatorHub. See the catalog
  `listing <https://catalog.redhat.com/software/operators/nvidia/gpu-operator/5ea882962937381642a232cd>`_ for more information.

Improvements
-------------
* Updated DCGM-Exporter to ``2.1.0`` and added profiling metrics by default.
* Added further capabilities to configure tolerations, node affinity, node selectors, pod security context, resource requirements through the ``ClusterPolicy``.
* Optimized the footprint of the validation containers images - the image sizes are now down to ~200MB.
* Validation images are now configurable for air-gapped installations.

Fixed issues
------------
* Fixed the ordering of the state machine to ensure that the driver daemonset is deployed before the other components. This fix addresses the issue
  where the NVIDIA container toolkit would be setup as the default runtime, causing the driver container initialization to fail.

Known Limitations
------------------
* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.

----

1.2.0
=====

New Features
-------------
* Added support for Ubuntu 20.04.z LTS.
* Added support for the NVIDIA A100 GPU (and appropriate updates to the underlying components of the operator).

Improvements
-------------
* Updated Node Feature Discovery (NFD) to 0.6.0.
* Container images are now hosted (and mirrored) on both `DockerHub <https://hub.docker.com/u/nvidiadocker.io>`_ and `NGC <https://ngc.nvidia.com/catalog/containers/nvidia:gpu-operator>`_.

Fixed issues
------------
* Fixed an issue where the GPU operator would not correctly detect GPU nodes due to inconsistent PCIe node labels.
* Fixed a race condition where some of the NVIDIA pods would start out of order resulting in some pods in ``RunContainerError`` state.
* Fixed an issue in the driver container where the container would fail to install on systems with the ``linux-gke`` kernel due to not finding the kernel headers.

Known Limitations
------------------
* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.

----

1.1.0
=====

New features
-------------
* DCGM is now deployed as part of the GPU Operator on OpenShift 4.3.

Improvements
-------------
* The operator CRD has been renamed to ``ClusterPolicy``.
* The operator image is now based on UBI8.
* Helm chart has been refactored to fix issues and follow some best practices.

Fixed issues
------------
* Fixed an issue with the toolkit container which would setup the NVIDIA runtime under ``/run/nvidia`` with a symlink to ``/usr/local/nvidia``.
  If a node was rebooted, this would prevent any containers from being run with Docker as the container runtime configured in ``/etc/docker/daemon.json``
  would not be available after reboot.
* Fixed a race condition with the creation of the CRD and registration.

----

1.0.0
=====

New Features
-------------
* Added support for Helm v3. Note that installing the GPU Operator using Helm v2 is no longer supported.
* Added support for Red Hat OpenShift 4 (4.1, 4.2 and 4.3) using Red Hat Enterprise Linux Core OS (RHCOS) and CRI-O runtime on GPU worker nodes.
* GPU Operator now deploys NVIDIA DCGM for GPU telemetry on Ubuntu 18.04 LTS

Fixed Issues
-------------
* The driver container now sets up the required dependencies on ``i2c`` and ``ipmi_msghandler`` modules.
* Fixed an issue with the validation steps (for the driver and device plugin) taking considerable time. Node provisioning times are now improved by 5x.
* The SRO custom resource definition is setup as part of the operator.
* Fixed an issue with the clean up of driver mount files when deleting the operator from the cluster. This issue used to require a reboot of the node, which is no longer required.

.. _operator-known-limitations-1.11.1:

Known Limitations
------------------

* After un-install of GPU Operator, NVIDIA driver modules might still be loaded. Either reboot the node or forcefully remove them using
  ``sudo rmmod nvidia nvidia_modeset nvidia_uvm`` command before re-installing GPU Operator again.
