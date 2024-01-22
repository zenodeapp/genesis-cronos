package client

import (
	govclient "github.com/cosmos/cosmos-sdk/x/gov/client"

	"github.com/alpha-omega-labs/genesis-crypto/x/cronos/client/cli"
)

// ProposalHandler is the token mapping change proposal handler.
var ProposalHandler = govclient.NewProposalHandler(cli.NewSubmitTokenMappingChangeProposalTxCmd)
