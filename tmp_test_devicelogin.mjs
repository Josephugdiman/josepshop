import fetch from 'node-fetch';

async function testDeviceLogin() {
    try {
        const res = await fetch('http://localhost:5000/api/auth/device-login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
        });
        const data = await res.json();
        console.log('Status:', res.status);
        console.log('Response:', data);
    } catch (err) {
        console.error('Error:', err);
    }
}

testDeviceLogin();
