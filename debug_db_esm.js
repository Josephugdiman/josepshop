import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

async function debug() {
    const db = await open({
        filename: 'backend/marketplace.db',
        driver: sqlite3.Database
    });

    console.log('--- SYSTEM SETTINGS ---');
    const settings = await db.all('SELECT * FROM system_settings');
    console.log(JSON.stringify(settings, null, 2));

    console.log('\n--- VENDORS (Sample) ---');
    const vendors = await db.all('SELECT business_name, stall_number, expiry_date FROM vendors LIMIT 10');
    console.log(JSON.stringify(vendors, null, 2));

    await db.close();
}

debug().catch(console.error);
