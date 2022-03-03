package main

import "C"

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
)

// String to indicate provider folder
var awsSubFolder string = "/.agem" // "/.aaaa" a temp placeholder for "/.aws"

// Check if directory exists, if not, create it
func ensureDir(dirName string) error {
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

// Create the credentials file at provided location: "Users/username/.aws/credential"
func SetCredentials(credentials string) {
	homePath, error := os.UserHomeDir()
	if error != nil {
		fmt.Println(homePath, error)
	}

	val := ensureDir(homePath + awsSubFolder)

	filename := homePath + awsSubFolder + "/credentials"

	if val != nil {
		fmt.Println(val)
	}

	err := ioutil.WriteFile(filename, []byte(
		credentials,
	), 0777)
	if err != nil {
		fmt.Printf("Unable to write file: %v\n", err)
	} else {
		fmt.Printf("Credential file created at root\n")
	}
}

// Create the config file at provided location: "Users/username/.aws/config"
func SetConfig(config string) {
	homePath, error := os.UserHomeDir()
	if error != nil {
		fmt.Println(homePath, error)
	}

	val := ensureDir(homePath + awsSubFolder)

	filename := homePath + awsSubFolder + "/config"

	if val != nil {
		fmt.Println(val)
	}

	err := ioutil.WriteFile(filename, []byte(
		config,
	), 0777)
	if err != nil {
		fmt.Printf("Unable to write file: %v\n", err)
	} else {
		fmt.Printf("Config file created at root\n")
	}
}

func Cloudquery() {
	cmd := exec.Command("cloudquery", "fetch", "--enable-console-log")

	// err := cmd.Run()
	stdoutStderr, err := cmd.CombinedOutput()

	fmt.Printf("%s\n", stdoutStderr)

	if err != nil {
		log.Fatal(err)
	}
}

//export QueryAWS
func QueryAWS(credentials, config string) int {
	// Main AWS function exported to Ruby

	SetCredentials(credentials)
	SetConfig(config)
	// Cloudquery()

	return 1 // 0 if fail. Easier to send int than boolean
}

func main() {}
