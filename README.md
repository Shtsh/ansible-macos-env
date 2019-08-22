# Shtsh's MacOS user configuration ansible

## Features

* Installs homebrew
* Installs applications from homebrew
* Installs applications from AppStore (requires app login first)
* Installs GUI applications using homebrew cask
* Configures zsh (geometry theme + custom plugins)
* Configures emacs

## Usage

```bash
ansible-galaxy install -r requirements.yaml
ansible-playbook -i inventory main.yaml
```