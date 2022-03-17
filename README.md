# Genesys Multicloud CX private edition - Platform samples

The purpose of this repository is to provide pretested sample platform reference architectures for deploying Genesys Multicloud CX private edition containers and Helm charts to Kubernetes clusters for Demos, Labs or Proof of Concepts.  The content provided in this repository can not be used for QA or Production environments as it is not designed to meet typical HA, DR, multi-region or Security requirements.  All content is being provided AS-IS without any SLA, warranty or coverage via Genesys product support.

This repository contains sample Infrastructure as Code using Terraform for:

* [GKE on Google Cloud](/gcp-gke)
* [Azure Red Hat OpenShift](/azure-openshift)

## Repository Structure

<pre>
multicloud-platform
|
├── .github
│   └── ISSUE_TEMPLATE
│       ├── bug-report.md
│       ├── documentation-issue.md
│       └── feature-request.md
|
├── doc
│   ├── CONTRIBUTE.md
│   └── STYLE.md
|
├── azure-openshift
│   ├── tfm
│   │   ├── [terraform_modules]  -  like "0-remotestate", "1-network", ...
│   |   |   ├── *.tf
│   |   |   └── USAGE.md  -  Output from tfdocs w/ details on all inputs
│   |   └── README.md  -  Overview of each module and order of execution
│   ├── terraform
│   │   ├── [region]  -  like "westus2" w/o project name
│   │   |   ├── [terraform_steps]  -  like "0-remotestate", "1-network", ...
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   ├── [helm_chart].tf - if deploying Helm charts, then the value overrides per chart
│   |   |   |   └── USAGE.md  -  Details on all inputs that must be modified
│   |   |   └── README.md  -  Details on all inputs that must be modified
│   |   └── README.md  -  Overview of each module and order of execution for global and one or more regions
│   └── README.md  -  Overview of platform architecture, prerequisites and usage
|
├── gcp-gke
│   ├── tfm
│   │   ├── [terraform_modules]  -  like "0-remotestate", "1-network", ...
│   |   |   ├── *.tf
│   |   |   └── USAGE.md  -  Output from tfdocs w/ details on all inputs
│   |   └── README.md  -  Overview of each module and order of execution
│   ├── terraform
│   │   ├── [region]  -  like "uswest1" w/o project name
│   │   |   ├── [terraform_steps]  -  like "0-remotestate", "1-network", ...
│   |   |   |   ├── main.tf
│   |   |   |   ├── variables.tf
│   |   |   |   ├── [helm_chart].tf - if deploying Helm charts, then the value overrides per chart
│   |   |   |   └── USAGE.md  -  Details on all inputs that must be modified
│   |   |   └── README.md  -  Details on all inputs that must be modified
│   |   └── README.md  -  Overview of each module and order of execution for global and one or more regions
│   └── README.md  -  Overview of platform architecture, prerequisites and usage
|
└── Other platforms - Future/TBD
</pre>

## Related Sites

All service and product documentation can be found at [docs.genesys.com](https://docs.genesys.com)

For installing Genesys products and services, please checkout [Genesys Multicloud Services repository](https://github.com/genesys/multicloud-services)

## Issues

Find known issues and resolved ones in our [GitHub Issues tracker](https://github.com/genesys/multicloud-platform/issues)

## Roadmap

Upcoming features and accepted issues will be tracked in our [GitHub Project](https://github.com/genesys/multicloud-platform/projects/1)

## FAQ

Find solutions to common problems in our [GitHub Wiki](https://github.com/genesys/multicloud-platform/wiki)

### Here is a sample issue someone had

  Cause: This is the root cause to the issue.

  Solution: Here is how you'd fix this issue.

## Contributing

We are excited to work alongside our community.

**BEFORE you begin work**, please read & follow our [Contribution Guidelines](/doc/CONTRIBUTE.md) to help avoid duplicate effort.

## Communicating with the Team

The easiest way to communicate with the team is via [GitHub Issues](https://github.com/genesys/multicloud-platform/issues/new/choose)

Please file new issues, feature requests and suggestions, but **please search for similar open/closed pre-existing issues before creating a new issue.**

## License

All content in this repository is released under the [MIT License](LICENSE)
