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

.. Date: Mar 15 2022
.. Author: smerla

.. _install-precompiled-signed-drivers:

Installing Precompiled and Canonical Signed Drivers on Ubuntu 20.04 and 22.04
*****************************************************************************

GPU Operator supports deploying NVIDIA precompiled and signed drivers from Canonical on Ubuntu 20.04 and 22.04 (x86 platform only). This is required
when nodes are enabled with Secure Boot. In order to use these, GPU Operator needs to be installed with options ``--set driver.version=<DRIVER_BRANCH>-signed``.

.. code-block:: console

   $ helm install --wait gpu-operator \
        -n gpu-operator --create-namespace \
        nvidia/gpu-operator \
        --set driver.version=<DRIVER_BRANCH>-signed

supported DRIVER_BRANCH value currently are ``470``, ``510`` and ``515`` which will install latest drivers available on that branch for current running
kernel version.

Following are the packages used in this case by the driver container.

* linux-objects-nvidia-${DRIVER_BRANCH}-server-${KERNEL_VERSION} - Linux kernel nvidia modules.
* linux-signatures-nvidia-${KERNEL_VERSION} - Linux kernel signatures for nvidia modules.
* linux-modules-nvidia-${DRIVER_BRANCH}-server-${KERNEL_VERSION} - Meta package for nvidia driver modules, signatures and kernel interfaces.
* nvidia-utils-${DRIVER_BRANCH}-server - NVIDIA driver support binaries.
* nvidia-compute-utils-${DRIVER_BRANCH}-server - NVIDIA compute utilities (includes nvidia-persistenced).

.. note::

   * Before upgrading kernel on the worker nodes please ensure that above packages are available for that kernel version, else upgrade will
     cause driver installation failures.

.. include:: common-precompiled-check.rst

