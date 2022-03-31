# Swift Bundler templates

This repository houses Swift Bundler's built-in templates.

## Overview

### Templates

A valid template must contain a `Template.toml` metadata file in its root directory.

**All indentation must be tabs (not spaces) so that the `create` command's `--indentation` option functions correctly**

If a file or directory contains `{{PACKAGE}}` in its name, that will get replaced with the new package's name before copying. If a file ends with `.template`, any occurrences of `{{PACKAGE}}` within its contents will be updated before copying. All other files are copied as is.

Regular templates must not be named `Base` ([see Base template](#base-template)) and must not start with a `.`.

### Base template

The `Base` folder contains files that are copied into every new project (with the same processing applied as files from a regular template). Note that the `Base` template should not contain a `Template.toml` file. To override the contents of a file in `Base` for a specific template, just provide the modified version in the template.

## Contributing

If you want to fix/tweak an existing template or add a new one, feel free! Just make sure to read [the contributing guidelines](CONTRIBUTING.md) first.