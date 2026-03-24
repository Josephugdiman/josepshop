const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const backendDir = path.join(__dirname, '../sepshop-release-v4/win-unpacked/resources/backend');
const serverPath = path.join(backendDir, 'server.js');

console.log('Testing backend startup from:', serverPath);

if (!fs.existsSync(serverPath)) {
    console.error('Backend server.js not found at:', serverPath);
    process.exit(1);
}

// Start the backend server
const backendProcess = spawn('node', [serverPath], {
    cwd: backendDir,
    stdio: 'pipe',
    env: {
        ...process.env,
        PORT: '5000',
        NODE_ENV: 'production',
        IS_ELECTRON: 'true',
        DB_PATH: path.join(process.env.APPDATA || process.env.HOME, 'MarketplaceManagement', 'marketplace.db')
    }
});

backendProcess.stdout.on('data', (data) => {
    console.log(`Backend: ${data.toString().trim()}`);
});

backendProcess.stderr.on('data', (data) => {
    console.error(`Backend Error: ${data.toString().trim()}`);
});

backendProcess.on('error', (error) => {
    console.error('Failed to start backend:', error);
});

backendProcess.on('exit', (code, signal) => {
    console.log(`Backend process exited with code ${code} and signal ${signal}`);
});

// Wait a bit to see if it starts successfully
setTimeout(() => {
    console.log('Test completed. If you see "SQLite Server running on port 5000" above, the backend is working.');
    backendProcess.kill();
    process.exit(0);
}, 5000);