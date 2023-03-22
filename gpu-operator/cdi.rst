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

######################################################
Container Device Interface Support in the GPU Operator
######################################################

.. contents::
   :depth: 2
   :local:
   :backlinks: none

************************************
About the Container Device Interface
************************************

The Container Device Interface (CDI) is a specification for container runtimes
such as cri-o, containerd, and podman that standardizes access to complex
devices like NVIDIA GPUs by the container runtimes.
CDI support is provided by the NVIDIA Container Toolkit and the Operator extends
that support for Kubernetes clusters.

Use of CDI is transparent to cluster administrators and application developers.
The benefits of CDI are largely to reduce development and support for runtime-specific
plugins.

NVIDIA recommends enabling CDI during installation or post-installation configuration.

One possible exposure of CDI to administrators and developers is the ability to
specify which container runtime to use when creating a pod specification.
See :ref:`Specifying the Runtime Class for a Pod` for an example.


********************************
Enabling CDI During Installation
********************************

Follow the installation to use Helm for installing the Operator on the :doc:`operator-install-guide` page.

When you install the Operator with Helm, specify the ``--set cdi.enabled=true`` argument.
Optionally, also specify the ``--set cdi.default=true`` argument to use the CDI runtime class by default for workloads.


**********************************
Configuring CDI After Installation
**********************************

Prerequisites
=============

* You installed version 22.3.0 or newer.
* (Optional) Confirm that the only runtime class is ``nvidia`` by running the following command:

  .. code-block:: console

     $ kubectl get runtimeclasses

  **Example Output**

  .. code-block:: output

     NAME     HANDLER   AGE
     nvidia   nvidia    47h


Procedure
=========

To configure CDI as the default runtime class, perform the following steps:

#. Enable CDI by modifying the cluster policy:

   .. code-block:: console

     $ kubectl patch clusterpolicy/cluster-policy --type='json' \
         -p='[{"op": "replace", "path": "/spec/cdi/enabled", "value":true}]'

   *Example Output*

   .. code-block:: output

    clusterpolicy.nvidia.com/cluster-policy patched

#. (Optional) Set CDI as the default runtime class by modifying the cluster policy:

   .. code-block:: console

     $ kubectl patch clusterpolicy/cluster-policy --type='json' \
         -p='[{"op": "replace", "path": "/spec/cdi/default", "value":true}]'

   *Example Output*

   .. code-block:: output

     clusterpolicy.nvidia.com/cluster-policy patched

#. (Optional) Confirm that the container toolkit and device plugin pods restart:

   .. code-block:: console

     $ kubectl get pods -n gpu-operator

   *Example Output*

   .. literalinclude:: ./manifests/output/cdi-get-pods-restart.txt
      :language: output

#. Verify that the runtime classes include nvidia-cdi and nvidia-legacy:

   .. code-block:: console

     $ kubectl get runtimeclasses

   *Example Output*

   .. literalinclude:: ./manifests/output/cdi-verify-get-runtime-classes.txt
      :language: output


**************************************
Specifying the Runtime Class for a Pod
**************************************

You can run the following steps to verify that CDI is enabled or as a
routine practice if you did not set CDI as the default runtime class.

#. Create a file, such as ``cuda-vectoradd-cdi.yaml``, with contents like the following example:

   .. literalinclude:: ./manifests/input/cuda-vectoradd-cdi.yaml
      :language: yaml

#. (Optional) Create a temporary namespace:

   .. code-block:: console

     $ kubectl create ns cdi-verify

   *Example Output*

   .. code-block:: output

     namespace/cdi-verify created

#. Start the pod:

   .. code-block:: console

    $ kubectl apply -n cdi-verify -f cuda-vectoradd-cdi.yaml

   *Example Output*

   .. code-block:: output

     pod/cuda-vectoradd created

#. View the logs from the pod:

   .. code-block:: console

     $ kubectl logs -n cdi-verify cuda-vectoradd

   *Example Output*

   .. literalinclude:: ./manifests/output/common-cuda-vectoradd-logs.txt
      :language: output

#. Delete the temporary namespace:

  .. code-block:: console

    $ kubectl delete ns cdi-verify

  *Example Output*

  .. code-block:: output

    namespace "cdi-verify" deleted
