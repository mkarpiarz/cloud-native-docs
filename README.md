# NVIDIA Cloud Native Technologies Documentation

This is the documentation repository for software under the NVIDIA Cloud Native Technologies umbrella. The tools allow users to
build and run GPU accelerated containers with popular container runtimes such as Docker and orchestration platforms such as Kubernetes.

The product documentation portal can be found at: https://docs.nvidia.com/datacenter/cloud-native/index.html

## Building the Container

This step is optional.
As an alternative to building the container, you can run `docker pull registry.gitlab.com/nvidia/cloud-native/cnt-docs:0.1.0`.

Refer to <https://gitlab.com/nvidia/cloud-native/cnt-docs/container_registry> to find the most recent tag.

If you change the `Dockerfile`, build the container.
Use the `Dockerfile` in the repository (under the `docker` directory) to generate the custom doc build container.

1. Build the container:

   ```bash
   docker build --pull \
     --tag cnt-doc-builder \
     --file docker/Dockerfile .
   ```

1. Run the container from the previous step:

   ```bash
   docker run -it --rm \
     -v $(pwd):/work -w /work \
     cnt-doc-builder \
     bash
   ```

1. Build the docs:

   ```bash
   ./repo docs
   ```

   Alternatively, you can build just one docset, such as `gpu-operator` or `container-toolkit`:

   ```bash
   ./repo docs -p gpu-operator
   ```

The resulting HTML pages are located in the `_build/docs/.../latest/` directory of your repository clone.

More information about the `repo docs` command is available from
<http://omniverse-docs.s3-website-us-east-1.amazonaws.com/repo_docs/0.20.3/index.html>.

Additionally, the Gitlab CI for this project builds the documentation on every merge request and push to the default branch.
The under-development documentation from the default branch is available at <https://nvidia.gitlab.io/cloud-native/cnt-docs/review/latest/>.

## Releasing Documentation

### Configuration File Updates

1. Update the version in `repo.toml`:

   ```toml
   [repo_docs.projects.container-toolkit]
   docs_root = "${root}/container-toolkit"
   project = "container-toolkit"
   name = "NVIDIA Container Toolkit"
   version = "<new-version>"
   copyright_start = 2020
   ```

1. Update the version in `<component-name>/versions.json`:

   ```json
   {
    "latest": "1.13.1",
    "versions":
    [
        {
            "version": "1.13.1"
        },
        {
            "version": "1.12.1"
        }
    ]
   }
   ```

   These values control the menu at the bottom of the TOC and whether readers
   receive the banner warning about the latest version when readers view a page
   from an older release.

   We can prune the list to the six most-recent releases.
   The documentation for the older releases is not removed, readers are just
   less likely to browse the older releases.

### Special Branch Naming

Pushes to the default branch do not publish documentation on docs.nvidia.com.

Pushes to specially-named branches publish documentation to docs.nvidia.com.

Develop your work in a feature branch, open a merge request, and then merge to the default branch.

> **Important**: When you are confident that you are ready to publish from your commit,
> include `/latest` in your commit message on its own line.
> This line signals to CI that you want the documentation to update the latest
> documentation in addition to create a versioned directory.

At release time, create a branch from your commit---the commit with the `/latest` comment---and
name the branch according to the following pattern:

   ```text
   <component-name>-v<version>
   ```

   *Example*

   ```text
   gpu-operator-v23.3.1
   ```

Push the branch to the repository and CI builds the documentation in that branch---currently for all software components.
However, only the documentation for the `component-name` and specified version is updated on the web.


## License and Contributing

This documentation repository is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0).

Contributions are welcome. Refer to the [CONTRIBUTING.md](https://gitlab.com/nvidia/cloud-native/cnt-docs/-/blob/master/CONTRIBUTING.md) document for more
information on guidelines to follow before contributions can be accepted.
