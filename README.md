# Shtsh's MacOS user configuration ansible

## Features

* Installs applications from homebrew
* Installs applications from AppStore (requires app login first)
* Installs GUI applications using homebrew cask

## Usage

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install ansible
ansible-playbook -i inventory main.yaml
```
