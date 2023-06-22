.. Date: November 11 2022
.. Author: elezar

.. headings (h1/h2/h3/h4/h5) are # * = -

As of the ``v1.12.0`` release the NVIDIA Container Toolkit includes support for generating `Container Device Interface <https://github.com/container-orchestrated-devices/container-device-interface>`_ (CDI) specificiations
for use with CDI-enabled container engines and CLIs. These include:

* `cri-o <https://github.com/container-orchestrated-devices/container-device-interface#cri-o-configuration>`_
* `containerd <https://github.com/container-orchestrated-devices/container-device-interface#containerd-configuration>`_
* `podman <https://github.com/container-orchestrated-devices/container-device-interface#podman-configuration>`_

The use of CDI greatly improves the compatibility of the NVIDIA container stack with certain features such as rootless containers.

Step 1: Install NVIDIA Container Toolkit
========================================

In order to generate CDI specifications for the NVIDIA devices available on a system, only the base components of the NVIDIA Container Toolkit are required.

This means that the instructions for configuring the NVIDIA Container Toolkit repositories should be followed as normal, but instead of
installing the ``nvidia-container-toolkit`` package, the ``nvidia-container-toolkit-base`` package should be installed instead:

.. tabs::

    .. tab:: Ubuntu LTS

        .. code-block:: console

            $ sudo apt-get update \
                && sudo apt-get install -y nvidia-container-toolkit-base

    .. tab:: CentOS / RHEL

        .. code-block:: console

            $ sudo dnf clean expire-cache \
                && sudo dnf install -y nvidia-container-toolkit-base

This should include the NVIDIA Container Toolkit CLI (``nvidia-ctk``) and the version can be confirmed by running:

.. code-block:: console

    $ nvidia-ctk --version


Step 2: Generate a CDI specification
====================================

In order to generate a CDI specification that refers to all devices, the following command is used:

.. code-block:: console

    $ sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

To check the names of the generated devices the following command can be run:

.. code-block:: console

    $ grep "  name:" /etc/cdi/nvidia.yaml

.. note::

    This is run as ``sudo`` to ensure that the file at ``/etc/cdi/nvidia.yaml`` can be created.
    If an ``--output`` is not specified, the generated specification will be printed to ``STDOUT``.

.. note::

    Two typical locations for CDI specifications are ``/etc/cdi/`` and ``/var/run/cdi``, but the exact paths may depend on the CDI consumers (e.g. container engines) being used.

.. note::

    If the device or CUDA driver configuration is changed a new CDI specification must be generated. A configuration change could occur when MIG devices are created or removed, or when the driver is upgraded.


Step 3: Using the CDI specification
===================================

.. note::

    The use of CDI to inject NVIDIA devices may conflict with the use of the NVIDIA Container Runtime hook. This means that if a ``/usr/share/containers/oci/hooks.d/oci-nvidia-hook.json`` file exists, it should be deleted or care should be taken to not run containers with the ``NVIDIA_VISIBLE_DEVICES`` environment variable set.


The use of the CDI specification is dependent on the CDI-enabled container engine or CLI being used. In the case of ``podman``, for example, releases as of ``v4.1.0`` include support for specifying CDI devices in the ``--device`` flag. Assuming that the specification has been generated as above, running a container with access to all NVIDIA GPUs would require the following command:

    .. code-block:: console

        $ podman run --rm --device nvidia.com/gpu=all ubuntu nvidia-smi -L

which should show the same output as ``nvidia-smi -L`` run on the host.

The CDI specification also contains references to individual GPUs or MIG devices and these can be requested as desired by specifying their names when launching a container as follows:

    .. code-block:: console

        $ podman run --rm --device nvidia.com/gpu=gpu0 --device nvidia.com/gpu=mig1:0 ubuntu nvidia-smi -L

Where the full GPU with index 0 and the first MIG device on GPU 1 is requested. The output should show only the UUIDs of the requested devices.

Using CDI in non-CDI-enabled runtimes
=====================================

In order to support runtimes which do not natively support CDI, the NVIDIA Container Runtime can be configured in a ``cdi`` mode.
In this mode, the NVIDIA Container Runtime will not inject the NVIDIA Container Runtime Hook into the incoming OCI runtime specification, but instead
perform the injection of the requested CDI devices itself.

The mode can be toggled by updating the ``nvidia-container-runtime.mode`` option in the NVIDIA Container Runtime config to ``"cdi"``.

Running the following command should do this on most systems:

    .. code-block:: console

        $ sed -i 's/mode = "auto"/mode = "cdi"/g' /etc/nvidia-container-runtime/config.toml

When CDI mode is enabled in the NVIDIA Container Runtime, the devices specified in the ``NVIDIA_VISIBLE_DEVICES`` environment variable are treated as CDI device IDs.
If these are not fully-qualified CDI device names, a CDI device kind is prepended to the specified ID. If these are specified as fully-qualified CDI device names, they are used as-is.

The default CDI class that is used as a prefix is ``nvidia.com/gpu``. This can be changed by setting the ``nvidia-container-runtime.modes.cdi.default-kind`` option in the NVIDIA Container Runtime config.

Using Docker as an example of a non-CDI-enabled runtime, the following command should now use CDI to inject the requested devices into the container:

    .. code-block:: console

        $ docker run --rm -ti --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all ubuntu nvidia-smi -L

Note that this assumes that the CDI specifications have been generated for all available NVIDIA GPUs using the ``nvidia-ctk cdi generate`` command, and the NVIDIA Container Runtime is configured as
a runtime for Docker.

Note that using the NVIDIA Container Runtime Hook is not supported in CDI mode, and as such specifying the ``--gpus`` flag on the Docker command line in addition to the ``--runtime`` in this case
results in an error.
