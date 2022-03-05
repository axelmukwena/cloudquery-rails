package main

import "C"
import (
	"cloudquery/providers"
)

// Main provider functions exported to Ruby

//export QueryAWS
func QueryAWS(awsString string) int {
	ifSuccess := providers.AWS(awsString)
	return ifSuccess
}

//export QueryGCP
func QueryGCP(gcpString string) int {
	ifSuccess := providers.GCP(gcpString)
	return ifSuccess
}

func main() {}
