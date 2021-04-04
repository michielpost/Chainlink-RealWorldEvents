"use strict";

function send() {
    // Acccounts now exposed
    web3.eth.sendTransaction({/* ... */ });
}

function get() {
    //const accounts = await ethereum.request({ method: 'eth_accounts' });
    //console.log(accounts[0]);

    console.log(ethereum.selectedAddress);
    ethereum.request({
        method: 'eth_getTransactionCount',
        params:
            [
                ethereum.selectedAddress,
                'latest'
            ]

    }).then(data => {
        console.log("data ", data);
    })
        .catch(err => alert(err));

    const msgParams = [
        {
            type: 'string',      // Any valid solidity type
            name: 'Message',     // Any string label you want
            value: 'Hi, Alice!'  // The value to sign
        },
        {
            type: 'uint32',
            name: 'A number',
            value: '1337'
        }
    ]  


    ethereum.request({
        method: 'eth_signTypedData',
        params:
        [
                msgParams,
                ethereum.selectedAddress
                
        ]

    }).then(data => {
        console.log("data ", data);
    })
    .catch(err => alert(err));

    console.log('finished');
}

function encrypt() {
    let encryptionPublicKey;

    ethereum
        .request({
            method: 'eth_getEncryptionPublicKey',
            params: [ethereum.selectedAddress], // you must have access to the specified account
        })
        .then((result) => {
            encryptionPublicKey = result;
        })
        .catch((error) => {
            if (error.code === 4001) {
                // EIP-1193 userRejectedRequest error
                console.log("We can't encrypt anything without the key.");
            } else {
                console.error(error);
            }
        });

    const encryptedMessage = ethUtil.bufferToHex(
        Buffer.from(
            JSON.stringify(
                sigUtil.encrypt(
                    encryptionPublicKey,
                    { data: 'Hello world!' },
                    'x25519-xsalsa20-poly1305'
                )
            ),
            'utf8'
        )
    );

    ethereum
        .request({
            method: 'eth_decrypt',
            params: [encryptedMessage, ethereum.selectedAddress],
        })
        .then((decryptedMessage) =>
            console.log('The decrypted message is:', decryptedMessage)
        )
        .catch((error) => console.log(error.message));
}

async function color(color) {

    let ABI = [
        "function setColor(string color)"
    ];

    let iface = new ethers.utils.Interface(ABI);

    var data = iface.encodeFunctionData("setColor", [color]);
    console.log(data);
   // var test = contract.populateTransaction.transfer(ethereum.selectedAddress, tokenValue, { value: 1.0 })

    const transactionParameters = {
        to: '0x60d0590220D92bb0ded636f5272a5F29E2e39380',
        from: ethereum.selectedAddress, // must match user's active address.
        value: '0x38D7EA4C68000',
        data: data
    };

    const txHash = await ethereum.request({
        method: 'eth_sendTransaction',
        params: [transactionParameters],
    });
}

async function load() {
    // Modern dapp browsers...
    if (window.ethereum) {
        try {
            // Request account access if needed
            await ethereum.enable();
        } catch (error) {
            // User denied account access...
        }
    }
    // Non-dapp browsers...
    else {
        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
    }
}