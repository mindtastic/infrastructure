## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.teleport](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.github](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name for the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_teleport_acme_email"></a> [teleport\_acme\_email](#input\_teleport\_acme\_email) | Email address for Email notifications from Let's Encrypt. | `string` | n/a | yes |
| <a name="input_teleport_domain"></a> [teleport\_domain](#input\_teleport\_domain) | Domain for teleport endpoint. | `string` | n/a | yes |
| <a name="input_teleport_github_client_id"></a> [teleport\_github\_client\_id](#input\_teleport\_github\_client\_id) | Client ID of GitHub OAuth app for Teleport login. | `string` | n/a | yes |
| <a name="input_teleport_github_client_secret"></a> [teleport\_github\_client\_secret](#input\_teleport\_github\_client\_secret) | Client Secret of GitHub OAuth app for Teleport login. | `string` | n/a | yes |
| <a name="input_teleport_github_org"></a> [teleport\_github\_org](#input\_teleport\_github\_org) | GitHub Organisation for Teleport login. | `string` | n/a | yes |

## Outputs

No outputs.
