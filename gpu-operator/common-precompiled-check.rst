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

..
    This file intentionally does not include a heading.

Before you upgrade the Linux kernel on the worker nodes, you can ensure that
a precompiled driver is available for that kernel version.

If a precompiled driver is not available, then you can remain on the older Linux kernel
or you can disable support for precompiled driver containers and use conventional driver containers.

* Check if precompiled driver support for a specific kernel version is available:

  .. https://ubuntu.com/server/docs/package-management

  .. code-block:: console

     $ KERNEL_VERSION=$(uname -r)  # 5.15.0-69-generic
     $ DRIVER_BRANCH=525
     $ sudo apt update
     $ sudo apt show linux-modules-nvidia-${DRIVER_BRANCH}-server-${KERNEL_VERSION}

  *Example Output*

  The following example output shows a successful response for Linux kernel 5.15.0-69 and driver branch 525.

  .. code-block:: output

     Package: linux-modules-nvidia-525-server-5.15.0-69-generic
     Version: 5.15.0-69.76
     Priority: optional
     Section: restricted/kernel
     Source: linux-restricted-modules
     Origin: Ubuntu
     Maintainer: Canonical Kernel Team <kernel-team@lists.ubuntu.com>
     Bugs: https://bugs.launchpad.net/ubuntu/+filebug
     Installed-Size: 34.8 kB
     Depends: debconf (>= 0.5) | debconf-2.0, linux-image-5.15.0-69-generic | linux-image-unsigned-5.15.0-69-generic, linux-signatures-nvidia-5.15.0-69-generic (= 5.15.0-69.76), linux-objects-nvidia-525-server-5.15.0-69-generic (= 5.15.0-69.76), nvidia-kernel-common-525-server (>= 525.85.12)
     Download-Size: 7026 B
     APT-Sources: http://us.archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages
     Description: Linux kernel nvidia modules for version 5.15.0-69
      This package pulls together the Linux kernel nvidia modules for
      version 5.15.0-69 with the appropriate signatures.
      .
      You likely do not want to install this package directly. Instead, install the
      one of the linux-modules-nvidia-525-server-generic* meta-packages,
      which will ensure that upgrades work correctly, and that supporting packages are
      also installed.


  The following example shows a failure response for Linux kernel 5.15.0-58 and driver branch 525.

  .. code-block:: output

     N: Unable to locate package linux-modules-nvidia-525-server-5.15.0-58
     N: Couldn't find any package by glob 'linux-modules-nvidia-525-server-5.15.0-58'
     N: Unable to locate package linux-modules-nvidia-525-server-5.15.0-58
     N: Couldn't find any package by glob 'linux-modules-nvidia-525-server-5.15.0-58'
     E: No packages found


..
