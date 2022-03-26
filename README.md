# Swift Bundler templates

This repository houses Swift Bundler's built-in templates.

## Overview

### Templates

A valid template must contain a `Template.toml` metadata file in its root directory.

If a file or directory contains `{{TARGET}}` in its name, that will get replaced with the new package's name before copying. If a file ends with `.template`, any occurrences of `{{TARGET}}` within its contents will be updated before copying. All other files are copied as is.

### Base

The `Base` folder contains files that are copied into every new project. To override the contents of a file in `Base` for a specific template, just provide the modified version in the template.

## Contributing

If you want to fix/tweak an existing template or add a new one, feel free! Just make sure to read [the contributing guidelines](CONTRIBUTING.md) first.