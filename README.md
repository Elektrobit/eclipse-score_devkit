# Common DevContainer for Eclipse S-CORE
This repository contains the common [development container](https://containers.dev) for [Eclipse S-CORE](https://github.com/eclipse-score).
It contains all tools required to develop (modify, build, ...) Eclipse S-CORE.
All tool version are well-defined, and all tools are pre-configured to work as expected for Eclipse S-CORE development.
The container is pre-built in GitHub Actions as part of this repository, published, and ready for use.

Using the pre-built container in an Eclipse S-CORE repository is described in the [Usage](#usage) section.

Modifying the content of the container is explained in the [Development](#development) section.

## Usage

> **NOTE:** There are several development environments which support development containers; most notably [Visual Studio Code](https://code.visualstudio.com), but also [IntelliJ IDEA](https://www.jetbrains.com/idea) and others.
> See [here](https://containers.dev/supporting) for a more complete list.
> In the following, we assume that [Visual Studio Code](https://code.visualstudio.com) and its [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) is used.
The Dev Containers extension homepage as a description how to get up to speed on Windows, macOS and Linux operating systems.
From here on, we assume that such a development container setup is installed and running.

Add a file called `.devcontainer/devcontainer.json` to your repository.
It should contain the following:

````json
{
    "name": "eclipse-score_devkit",
    "image": "ghcr.io/elektrobit/eclipse-score_devkit:<version>",
    "initializeCommand": "mkdir -p ${localEnv:HOME}/.cache/bazel"
}
````

The `<version>` must be a valid, published release.

To start using the container, click the **Reopen in Container** button when prompted by Visual Studio Code:

![Reopen in Container](resources/reopen_in_container.png)

Alternatively, you can press Ctrl-Shift-P and run from there "Dev Containers: Reopen in Container".

The first time you do this, the container will be downloaded.
This may take some time.
Afterwards, Visual Studio Code should show this in the lower right corner of your window:

![Dev container success](resources/devcontainer_success.png)

Open a Terminal, and - for example - type `bazel build ...` to execute the default build of the repository.

Congratulations, you are now a dev container enthusiast 😊.

## Development

> **NOTE:** This is about the development of the DevContainer, not about development of Eclipse S-CORE using the DevContainer.

TODO: Write

## FAQ

How to upgrade the lockfile?

devcontainer upgrade --workspace-folder src/s-core-devcontainer/

TODO: Write more
