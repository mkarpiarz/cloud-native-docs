.. headings # #, * *, =, -, ^, "

.. |prod-name-long| replace:: Mirantis Kubernetes Engine
.. |prod-name-short| replace:: MKE

#########################################
|prod-name-long| with the NVIDIA GPU Operator
#########################################

.. contents::
   :depth: 2
   :local:
   :backlinks: none


*********************************************
About |prod-name-short| with the GPU Operator
*********************************************

Mirantis Kubernetes Engine (MKE) gives you the power to build, run, and scale cloud-native
applications---the way that works for you.
Increase developer efficiency and release frequency while reducing cost.

The NVIDIA GPU Operator uses the operator framework within Kubernetes to automate
both the deployment and management of all NVIDIA software components needed to provision NVIDIA GPUs.
These components include the NVIDIA GPU drivers to enable CUDA, Kubernetes device plugin for GPUs,
the NVIDIA Container Toolkit, automatic node labeling using GFD, DCGM based monitoring and others.


******************************
Validated Configuration Matrix
******************************

|prod-name-long| has self-validated with the following components and versions:

.. list-table::
   :header-rows: 1

   * - Version
     - | NVIDIA
       | GPU
       | Operator
     - | Operating
       | System
     - | Container
       | Runtime
     - Kubernetes
     - Helm
     - NVIDIA GPU
     - Hardware Model

   * - FIXME
     - v23.3.1
     - | FIXME
       | FIXME 20.04
     - FIXME
     - FIXME
     - FIXME
     - | NVIDIA HGX H100
       | NVIDIA H100
       | NVIDIA A100
     - | FIXME
       | FIXME
       | FIXME


*************
Prerequisites
*************

* A running MKE cluster that is configured with at least one control plane and two worker nodes.
  The recommended configuration is at least three control plane nodes and at least two worker nodes.

* At least one worker node with an NVIDIA GPU physically installed.
  The GPU Operator can locate the GPU and label the node accordingly.

* A seed node to connect to the MKE instance, with Helm 3.x installed on the seed node.

* The kubeconfig file for the MKE cluster on the seed node.
  You can get the file from the MKE web interface by downloading a client bundle.
  The configuration is in the ``kube.yml`` file.

  Alternatively, if the MKE cluster is a managed cluster of an Mirantis Container Cloud (MCC) instance,
  you can use the MCC management console to get the kubeconfig file.
  In this case, the MKE web interface can be accessed from the MCC web interface.
  You can get the kubeconfig file for the managed cluster directly from the MCC web interface.

* You have an MKE administrator user name and password, and you have the MKE host URL.


*********
Procedure
*********

Perform the following steps to prepare the MKE cluster:

#. MKE does not apply a label to worker nodes.
   Ensure that the worker nodes are labeled:

   .. code-block:: console

      $ kubectl label node <node-name> node-role.kubernetes.io/worker=''

   *Example Output*

   .. code-block:: output

      node/demo-node labeled

#. Create the namespace for the GPU Operator:

   .. code-block:: console

      $ kubectl create ns gpu-operator

   *Example Output*

   .. code-block:: output

      namespace/gpu-operator created

#. Store the credentials and connection information in environment variables:

   .. code-block:: console

      $ export MKE_USERNAME=<mke-username> \
          MKE_PASSWORD=<mke-password> \
          MKE_HOST=<mke-fqdn-or-ip-address>

#. Get an API key from MKE so that you can make API calls later:

   .. code-block:: console

      $ AUTHTOKEN=$(curl --silent --insecure --data \
          '{"username":"'$MKE_USERNAME'","password":"'$MKE_PASSWORD'"}' \
          https://$MKE_HOST/auth/login | jq --raw-output .auth_token)

#. Download the MKE configuration file:

   .. code-block:: console

      $ curl --silent --insecure -X GET "https://$MKE_HOST/api/ucp/config-toml" \
          -H "accept: application/toml" -H "Authorization: Bearer $AUTHTOKEN"  \
          > mke-config-gpu.toml

#. Edit the ``mke-config-gpu.toml`` file and update the values like the following example:

   .. code-block:: toml

      priv_attributes_allowed_for_user_accounts = ["hostbindmounts", "privileged", "hostPID"]
  	   priv_attributes_user_accounts = ["gpu-operator:gpu-operator"]
      priv_attributes_allowed_for_service_accounts = ["hostbindmounts", "privileged",
        "hostIPC", "hostPID"]
      priv_attributes_service_accounts = ["gpu-operator:nvidia-gpu-feature-discovery",
        "gpu-operator:nvidia-driver", "gpu-operator:nvidia-container-toolkit",
        "gpu-operator:nvidia-operator-validator", "gpu-operator:nvidia-device-plugin",
        "gpu-operator:nvidia-dcgm-exporter", "gpu-operator:nvidia-mig-manager"]

#. Upload the edited MKE configuration file:

   .. code-block:: console

      $ curl --silent --insecure -X PUT -H "accept: application/toml" \
          -H "Authorization: Bearer $AUTHTOKEN" --upload-file 'mke-config-gpu.toml' \
          https://$MKE_HOST/api/ucp/config-toml

The MKE cluster is ready for you to install the GPU Operator with Helm.
Refer to :ref:`install-gpu-operator` for more information.

****************************************************
Verifying |prod-name-short| with the GPU Operator
****************************************************

-  View the nodes and number of NVIDIA GPUs on each node:

   .. code-block:: console

      $ kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPUs:.metadata.labels.nvidia\.com/gpu\.count"

   *Example Output*

   .. code-block:: output

      NAME        GPUs
      demo-node   4
      ...

   A response like the preceding example indicates that the GPU Operator and
   operands are running correctly.


Refer to :ref:`Running Sample GPU Applications` to verify the installation.


***************
Getting Support
***************

Refer to the MKE product documentation for information about working with MKE.

If you experience an issue with the NVIDIA GPU Operator,
open an issue on GitHub and request assistance from @FIXME: https://github.com/NVIDIA/gpu-operator/issues


*******************
Related information
*******************

* https://docs.mirantis.com/mke/3.6/overview.html
