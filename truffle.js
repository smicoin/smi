var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "confirm hazard immune equip wrist castle flush brush fiber loan sudden evolve";

//SMI Base Account - 0xD33C997e8d7Cd28eEc528535677688D6348C1219
//SMI Account 2 (Local key) = Beneficiary - 0x683Ca011AcBa94D21B20e730e094e1C125039abD

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id
        },
        rinkeby:  {
            host: "localhost",
            port: 8545,
            network_id: "4", // Rinkeby ID 4
            from : "0x7Fc6DB314b15310A76ccf6aE3E8205972aE40b71",
            gas : "4612388"
        },

        mainnet: {
            provider: function() {
                return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/D91lRbfShy9wF6iVAPA0")
            },
            network_id: 1
        }
    }
};