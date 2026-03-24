import fetch from 'node-fetch';

async function testFlow() {
    try {
        // 1. Login
        console.log('Logging in...');
        const loginRes = await fetch('http://localhost:5000/api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: 'admin@admin.com', password: 'password123' })
        });
        const loginData = await loginRes.json();
        console.log('Login Response:', loginData);

        if (!loginData.token) {
            console.error('No token returned');
            return;
        }

        // 2. Check Session
        console.log('\nChecking session...');
        const checkRes = await fetch('http://localhost:5000/api/auth/check', {
            headers: { 'Authorization': `Bearer ${loginData.token}` }
        });
        const checkData = await checkRes.json();
        console.log('Check Response:', checkData);
    } catch (err) {
        console.error('Error:', err);
    }
}

testFlow();
