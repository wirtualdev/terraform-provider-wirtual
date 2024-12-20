package provider

import (
	"context"
	"runtime"

	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)

func provisionerDataSource() *schema.Resource {
	return &schema.Resource{
		SchemaVersion: 1,

		Description: "Use this data source to get information about the Wirtual provisioner.",
		ReadContext: func(c context.Context, rd *schema.ResourceData, i interface{}) diag.Diagnostics {
			rd.SetId(uuid.NewString())
			rd.Set("os", runtime.GOOS)
			rd.Set("arch", runtime.GOARCH)
			// Fix for #11782: if we're on 32-bit ARM, set arch to armv7.
			if runtime.GOARCH == "arm" {
				rd.Set("arch", "armv7")
			}

			return nil
		},
		Schema: map[string]*schema.Schema{
			"os": {
				Type:        schema.TypeString,
				Computed:    true,
				Description: "The operating system of the host. This exposes `runtime.GOOS` (see [Go constants](https://pkg.go.dev/runtime#pkg-constants)).",
			},
			"arch": {
				Type:        schema.TypeString,
				Computed:    true,
				Description: "The architecture of the host. This exposes `runtime.GOARCH` (see [Go constants](https://pkg.go.dev/runtime#pkg-constants)).",
			},
		},
	}
}
