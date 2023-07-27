.. license-header
  SPDX-FileCopyrightText: Copyright (c) 2023 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
  SPDX-License-Identifier: Apache-2.0

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

.. headings (h1/h2/h3/h4/h5) are # * = -

#################################
GPU Operator with Kata Containers
#################################

.. contents::
   :depth: 2
   :local:
   :backlinks: none


***************************************
About the Operator with Kata Containers
***************************************

.. note:: Technology Preview features are not supported in production environments
          and are not functionally complete.
          Technology Preview features provide early access to upcoming product features,
          enabling customers to test functionality and provide feedback during the development process.
          These releases may not have any documentation, and testing is limited.

Sandboxed containers are similar, but subtly different from traditional containers such as a Docker container.

A traditional container packages software for user-space isolation from the host,
but the container runs on the host and shares the operating system kernel with the host.
Sharing the operating system kernel is a potential vulnerability.

A sandboxed container runs in a virtual machine on the host.
The virtual machine has a separate operating system and operating system kernel.
Hardware virtualization and a separate kernel provide improved workload isolation
in comparison with traditional containers.

The NVIDIA GPU Operator works with the Kata container runtime.
Kata uses a hypervisor, like QEMU, to provide a lightweight virtual machine with a single purpose--to run a Kubernetes pod.

The following diagram shows the software components that Kubernetes uses to run a sandboxed container.

.. mermaid::
   :caption: Software Components with Kata Container Runtime
   :alt: Logical diagram of software components between Kubelet and containers when using sandboxed containers.

   flowchart LR
     a[Kubelet] --> b[CRI] --> c[Kata\nRuntime] --> d[Lightweight\nQEMU VM] --> e[Lightweight\nGuest OS] --> f[Pod] --> g[Container]


NVIDIA supports sandboxed containers with Kata by installing the Confidential Containers Operator.
The Confidential Containers Operator installs the Kata runtime and QEMU.

About NVIDIA Kata Manager
=========================

When you configure the GPU Operator for sandbox workloads with Kata, the Operator
deploys NVIDIA Kata Manager as an operand.

The manager downloads an NVIDIA optimized Linux kernel image and initial RAM disk that
provides the lightweight operating system for the virtual machines run in QEMU.
These artifacts are downloaded from the NVIDIA container registry, nvcr.io, on each worker node.

The manager also configures each worker node with a runtime class, ``kata-qemu-nvidia-gpu``,
and configures containerd for the runtime class.

NVIDIA Kata Manager Custom Resource
===================================

The following part of the cluster policy shows the fields related to the manager:

.. code-block:: yaml

   kataManager:
     enabled: true
     config:
       artifactsDir: /opt/nvidia-gpu-operator/artifacts/runtimeclasses
       runtimeClasses:
       - artifacts:
           pullSecret: ""
           url: nvcr.io/nvidia/cloud-native/kata-gpu-artifacts:ubuntu22.04-525
         name: kata-qemu-nvidia-gpu
         nodeSelector: {}
       - artifacts:
           pullSecret: ""
           url: nvcr.io/nvidia/cloud-native/kata-gpu-artifacts:ubuntu22.04-535-snp
         name: kata-qemu-nvidia-gpu-snp
         nodeSelector: {}
     repository: nvcr.io/nvidia/cloud-native
     image: k8s-kata-manager
     version: v0.1.0
     imagePullPolicy: IfNotPresent
     imagePullSecrets: []
     env: []
     resources: {}

The ``kata-qemu-nvidia-gpu-snp`` runtime class is used with confidential computing
and is installed by default.


*********************************
Benefits of Using Kata Containers
*********************************

The primary benefits of sandbox containers are as follows:

* Running untrusted workloads in a container.
  The virtual machine provides a layer of defense against the untrusted code.

* Limiting access to hardware devices such as NVIDIA GPUs.
  The virtual machine is provided access to specific devices.
  This approach ensures that the workload cannot access additional devices.

* Transparent deployment of unmodified containers.

****************************
Limitations and Restrictions
****************************

* GPUs are available to containers as a single GPU in passthrough mode only.
  Multi-GPU passthrough and vGPU are not supported.

* Support is limited to initial installation and configuration only.
  Upgrade and configuration of existing clusters for Kata Containers is not supported.

* Support for Kata Containers is limited to the implementation described on this page.
  The Operator does not support Red Hat OpenShift sandbox containers.

* Uninstalling the GPU Operator or the NVIDIA Kata Manager does not remove the files
  that the manager downloads and installs in the ``/opt/nvidia-gpu-operator/artifacts/runtimeclasses/kata-qemu-nvidia-gpu/``
  directory on the worker nodes.

* NVIDIA supports the Operator and Kata Containers with the containerd runtime only.


*************
Prerequisites
*************

* Your hosts are configured to enable hardware virtualization.
  Enabling this feature is typically performed by configuring the host BIOS.

* Your hosts are configured to support IOMMU.

  If the output from running ``ls /sys/kernel/iommu_groups`` includes ``0``, ``1``, and so on,
  then your host is configured for IOMMU.

  If the host is not configured or you are unsure, add the ``intel_iommu=on`` Linux kernel command-line argument.
  For most Linux distributions, you add the argument to the ``/etc/default/grub`` file:

  .. code-block:: text

     ...
     GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on modprobe.blacklist=nouveau"
     ...

  On Ubuntu systems, run ``sudo update-grub`` after making the change to configure the bootloader.
  On other systems, you might need to run ``sudo dracut`` after making the change.
  Refer to the documentation for your operating system.
  Reboot the host after configuring the bootloader.

* You have a Kubernetes cluster and you have cluster administrator privileges.


********************************************
Install the Confidential Containers Operator
********************************************

Perform the following steps to install and verify the Confidential Containers Operator:

#. Set the Operator version in an environment variable:

   .. code-block:: console

      $ export VERSION=v0.7.0

#. Install the Operator:

   .. code-block:: console

      $ kubectl apply -k "github.com/confidential-containers/operator/config/release?ref=${VERSION}"

   *Example Output*

   .. code-block:: output

      namespace/confidential-containers-system created
      customresourcedefinition.apiextensions.k8s.io/ccruntimes.confidentialcontainers.org created
      serviceaccount/cc-operator-controller-manager created
      role.rbac.authorization.k8s.io/cc-operator-leader-election-role created
      clusterrole.rbac.authorization.k8s.io/cc-operator-manager-role created
      clusterrole.rbac.authorization.k8s.io/cc-operator-metrics-reader created
      clusterrole.rbac.authorization.k8s.io/cc-operator-proxy-role created
      rolebinding.rbac.authorization.k8s.io/cc-operator-leader-election-rolebinding created
      clusterrolebinding.rbac.authorization.k8s.io/cc-operator-manager-rolebinding created
      clusterrolebinding.rbac.authorization.k8s.io/cc-operator-proxy-rolebinding created
      configmap/cc-operator-manager-config created
      service/cc-operator-controller-manager-metrics-service created
      deployment.apps/cc-operator-controller-manager create

#. (Optional) View the pods and services in the ``confidental-containers-system`` namespace:

   .. code-block:: console

      $ kubectl get pod,svc -n confidential-containers-system

   *Example Output*

   .. code-block:: output

      NAME                                                 READY   STATUS    RESTARTS   AGE
      pod/cc-operator-controller-manager-c98c4ff74-ksb4q   2/2     Running   0          2m59s

      NAME                                                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
      service/cc-operator-controller-manager-metrics-service   ClusterIP   10.98.221.141   <none>        8443/TCP   2m59s

#. Install the sample Confidential Containers runtime:

   .. code-block:: sample

      $ kubectl apply -k "github.com/confidential-containers/operator/config/samples/ccruntime/default?ref=${VERSION}"

   *Example Output*

   .. code-block:: output

      ccruntime.confidentialcontainers.org/ccruntime-sample created

   Wait approximately 10 minutes for the Operator to create the base runtime classes.

#. (Optional) View the runtime classes:

   .. code-block:: console

      $ kubectl get runtimeclass

   *Example Output*

   .. code-block:: output

      NAME            HANDLER         AGE
      kata            kata            13m
      kata-clh        kata-clh        13m
      kata-clh-tdx    kata-clh-tdx    13m
      kata-qemu       kata-qemu       13m
      kata-qemu-sev   kata-qemu-sev   13m
      kata-qemu-snp   kata-qemu-snp   13m
      kata-qemu-tdx   kata-qemu-tdx   13m


*******************************
Install the NVIDIA GPU Operator
*******************************

Procedure
=========

Perform the following steps to install the Operator for use with sandboxed containers:

#. Add and update the NVIDIA Helm repository:

   .. code-block:: console

      $ helm repo add nvidia https://helm.ngc.nvidia.com/nvidia \
         && helm repo update

#. (Optional) To limit which nodes run Kata Containers, instead of cluster-wide configuration, label the nodes:

   .. code-block:: console

      $ kubectl label node <node-name> nvidia.com/gpu.workload.config=vm-passthrough

#. Specify at least the following sandbox workloads and Kata manager options when you install the Operator.

   * Limit Kata Containers to labelled nodes only:

     .. code-block:: console

        $ helm install --wait --generate-name \
           -n gpu-operator --create-namespace \
           nvidia/gpu-operator \
           --set sandboxWorkloads.enabled=true \
           --set kataManager.enabled=true

   * Run Kata Containers cluster-wide on all nodes:

     .. code-block:: console

        $ helm install --wait --generate-name \
           -n gpu-operator --create-namespace \
           nvidia/gpu-operator \
           --set sandboxWorkloads.enabled=true \
           --set sandboxWorkloads.defaultWorkload=vm-passthrough \
           --set kataManager.enabled=true

   *Example Output*

   .. code-block:: output

      NAME: gpu-operator
      LAST DEPLOYED: Tue Jul 25 19:19:07 2023
      NAMESPACE: gpu-operator
      STATUS: deployed
      REVISION: 1
      TEST SUITE: None


Verification
============

#. Verify that the Kata manager and VFIO manager operands are running:

   .. code-block:: console

      $ kubectl get pods -n gpu-operator

   *Example Output*

   .. code-block:: output
      :emphasize-lines: 7,10

      NAME                                                         READY   STATUS      RESTARTS   AGE
      gpu-operator-57bf5d5769-nb98z                                1/1     Running     0          6m21s
      gpu-operator-node-feature-discovery-master-b44f595bf-5sjxg   1/1     Running     0          6m21s
      gpu-operator-node-feature-discovery-worker-lwhdr             1/1     Running     0          6m21s
      nvidia-kata-manager-bw5mb                                    1/1     Running     0          3m36s
      nvidia-sandbox-device-plugin-daemonset-cr4s6                 1/1     Running     0          2m37s
      nvidia-sandbox-validator-9wjm4                               1/1     Running     0          2m37s
      nvidia-vfio-manager-vg4wp                                    1/1     Running     0          3m36s

#. Verify that the ``kata-qemu-nvidia-gpu`` runtime class is available:

   .. code-block:: console

      $ kubectl get runtimeclass

   *Example Output*

   .. code-block:: output
      :emphasize-lines: 6, 7

      NAME                       HANDLER                    AGE
      kata                       kata                       37m
      kata-clh                   kata-clh                   37m
      kata-clh-tdx               kata-clh-tdx               37m
      kata-qemu                  kata-qemu                  37m
      kata-qemu-nvidia-gpu       kata-qemu-nvidia-gpu       96s
      kata-qemu-nvidia-gpu-snp   kata-qemu-nvidia-gpu-snp   96s
      kata-qemu-sev              kata-qemu-sev              37m
      kata-qemu-snp              kata-qemu-snp              37m
      kata-qemu-tdx              kata-qemu-tdx              37m
      nvidia                     nvidia                     97s


#. (Optional) If you have host access to the worker node, you can perform the following steps:

   #. Confirm that the host uses the ``vfio-pci`` kernel module for GPUs:

      .. code-block:: console

         $ lspci -nnk -d 10de:

      *Example Output*

      .. code-block:: output
         :emphasize-lines: 3

         65:00.0 3D controller [0302]: NVIDIA Corporation GA102GL [A10] [10de:2236] (rev a1)
                 Subsystem: NVIDIA Corporation GA102GL [A10] [10de:1482]
                 Kernel driver in use: vfio-pci
                 Kernel modules: nvidiafb, nouveau

   #. Confirm that Kata manager installed the ``kata-qemu-nvidia-gpu`` runtime class files:

      .. code-block:: console

         $ ls -1 /opt/nvidia-gpu-operator/artifacts/runtimeclasses/kata-qemu-nvidia-gpu/

      *Example Output*

      .. code-block:: output

         configuration-nvidia-gpu-qemu.toml
         kata-ubuntu-jammy-nvidia-gpu.initrd
         vmlinuz-5.xx.x-xxx-nvidia-gpu
         ...


*********************
Run a Sample Workload
*********************

A pod specification for a Kata Container requires the following:

* Specify a Kata runtime class.

* Specify a passthrough GPU resource.

#. Determine the passthrough GPU resource names:

   .. code-block:: console

      kubectl get nodes -l nvidia.com/gpu.present -o json | \
        jq '.items[0].status.allocatable |
          with_entries(select(.key | startswith("nvidia.com/"))) |
          with_entries(select(.value != "0"))'

   *Example Output*

   .. code-block:: output

      {
         "nvidia.com/GA102GL_A10": "1"
      }

#. Create a file, such as ``cuda-vectoradd-kata.yaml``, like the following example:

   .. code-block:: yaml
      :emphasize-lines: 6, 13

      apiVersion: v1
      kind: Pod
      metadata:
        name: cuda-vectoradd-kata
        annotations:
          cdi.k8s.io/gpu: "nvidia.com/pgpu=0"
      spec:
        runtimeClassName: kata-qemu-nvidia-gpu
        restartPolicy: OnFailure
        containers:
        - name: cuda-vectoradd
          image: "nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda11.7.1-ubuntu20.04"
        resources:
          limits:
            "nvidia.com/GA102GL_A10": 1

#. Create the pod:

   .. code-block:: console

      $ kubectl apply -f cuda-vectoradd-kata.yaml

#. View the logs from pod:

   .. code-block:: console

      $ kubectl logs -n default cuda-vectoradd-kata

   *Example Output*

   .. code-block:: output

      [Vector addition of 50000 elements]
      Copy input data from the host memory to the CUDA device
      CUDA kernel launch with 196 blocks of 256 threads
      Copy output data from the CUDA device to the host memory
      Test PASSED
      Done

#. Delete the pod:

   .. code-block:: console

      $ kubectl delete -f cuda-vectoradd-kata.yaml


About the Pod Annotation
========================

The ``cdi.k8s.io/gpu: "nvidia.com/pgpu=0"`` annotation is used when the pod sandbox is created.
The annotation ensures that the virtual machine created by the Kata runtime is created with
the correct PCIe topology so that GPU passthrough succeeds.

The annotation refers to a Container Device Interface (CDI) device, ``nvidia.com/pgpu=0``.
The ``pgpu`` indicates passthrough GPU and the ``0`` indicates the device index.
The index is defined by the order that the GPUs are enumerated on the PCI bus.
The index does not correlate to a CUDA index.

The NVIDIA Kata Manager creates a CDI specification on the GPU nodes.
The file includes a device entry for each passthrough device.

In the following sample ``/var/run/cdi/nvidia.com-pgpu.yaml`` file shows one GPU that
is bound to the VFIO PCI driver:

.. code-block:: yaml

   cdiVersion: 0.5.0
   containerEdits: {}
   devices:
   - containerEdits:
       deviceNodes:
       - path: /dev/vfio/10
   name: "0"
   kind: nvidia.com/pgpu