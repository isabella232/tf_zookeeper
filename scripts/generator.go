package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/samuel/go-zookeeper/zk"
)

const (
	ELEMENT_NUMBER = 10
	TIME_INTERVAL  = time.Second
)

// channel variables
var (
	done = make(chan bool)
	msgs = make(chan string)
)

// holds the flag variables
var (
	element  = flag.Int("element", 10, "default znode number")
	interval = flag.Duration("interval", 1, "default duration to generate strings")
)

func main() {
	flag.Parse()

	c, _, err := zk.Connect([]string{"0.0.0.0"}, time.Second) //*10)
	if err != nil {
		log.Fatal(err.Error())
	}

	if err := cleanUp(c); err != nil {
		log.Fatal(err.Error())
	}

	childrenBefore, stat, ch, err := c.ChildrenW("/")
	if err != nil {
		panic(err)
	}

	fmt.Printf("children is :%+v, stat is: %+v\n", childrenBefore, stat)

	sign := make(chan os.Signal)
	signal.Notify(sign, os.Interrupt, syscall.SIGTERM)
	go handleCtrlC(sign)

	go produce((*interval), *element)
	go consume(c)
	<-done

	childrenAfter, stat, ch, err := c.ChildrenW("/")
	if err != nil {
		panic(err)
	}

	fmt.Printf("children is :%+v, stat is: %+v\n", childrenAfter, stat)

	if len(childrenAfter) == ELEMENT_NUMBER+1 {
		fmt.Println("successfull")
	}
	e := <-ch
	fmt.Printf("%+v\n", e)
}

func produce(x time.Duration, n int) {
	for i := 0; i < n; i++ {
		time.Sleep(x)
		str := fmt.Sprintf("/key-%d", i)
		msgs <- str
	}
	done <- true
}

func consume(c *zk.Conn) {
	for {
		msg := <-msgs
		_, err := c.Create(msg, nil, 0, zk.WorldACL(zk.PermAll))
		if err != nil {
			if err != zk.ErrNodeExists {
				fmt.Println("ERROR IS :", err)
			}
		}

		fmt.Println(msg)
	}
}

// cleanUp cleans the all znodes in zookeper data structure
func cleanUp(c *zk.Conn) error {
	children, _, _, err := c.ChildrenW("/")
	if err != nil {
		return err
	}

	for _, child := range children {
		if err := c.Delete("/"+child, 0); err != nil {
			// we can't delete /zookeeper path from the znodes
			if child == "zookeeper" {
				continue
			}
			// fmt.Println("ERROR WHILE CLEANING", err)
			return err
		}
	}

	return nil
}

func handleCtrlC(c chan os.Signal) {
	sig := <-c
	// handle ctrl+c event here
	// for example, close database
	fmt.Println("\nsignal: ", sig)
	os.Exit(0)
}
