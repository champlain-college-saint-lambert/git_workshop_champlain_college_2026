# Configuring a Windows Work Environment for Cloud-Native Development

When working in enterprise environments, it is common to have a Windows machine as your primary development environment. However, many of the tools and technologies used in cloud-native development are designed to run in a Linux environment. By using WSL with Ubuntu, you can bridge this gap and create a more seamless development experience.

Using WSL with Ubuntu allows you to run a Linux environment directly on your Windows machine, which is more compatible with Git and Docker. This will help you avoid issues that can arise when using Windows-native tools and commands.

Windows is actively trying to bridge the gap between Windows and Linux environments, but there are still some limitations and challenges that developers may face. By using WSL with Ubuntu, you can take advantage of the best of both worlds and create a more efficient and effective development environment.

## WSL Installation

If you currently run Docker on your Windows machine, you probably have WSL installed already as Docker Desktop uses WSL2 as its backend. If you do not have WSL installed, you can follow the official Microsoft documentation to install it: [Install WSL](https://docs.microsoft.com/en-us/windows/wsl/install).

When completing the installation for Docker Desktop you are propted to install WSL but post installation it is not used. An easy check to see if WSL is installed is to run the following command in your terminal:

```powershell
wsl --list --verbose
```

From the output you should see a list of installed distributions. If you do not see any distributions, you will need to install Ubuntu from the Microsoft Store.

```powershell
wsl --install
```

## Setting up your development environment

I would recommend using the Ubuntu distribution for your development environment. You can install it with the following command if you dont have it installed already:

```powershell
wsl --install -d Ubuntu
```

Once installed, you can launch it and set up your development environment.

From the ubuntu terminal, you can start by installing the necessary tools and dependencies for your development work. This may include Git, Docker, and any other tools you need for your specific projects.

An important step is to configure your Git settings, such as your user name and email address. You can do this by running the following commands in the Ubuntu terminal:

```bash
git config --global user.name "Your Name"
git config --global user.email "example@domain.com"
```

This is important because you should be doing all code development in the Ubuntu environment and not in Windows. This will ensure that your Git commits are properly attributed to you and that your development environment is consistent with the Linux environment used in deployment environments.

There are many other gains in the fact that the line endings are consistent with the Linux environment. This will help avoid issues with line endings when working with other developers and when deploying your applications and more.

Note that you should then be using the "Remote Development" features in your IDE's to connect to the Ubuntu environment and do your development work there. This will ensure that you are working in a consistent environment and that your code is properly attributed to you in Git. If you are using VS Code, you can install the "Remote - WSL" extension to connect to your Ubuntu environment and work on your projects seamlessly. For IntelliJ, you can use the "Remote Development" plugin to connect to your Ubuntu environment and work on your projects.

## Note on Dev Containers

Dev Containers are a great way to create a consistent development environment across different machines and platforms. They allow you to define your development environment in a Dockerfile and share it with your team. This can help avoid issues with dependencies and configurations that can arise when working on different machines.

When using Dev Containers, you can define your development environment in a Dockerfile and use it to create a containerized development environment. This can help ensure that your development environment is consistent across different machines and platforms.

The "Remote - Containers" extension in VS Code allows you to connect to a Dev Container and work on your projects seamlessly. You can also use the "Remote Development" plugin in IntelliJ to connect to a Dev Container and work on your projects.

Additional Resources:
WSL tips from Microsoft: [WSL Tips](https://code.visualstudio.com/docs/remote/troubleshooting#_dev-containers-tips)
Dev Containers tips from Microsoft: [Dev Containers Tips](https://code.visualstudio.com/docs/devcontainers/tips-and-tricks)
