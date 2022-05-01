const { assert } = require('chai');

const kryptobird = artifacts.require("./KryptoBird");

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => {

    let contract
    // before tells our contract to run this first before anything
    before(
        async() => {
            contract = await kryptobird.deployed()
        }
    )
    // testing container
    describe('deployment', async() => {

        it('deploys successfully', async() => {

            const address = contract.address;

            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)

        })

        it('has a name',  async() => {
            const name = await contract.name();
            assert.equal(name, 'KryptoBird')
        })

        it('has a symbol',  async() => {
            const symbol = await contract.symbol();
            assert.equal(symbol, 'KBIRDZ')
        })

    })

    describe('minting', async() => {

        it('creates a new token', async() => {
            const result = await contract.mint("https....1")
            const totalSupply = await contract.totalSupply()

            // success
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from the contract')
            assert.equal(event._to, accounts[0], 'to is msg.sender')

            // failure
            await contract.mint("https....1").should.be.rejected;
        })
    })

    describe('indexing', async() => {

        it('lists KryptoBirdz', async() => {
            // mint three new tokens
            await contract.mint('https....2')
            await contract.mint('https....3')
            await contract.mint('https....4')
            const totalSupply = await contract.totalSupply()

            // loop through list and grab kbirdz from list
            let result = []
            let kryptoBird

            for(i = 1; i < totalSupply; i++){
                kryptoBird = await contract.kryptoBirdz(i - 1)
                result.push(kryptoBird)
            }

            // success
            let expected = ['https....1','https....2','https....3']
            assert.equal(result.join(','), expected.join(','))
        })

    })

})