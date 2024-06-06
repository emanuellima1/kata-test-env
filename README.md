# Kata Test Environment

This repository contains an automated test environment that provisions a local VM with the necessary dependencies to build and test Kata Containers.

## Requisites

- Install the latest version of [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation);
- Install a virtualization product such as [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

Vagrant support for `libvirt` is kind of a let down, so I chose `VirtualBox` for this script. In any case, it's easy to modify the `Vagrantfile` to make it use `libvirt` instead.

## Usage

Simply do `vagrant up` from the root of this repository. This will provision the VM with all the necessary dependencies. Once that is finished, do `vagrant ssh` from the root of the repository to enter the VM. There will be a `synced_data` folder in the home of the VM that mirrors the `synced_data` folder in this repo. One should clone the specific `kata-containers` fork in question on this folder in order to edit it using the host and compile and test it using the guest.

When you're done with your work, do `vagrant halt` from the host or `sudo shutdown now` from the guest to gracefully shutdown the VM. You could also do `vagrant suspend` from the host in order to save the current running state of the VM and resume work faster. In any case, to resume working do `vagrant up`.

If you want to eliminate the VM completely to start over, do `vagrant destroy` from the host.

If when provisioning a VM you get an error from VirtualBox such as "A VirtualBox machine with the name 'fedora-40-kata-test-env' already exists", do `VBoxManage unregistervm fedora-40-kata-test-env --delete-all`.

[Click here](https://developer.hashicorp.com/vagrant/docs/cli) to see a complete documentation of the Vagrant CLI.

Once you have your environment provisioned, simply clone your fork of `kata-containers` on the `synced_data` folder, navigate to `kata-containers/src/runtime-rs` and do `make`. After compilation is finished, the binary to be tested is `containerd-shim-kata-v2` and will be located at `target/x86_64-unknown-linux-musl/release`.

In order to test it, you will need three things:

- A container image, preferably small. I usually use `busybox`. To store it locally for repeated use, do `sudo ctr image pull "docker.io/library/busybox:latest"` on the guest;
- A `kata-static` tarball. You'll generally get this artifact as the result of a CI run on [Github](https://github.com/kata-containers/kata-containers/actions/);
- A `configuration-qemu.toml` file. You can use the model on this repo. On that TOML you'll have to declare the location of 3 binaries, `path`, `kernel` and `image` like this model does.
