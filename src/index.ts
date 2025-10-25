import { toCoinbaseSmartAccount } from 'viem/account-abstraction'
import { client, owner, mailContract } from './config.js'
import { domain, types } from './data.js'
import { localhost } from 'viem/chains';
 
main();


async function main() {
    
const message = {
    from: owner.address,
    to: '0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB' as `0x${string}`,
    value: 0n,
}
 
const signature = await owner.signTypedData({ 
  domain, 
  types, 
  primaryType: 'Mail', 
  message: message, 
}) 

const isValid = await mailContract.read.verifyMailSignature([
        [message.from, message.to, message.value],
        signature,
    ]);

console.log('Signature valid if done by parts:', isValid[0])
console.log('Signature valid if done without it:', isValid[1])
}