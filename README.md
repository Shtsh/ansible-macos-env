# Shtsh's MacOS user configuration ansible

## Features

* Installs applications from homebrew
* Installs applications from AppStore (requires app login first)
* Installs GUI applications using homebrew cask
* Sets ups the configuration files

## Usage

### Full install
```bash
/usr/bin/pip3 install ansible --user
ansible-playbook -i inventory main.yaml
```

### Full install without appstore
```bash
/usr/bin/pip3 install ansible --user
ansible-playbook -i inventory main.yaml --skip-tags appstore
```

### Only reresh configs
```bash
ansible-playbook -i inventory main.yaml --tags configs
```
