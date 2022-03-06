package main

import (
	"fmt"
	"log"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
)

var keystr = `{"address":"9f9c273d9f2df0159614a70e5d2a6076706cfdf2","crypto":{"cipher":"aes-128-ctr","ciphertext":"e3b92048a54d2ca685c47bf900040684b1042838602aee92f461f6a5ddb7e4b5","cipherparams":{"iv":"2ce264cc7948f434c10629422d15c305"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"cacebccef4b61a47fee88fe69e87598be4d06cd345af12f79f1d9e4b9a2734a4"},"mac":"5fd34379e59b6b77f14c2128ecf806cf14ab48c9189cddddeda9df1add3f2040"},"id":"8fdd59ce-26a5-4b51-97f9-09e1c05f89d3","version":3}`

func main() {

	// 连接节点
	cli, err := ethclient.Dial("http://localhost:8545")
	if err != nil {
		log.Panic("failed to Dial", err)
	}

	// 创建合约实例(节点+ 合约地址) 0xF3119486408f7aa8ef4F872f62CAf4Db8fDAe7C5

	instance, err := NewHello(common.HexToAddress("0xF3119486408f7aa8ef4F872f62CAf4Db8fDAe7C5"), cli)
	if err != nil {
		log.Panic("failed to Dial", err)
	}

	// 函数调用
	opts := bind.CallOpts{
		From: common.HexToAddress("0x91Aa7dfdd6800E0c22Bf2188e9aA532798A5656e"),
	}
	strMsg, err := instance.GetMsg(&opts)
	if err != nil {
		log.Panic("failed to Dial", err)
	}

	fmt.Println("get Msg", strMsg)

	// 调用消耗gas的函数
	// 将秘钥导入在devdata  /Users/darren/Documents/project/node/rundevgeth/devdata/keystore
	reader := strings.NewReader(keystr)
	auth, err := bind.NewTransactor(reader, "123")
	if err != nil {
		log.Panic("failed to NewTransactor", err)
	}
	_, err = instance.SetMsg(auth, "lijia123")
	if err != nil {
		log.Panic("failed to setmsg", err)
	}

}
