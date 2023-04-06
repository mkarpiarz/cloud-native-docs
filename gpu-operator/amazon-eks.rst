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

###################################
NVIDIA GPU Operator with Amazon EKS
###################################

.. contents::
   :depth: 2
   :local:
   :backlinks: none


****************************************
About Using the Operator with Amazon EKS
****************************************

You can use the NVIDIA GPU Operator with Amazon Elastic Kubernetes Service (EKS),
but you must use an operating system that is supported by the Operator.

By default, Amazon EKS configures nodes with the Amazon Linux 2 operating system.
Amazon Linux 2 is not supported by the Operator.

To use a supported operating system, such as Ubuntu 22.04 or 20.04, configure your
Amazon EKS cluster with an unmanaged node group.
The Amazon EKS documentation refers to these nodes as self-managed Linux nodes.

When you create the unmanaged node group, you specify the Amazon EKS optimized
Amazon Machine Image (AMI) that is specific to an AWS region and Kubernetes version.
See https://cloud-images.ubuntu.com/aws-eks/ for the AMI values such as ``ami-00687acd80b7a620a``.

By selecting the AMI, you can customize which NVIDIA software components are
installed by the GPU Operator at deployment time.
For example, the Operator can deploy GPU driver containers and use the Operator
to manage the lifecycle of the NVIDIA software components.


*************
Prerequisites
*************

* You installed and configured the AWS CLI.
  Refer to
  `Installing or updating to the latest version of the AWS CLI <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>`_
  and `Configuring the AWS CLI <https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html>`_
  in the AWS CLI documentation.
* You installed the ``eksctl`` CLI.
  The CLI is available from https://eksctl.io/introduction/#installation.
  If you prefer to use the AWS Management Console, refer to the :ref:`Related Information` section for
  Amazon EKS documentation resources.
* You have the AMI value from https://cloud-images.ubuntu.com/aws-eks/.
* You have the EC2 instance type to use for your nodes.
  Refer to the table of `Accelerated Computing <https://aws.amazon.com/ec2/instance-types/#Accelerated_Computing>`_
  instance types in the Amazon EC2 documentation.


*********
Procedure
*********

Perform the following steps to create an Amazon EKS cluster with the ``eksctl`` CLI.
The steps create a node group that uses an Amazon EKS optimized AMI.


#. Create a file, such as ``cluster-config.yaml``, with contents like the following example:

   .. literalinclude:: ./manifests/input/amazon-eks-cluster-config.yaml
      :language: yaml

   Replace the values for the cluster name, Kubernetes version, and so on.
   To resolve the environment variables in the override bootstrap command, you must source the bootstrap helper script.

#. Create the Amazon EKS cluster with the unmanaged node group:

   .. code-block:: console

      $ eksctl create -cluster -f cluster-config.yaml

   Creating the cluster requires several minutes.

   *Example Output*

   .. code-block:: output

      2022-08-19 17:51:04 [i]  eksctl version 0.105.0
      2022-08-19 17:51:04 [i]  using region us-west-2
      2022-08-19 17:51:04 [i]  setting availability zones to [us-west-2d us-west-2c us-west-2a]
      2022-08-19 17:51:04 [i]  subnets for us-west-2d - public:192.168.0.0/19 private:192.168.96.0/19
      ...
      [✓]  EKS cluster "demo-cluster" in "us-west-2" region is ready

#. Optional: View the cluster name:

   .. code-block:: console

      $ eksctl get cluster

   *Example Output*

   .. code-block:: output

      NAME          REGION     EKSCTL CREATED
      demo-cluster  us-west-2  True


**********
Next Steps
**********

* By default, ``eksctl`` adds the Kubernetes configuration information to your
  ``~/.kube/config`` file.
  You can run ``kubectl get nodes -o wide`` to view the nodes in the Amazon EKS cluster.

* You are ready to :ref:`install the NVIDIA GPU Operator <install-gpu-operator>`
  with Helm.

  If you specified a Kubernetes version less than ``1.25``, then specify ``--set psp.enabled=true``
  when you run the ``helm install`` command.


*******************
Related Information
*******************

* The preceding procedure is derived from
  `Getting started with Amazon EKS - eksctl <https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html>`_
  in the Amazon EKS documentation.
* If you have an existing Amazon EKS cluster, you can refer to
  `Launching self-managed Amazon Linux nodes <https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html>`_
  in the Amazon EKS documentation to add an unmanaged node group to your cluster.
  This documentation includes steps for using the AWS Management Console.