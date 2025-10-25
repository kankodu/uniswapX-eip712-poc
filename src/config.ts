import { http, createPublicClient, getContract } from 'viem'
import { privateKeyToAccount } from 'viem/accounts'
import { mainnet, localhost } from 'viem/chains'
import mailAbiInfo from "../out/Mail.sol/Mail.json"
 
export const owner = privateKeyToAccount('0x0000000000000000000000000000000000000000000000000000000000000001')
 
export const client = createPublicClient({
  chain: localhost,
  transport: http(),
})

const localhostClient = createPublicClient({
  chain: localhost,
  transport: http(),
})

export const mailContract = getContract({
  address: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
  abi: mailAbiInfo.abi,
  client: localhostClient,
})