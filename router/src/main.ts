import Web3 from 'web3';

document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
  <div>
    <h1>Censorless Web Router</h1>
    <p id="status">Connecting to blockchain...</p>
  </div>
`

const web3 = new Web3(import.meta.env.NETWORK_RPC as string);

const censorlessABI = [
    {
        "inputs": [],
        "name": "getEndpoint",
        "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
        "stateMutability": "view",
        "type": "function"
    }
];

const contractAddress = import.meta.env.VITE_CONTRACT_ADDRESS as string;
const censorlessContract = new web3.eth.Contract(censorlessABI, contractAddress);

async function redirectToEndpoint() {
    try {
        const statusElement = document.getElementById('status');
        statusElement!.textContent = 'Fetching endpoint from blockchain...';

        const endpoint = await censorlessContract.methods.getEndpoint().call() as string;

        if (endpoint && endpoint.trim() !== '') {
            statusElement!.textContent = `Redirecting to: ${endpoint}`;
            setTimeout(() => {
                document.location.replace(endpoint);
            }, 1000);
        } else {
            statusElement!.textContent = 'No endpoint set in the contract';
        }
    } catch (error) {
        console.error('Error fetching endpoint:', error);
        document.getElementById('status')!.textContent = 'Error fetching endpoint';
    }
}

document.addEventListener('DOMContentLoaded', redirectToEndpoint);

document.getElementById('redirect')!.addEventListener('click', redirectToEndpoint);