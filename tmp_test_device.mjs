import initSqlJs from 'sql.js';
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import machineId from 'node-machine-id';

const deviceHash = () => {
    try {
        const raw = machineId.machineIdSync({ original: true });
        return crypto.createHash('sha256').update(raw).digest('hex');
    } catch {
        return '';
    }
};

async function verifyDB() {
    const SQL = await initSqlJs();
    const dbPath = path.join(process.env.APPDATA, 'Marketplace Management System', 'marketplace.db');

    if (!fs.existsSync(dbPath)) {
        console.log('DB not found at', dbPath);
        return;
    }

    console.log('Loading DB from', dbPath);
    const filebuffer = fs.readFileSync(dbPath);
    const db = new SQL.Database(filebuffer);

    const res = db.exec("SELECT email, device_id FROM users");
    console.log('Users in DB:');
    console.log(JSON.stringify(res, null, 2));

    const currentDevice = deviceHash();
    console.log('\nCurrent Device Hash:', currentDevice);
}

verifyDB();
