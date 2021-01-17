# Template for Kustomize projects

[Kustomize Documentation](https://kubectl.docs.kubernetes.io/references/kustomize/).

It has been created a minimal content for the project, which could be used as
template for the needed Kustomize projects. Many of the features are not used
but the documentation about it and the exaples from the documentation are
copied for providing a quick kick-off.

## Getting started

> You need to be logged in an OpenShift cluster.

- Create your namespace by `oc new-project`.
- Add your resources to the `config/base` directory.
- Check the resources with `make lint`.
- Create the resources with `make create`.
- Delete the resources with `make delete`.
