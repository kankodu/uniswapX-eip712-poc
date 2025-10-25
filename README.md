## To run this POC

1. `npm install`
2. `forge install` 
3. `anvil` (start anvil node at localhost:8545)
4. `forge script script/Mail.s.sol --rpc-url 127.0.0.1:8545 --broadcast -vvvv --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`
   
   *(the private key is of the default anvil account so it's not a secret)*
5. `npm run dev`

Doing this, it is clear that the signature verification does not work if the hash is done in parts. 