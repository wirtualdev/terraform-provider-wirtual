package provider_test

import (
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
	"github.com/stretchr/testify/require"

	"github.com/wirtualdev/terraform-provider-wirtual/provider"
)

func TestWorkspaceTags(t *testing.T) {
	resource.Test(t, resource.TestCase{
		Providers: map[string]*schema.Provider{
			"wirtual": provider.New(),
		},
		IsUnitTest: true,
		Steps: []resource.TestStep{{
			Config: `
			provider "wirtual" {
			}
			data "wirtual_parameter" "animal" {
				name = "animal"
				type = "string"
				default = "chris"
			}
			data "wirtual_workspace_tags" "wt" {
				tags = {
					"cat" = "james"
					"dog" = data.wirtual_parameter.animal.value
				}
			}`,
			Check: func(state *terraform.State) error {
				require.Len(t, state.Modules, 1)
				require.Len(t, state.Modules[0].Resources, 2)
				resource := state.Modules[0].Resources["data.wirtual_workspace_tags.wt"]
				require.NotNil(t, resource)

				attribs := resource.Primary.Attributes
				require.Equal(t, "james", attribs["tags.cat"])
				require.Equal(t, "chris", attribs["tags.dog"])
				return nil
			},
		}},
	})
}
