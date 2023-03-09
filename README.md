# NVIDIA Cloud Native Technologies Documentation

This is the documentation repository for software under the NVIDIA Cloud Native Technologies umbrella. The tools allow users to
build and run GPU accelerated containers with popular container runtimes such as Docker and orchestration platforms such as Kubernetes.

The product documentation portal can be found at: https://docs.nvidia.com/datacenter/cloud-native/index.html

## Building Documentation

Use the `Dockerfile` in the repository (under the ``docker`` directory) to generate the custom doc build container. The `Dockerfile` is based
off the official `sphinxdoc` container and includes some customizations (e.g. the `sphinx-copybutton`).

1. Build the container:

   ```bash
   docker build --pull \
      --tag cnt-doc-builder \
      --file docker/Dockerfile assets/
   ```

1. Start the container:

   ```bash
   docker run -it --rm \
     -v $(pwd):/work \
     -w /work \
     -u $(id -u):$(id -g) \
     cnt-doc-builder
   ```

   The prompt in the container resembles the following example:

   ```output
   I have no name!@f96daeb7d8e4:/work$
   ```

1. Build the documentation:

   ```shell
   make html
   ```

   The HTML is created in the `_build/html` directory of the cloned repository.

## Previewing Documentation from an MR

After you create a merge requrest, CI builds the documentation for your MR.

Browse the `build_docs` build job and navigate through the build artifacts to the HTML.
Paste the URL to the changed pages in a comment for your MR.

Each time you push a new commit to the MR, you need to repeat the process of
navigating the build artifacts to find the HTML and paste the URL into your MR.

## License and Contributing

This documentation repository is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0).

Contributions are welcome. Refer to the [CONTRIBUTING.md](https://gitlab.com/nvidia/cloud-native/cnt-docs/-/blob/master/CONTRIBUTING.md) document for more
information on guidelines to follow before contributions can be accepted.
