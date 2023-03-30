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

.. headings # #, * *, =, -, ^, "

.. _install-precompiled-drivers:

#############################
Precompiled Driver Containers
#############################


***********************************
About Precompiled Driver Containers
***********************************

.. note:: Technology Preview features are not supported with in production environments
          and are not functionally complete.
          Technology Preview features provide early access to upcoming product features,
          enabling customers to test functionality and provide feedback during the development process.
          These releases may not have any documentation, and testing is limited.


Containers with precompiled drivers do not require internet access to download Linux kernel
header files, GCC compiler tooling, or operating system packages.

Using precompiled drivers also avoids the burst of compute demand that is required
to compile the kernel drivers with the conventional driver containers.

These two benefits are valuable to most sites, but are especially beneficial to sites
with restricted internet access or sites with resource-constrained hardware.


Limitations and Restrictions
============================

* Support for deploying the driver containers with precompiled drivers is limited to
  hosts with Ubuntu 20.04 or 22.04 operating systems, x86_64 architecture, and
  the ``generic`` kernel variant.

* NVIDIA supports precompiled driver containers for the most recently released long-term
  servicing branch (LTSB) driver branches 525 and 530.

* Precompiled driver containers do not support NVIDIA vGPU or GPUDirect Storage (GDS).


*****************************************************************
Enabling Precompiled Driver Container Support During Installation
*****************************************************************

Follow the instructions for installing the Operator with Helm on the :doc:`operator-install-guide` page.

Specify the ``--set driver.usePrecompiled=true`` argument like the following example command:

.. code-block:: console

   $ helm install --wait gpu-operator \
        -n gpu-operator --create-namespace \
        nvidia/gpu-operator \
        --set driver.usePrecompiled=true


***********************************
Enabling Support After Installation
***********************************

Perform the following steps to enable support for precompiled driver containers:

#. Enable support by modifying the cluster policy:

   .. code-block:: console

     $ kubectl patch clusterpolicy/cluster-policy --type='json' \
         -p='[{"op": "replace", "path": "/spec/driver/usePrecompiled", "value":true}]'

   *Example Output*

   .. code-block:: output

    clusterpolicy.nvidia.com/cluster-policy patched

#. (Optional) Confirm that the driver daemonset pods terminate:

   .. code-block:: console

     $ kubectl get pods -n gpu-operator

   *Example Output*

   .. literalinclude:: ./manifests/output/precomp-driver-terminating.txt
      :language: output
      :emphasize-lines: 11

#. Confirm that the driver container pods are running:

   .. code-block:: console

      $ kubectl get pods -l app=nvidia-driver-daemonset -n gpu-operator

   *Example Output*

   .. literalinclude:: ./manifests/output/precomp-driver-running.txt
      :language: output

   Ensure that the pod names include a Linux kernel semantic version number like ``5.15.0-69``.


***************************************************
Disabling Support for Precompiled Driver Containers
***************************************************

Perform the following steps to disable support for precompiled driver containers:

#. Disable support by modifying the cluster policy:

   .. code-block:: console

     $ kubectl patch clusterpolicy/cluster-policy --type='json' \
         -p='[{"op": "replace", "path": "/spec/driver/usePrecompiled", "value":false}]'

   *Example Output*

   .. code-block:: output

    clusterpolicy.nvidia.com/cluster-policy patched


#. Confirm that the conventional driver container pods are running:

   .. code-block:: console

      $ kubectl get pods -l app=nvidia-driver-daemonset -n gpu-operator

   *Example Output*

   .. literalinclude:: ./manifests/output/precomp-driver-conventional-running.txt
      :language: output

   Ensure that the pod names do not include a Linux kernel semantic version number.


**********************************************************
Determining if a Precompiled Driver Container is Available
**********************************************************

.. include:: common-precompiled-check.rst
