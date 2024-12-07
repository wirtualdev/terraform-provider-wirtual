package provider_test

import (
	"runtime"
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
	"github.com/stretchr/testify/require"
	"github.com/wirtualdev/terraform-provider-wirtual/provider"
)

func TestProvisioner(t *testing.T) {
	t.Parallel()
	resource.Test(t, resource.TestCase{
		Providers: map[string]*schema.Provider{
			"wirtual": provider.New(),
		},
		IsUnitTest: true,
		Steps: []resource.TestStep{{
			Config: `
			provider "wirtual" {
			}
			data "wirtual_provisioner" "me" {
			}`,
			Check: func(state *terraform.State) error {
				require.Len(t, state.Modules, 1)
				require.Len(t, state.Modules[0].Resources, 1)
				resource := state.Modules[0].Resources["data.wirtual_provisioner.me"]
				require.NotNil(t, resource)

				attribs := resource.Primary.Attributes
				require.Equal(t, runtime.GOOS, attribs["os"])
				if runtime.GOARCH == "arm" {
					require.Equal(t, "armv7", attribs["arch"])
				} else {
					require.Equal(t, runtime.GOARCH, attribs["arch"])
				}
				return nil
			},
		}},
	})
}
