# Kata Test Environment

This repository contains an automated test environment that provisions a local VM with the necessary dependencies to build and test Kata Containers.

## Requisites

- Install the latest version of [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation);
- Install the [Fedora virtualization stack](https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/).
- Make sure you have the latest versions of `GCC` and `Make`;
- Install the `vagrant-libvirt` [plugin](https://vagrant-libvirt.github.io/vagrant-libvirt/installation.html#fedora);
  - Generally it suffices to do `vagrant plugin install vagrant-libvirt`.

## Usage

Simply do `vagrant up` from the root of this repository. This will provision the VM with all the necessary dependencies. Once that is finished, do `vagrant ssh` from the root of the repository to enter the VM. There will be a `/home/root/synced_data` folder in the VM that mirrors the `synced_data` folder in this repo. One should clone the specific `kata-containers` fork in question on this folder in order to edit it using the host and compile and test it using the guest.

When you're done with your work, do `vagrant halt` from the host or `shutdown now` from the guest to gracefully shutdown the VM. You could also do `vagrant suspend` from the host in order to save the current running state of the VM and resume work faster. In any case, to resume working do `vagrant up`.

If you want to eliminate the VM completely to start over, do `vagrant destroy` from the host.

[Click here](https://developer.hashicorp.com/vagrant/docs/cli) to see a complete documentation of the Vagrant CLI.

Once you have your environment provisioned, simply clone your fork of `kata-containers` on the `synced_data` folder, navigate to `kata-containers/src/runtime-rs` and do `make`. After compilation is finished, the binary to be tested is `containerd-shim-kata-v2` and will be located at `target/x86_64-unknown-linux-musl/release`.

In order to test it, you will need three things:

- A container image, preferably small. I usually use `busybox`. To store it locally for repeated use, do `sudo ctr image pull "docker.io/library/busybox:latest"` on the guest;
- A `kata-static` tarball. You'll generally get this artifact as the result of a CI run of your PR on [Github](https://github.com/kata-containers/kata-containers/actions/);
- A `configuration-qemu.toml` file. You can use the model on this repo. On that TOML you'll have to declare the location of 3 binaries, `path`, `kernel` and `image` like this model does.
- A `config.toml` file. You can use the model on this repo. That TOML configures `containerd` to use your recently built Kata. You should copy it to `/etc/containerd/` at the guest after editing it.
