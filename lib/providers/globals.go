package providers

import (
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
)

// Check if directory exists, if not, create it
func ValidateDir(dirName string) error {
	err := os.Mkdir(dirName, 0755)
	if err == nil {
		return nil
	}
	if os.IsExist(err) {
		// check that the existing path is a directory
		info, err := os.Stat(dirName)
		if err != nil {
			return err
		}
		if !info.IsDir() {
			return errors.New("path exists but is not a directory\n")
		}
		return nil
	}
	return err
}

func Fetch(provider string) {
	cmd := exec.Command("cloudquery", "fetch", provider, "--enable-console-log")

	stdoutStderr, err := cmd.CombinedOutput()

	fmt.Printf("%s\n", stdoutStderr)

	if err != nil {
		log.Fatal(err)
	}
}
