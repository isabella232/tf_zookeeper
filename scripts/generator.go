package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/samuel/go-zookeeper/zk"
)

// channel variables
var (
	done = make(chan bool)
	msgs = make(chan string)
)

// holds the flag variables
var (
	element    = flag.Int("element", 10, "default znode number")
	interval   = flag.Duration("interval", 1*time.Second, "default duration to generate strings")
	goroutines = flag.Int("goroutines", 2, "default go routines count")
	address    = flag.String("address", "0.0.0.0", "addresses for zookeeper")
)

var mu = &sync.Mutex{}

func main() {
	flag.Parse()

	if *goroutines > *element {
		log.Fatal(fmt.Errorf("err: goroutines should be less than element number"))
	}

	addressArray := strings.Split(*address, ",")

	c, _, err := zk.Connect(addressArray, time.Second) //*10)
	if err != nil {
		log.Fatal(err.Error())
	}

	// Before checking the zookeeper Data structure, clean all znodes from directory
	if err := cleanUp(c); err != nil {
		log.Fatal(err.Error())
	}

	sign := make(chan os.Signal)
	signal.Notify(sign, os.Interrupt, syscall.SIGTERM)

	closeChan := make(chan struct{}, 0)
	go handleCtrlC(sign, closeChan)

	go produce(*interval, *element, closeChan)

	var wg sync.WaitGroup
	wg.Add(*goroutines)
	// multiple go routine to process created keys in zookeper data model
	for i := 0; i < *goroutines; i++ {
		go consume(c, &wg)
	}

	<-done
	wg.Wait()

	if producer == consumer {
		fmt.Println(fmt.Sprintf("producer:%d and consumer:%d checking is finihed as successfully", producer, consumer))
	} else {
		fmt.Println(fmt.Sprintf("producer:%d and consumer:%d checking is failed", producer, consumer))
	}

	os.Exit(0)
}

var (
	producer, consumer int
)

func produce(x time.Duration, n int, c chan struct{}) {
	defer func() {
		close(msgs)
		done <- true
	}()

	for i := 0; i < n; i++ {
		select {
		case <-c:
			return
		case <-time.After(x):
			str := fmt.Sprintf("/key-%d", i)
			msgs <- str
			// we dont need to lock process coz there is single process
			producer++
		}
	}
}

func consume(c *zk.Conn, wg *sync.WaitGroup) {
	defer wg.Done()

	for {
		msg, ok := <-msgs
		if !ok {
			return
		}
		_, err := c.Create(msg, nil, 0, zk.WorldACL(zk.PermAll))
		if err != nil {
			if err != zk.ErrNodeExists {
				continue
			}
			fmt.Println(fmt.Errorf("%v", err.Error()))
			return
		}

		if err == nil {
			mu.Lock()
			consumer++
			mu.Unlock()
		}
	}
}

// cleanUp cleans the all znodes in zookeper data structure
func cleanUp(c *zk.Conn) error {
	children, _, _, err := c.ChildrenW("/")
	if err != nil {
		return err
	}

	for _, child := range children {
		// we can't delete /zookeeper path from the znodes
		if child == "zookeeper" {
			continue
		}
		// delete operation takes path parameter
		// then it should have '/' as first index
		if err := c.Delete("/"+child, 0); err != nil {
			return err
		}
	}

	return nil
}

func handleCtrlC(c chan os.Signal, cc chan struct{}) {
	// handle ctrl+c event here
	<-c
	close(cc)
}
