// based on:
//  - https://www.reddit.com/r/swaywm/comments/d1tksf/i_made_a_keyboard_layout_switcher_for_swaywaybar/
//  - https://github.com/ericonr/dotfiles/blob/master/sourcecode/keyboard_layout_switcher.go
//  - https://github.com/afk-mario/dotfiles/blob/main/bin-src/keyboard_layout_switcher/main.go

package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os/exec"
	"strconv"
	"strings"
)

func main() {
	// collecting the JSON output from swaymsg
	cmdIn := exec.Command("swaymsg", "--raw", "--type", "get_inputs")
	stdout, err := cmdIn.Output()
	if err != nil {
		log.Fatal(err)
	}

	// struct that represents the Input
	type Input struct {
		Identifier, Name     string
		Vendor, Product      int
		Type                 string
		XkbLayoutNames       []string `json:"Xkb_Layout_Names"`
		XkbActiveLayoutIndex int      `json:"Xkb_Active_Layout_Index"`
		XkbActiveLayoutName  string   `json:"Xkb_Active_Layout_Name"`
	}

	// JSON decoder and getting the first token ('[')
	dec := json.NewDecoder(strings.NewReader(string(stdout)))
	_, err = dec.Token()
	if err != nil {
		log.Fatal(err)
	}

	// filtering amongst the keyboards for the one with the most layouts setup
	maxLength := 2
	keyboards := []Input{}
	for dec.More() {
		var input Input
		err := dec.Decode(&input)
		if err != nil {
			log.Fatal(err)
		}

		length := len(input.XkbLayoutNames)

		if input.Type == "keyboard" && length >= maxLength {
			keyboards = append(keyboards, input)
		}
	}

	if len(keyboards) < 2 {
		log.Fatalf("There is nothing to switch")
	}

	keyboardInput := keyboards[0]
	// finding the index of the input based on the first element
	var currentIndex int
	for i, layout := range keyboardInput.XkbLayoutNames {
		if keyboardInput.XkbActiveLayoutName == layout {
			currentIndex = i
			break
		}
	}

	// setting the next index of the output
	var nextIndex int
	if currentIndex < (len(keyboardInput.XkbLayoutNames) - 1) {
		nextIndex = currentIndex + 1
	} else {
		nextIndex = 0
	}

	for _, element := range keyboards {
		// setting the new layout index
		cmdOut := exec.Command("swaymsg", "input", element.Identifier, "xkb_switch_layout", strconv.Itoa(nextIndex))
		_, err = cmdOut.Output()
		if err != nil {
			log.Fatal(err)
		} else {
			fmt.Printf("%v switched to layout %v successfully.\n", element.Name, element.XkbLayoutNames[nextIndex])
		}
	}

}

