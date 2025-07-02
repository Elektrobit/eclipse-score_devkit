# Common DevContainer for Eclipse S-CORE
This repository contains the common [development container](https://containers.dev) for [Eclipse S-CORE](https://github.com/eclipse-score).
It contains all tools required to develop (modify, build, ...) Eclipse S-CORE.
All tool version are well-defined, and all tools are pre-configured to work as expected for Eclipse S-CORE development.
The container is [pre-built](https://containers.dev/guide/prebuild) in GitHub Actions as part of this repository, tested, published, and ready for use.

Using the pre-built container in an Eclipse S-CORE repository is described in the [Usage](#usage) section.

Modifying the content of the container is explained in the [Development](#development) section.

## Usage

> **NOTE:** There are several development environments which support development containers; most notably [Visual Studio Code](https://code.visualstudio.com), but also [IntelliJ IDEA](https://www.jetbrains.com/idea) and others.
> See [here](https://containers.dev/supporting) for a more complete list.
> In the following, we assume that [Visual Studio Code](https://code.visualstudio.com) and its Dev Containers extension is used.
The [Dev Containers extension homepage](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) has a description how to get up to speed on Windows, macOS and Linux operating systems.
From here on, we assume that such a development container setup is installed and running.

Add a file called `.devcontainer/devcontainer.json` to your repository.
It should contain the following:

````json
{
    "name": "eclipse-s-core",
    "image": "ghcr.io/elektrobit/eclipse-score_devkit:<version>",
    "initializeCommand": "mkdir -p ${localEnv:HOME}/.cache/bazel"
}
````

The `<version>` must be a [valid, published release](https://github.com/Elektrobit/eclipse-score_devkit/tags).
The `initializeCommand` is required to ensure the default Bazel cache directory exists on your host system.

To start using the container, click the **Reopen in Container** button when prompted by Visual Studio Code:

![Reopen in Container](resources/reopen_in_container.png)

Alternatively, you can press Ctrl-Shift-P and run from there "Dev Containers: Reopen in Container".

The first time you do this, the container will be downloaded.
This may take some time.
Afterwards, Visual Studio Code should show this in the lower right corner of your window:

![Dev container success](resources/devcontainer_success.png)

Open a Terminal, and - for example - type `bazel build ...` to execute the default build of the repository.

To enable the C++ [language server](https://microsoft.github.io/language-server-protocol/) (`clangd`) to support C++ navigation and auto-completion together with Visual Studio Code, use the pre-configured [Task](https://code.visualstudio.com/docs/debugtest/tasks) "Update compile_commands.json" (via "Terminal" -> "Run Task...").
This will create a file called [`compile_commands.json`](https://clang.llvm.org/docs/JSONCompilationDatabase.html), which is the base for `clangd` to start indexing the source code.

Congratulations, you are now a dev container enthusiast 😊.

## Development

> **NOTE:** This is about the development *of the DevContainer*, not about development of Eclipse S-CORE *using* the DevContainer.

The [Eclipse S-CORE](https://github.com/eclipse-score) development container is developed using - a development container!
That means, the usage is similarly simple:

````
git clone https://github.com/eclipse-score/devcontainer.git
code devcontainer
````
and "Reopen in Container".

### Repository Structure
Ordered by importance:

* `src/s-core-devcontainer/` contains the sources for the Eclipse S-CORE DevContainer.
It uses pre-existing [DevContainer features](https://containers.dev/implementors/features/) to provide some standard tools like Git, Rust, and LLVM.
In addition, it uses a so-called "local" feature (cf. `src/s-core-devcontainer/.devcontainer/s-core-local`) for the remaining tools and configuration.
* `scripts/` contains scripts to build, test and publish the container.
* `.devcontainer/` contains the definition of the DevContainer for **this** repository, i.e. the "devcontainer devcontainer".
There should rarely be a need to modify this.
* `.github/` contains the regular GitHub setup, with code owners and CI.
* `resources/` contains a few screenshots.

### Modify, Build, Test, Use

It is very simple to develop the development container.
You can change files related to the container and then simply run the `scripts/*`.
They are used by the CI, but especially the build and test scripts can be run also locally out of the box:
````console
$ ./scripts/build.sh
[... build output..]
{"outcome":"success","imageName":["vsc-s-core-devcontainer-209943ec6ff795f57b20cdf85a70c904d1e3b4a329d1e01c79f0ffea615c6e40-features"]}

$ ./scripts/test.sh
[... test output...]
💯  All passed!
````
You can now also use this development container locally on your machine, e.g. to test the container as part of an Eclipse S-CORE module.
For this you must understand that you have the following situation:
```
+---------------------------------+
|   Development Container A       |
|  +---------------------------+  |
|  | S-CORE DevContainer image |  |
|  +---------------------------+  |
+---------------------------------+
```
`Development Container A` is the one you are running right now to develop the `S-CORE DevContainer` .
So in order to execute `S-CORE DevContainer`  on your host (and test it as part of an S-CORE module), you need to

* export this newly built S-CORE DevContainer image
* import the image on your host machine
* use the image name in the `.devcontainer/devcontainer.json` of the targeted S-CORE module

Concretely, this can be done as follows:

* Run `docker save <imageName> > export.img` in `Development Container A`.
For example, given above build output, this would be `docker save vsc-s-core-devcontainer-209943ec6ff795f57b20cdf85a70c904d1e3b4a329d1e01c79f0ffea615c6e40-features > export.img`
* On your **host machine** (!!), open a console and run `docker load < /path/to/export.img`.
* In the working copy of the targeted S-CORE module, edit the file `.devcontainer/devcontainer.json` and change the `"image": "..."` entry to `"image": "<imageName>"`.
Given above build output, this would be `"image": "vsc-s-core-devcontainer-209943ec6ff795f57b20cdf85a70c904d1e3b4a329d1e01c79f0ffea615c6e40-features"`.
The Visual Studio Code instance related to the targeted S-CORE module will now ask you to rebuild the DevContainer.
Do so, and you have a running instance of `S-CORE DevContainer`  related to the targeted S-CORE module.
