import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

async function expireVendor() {
    const db = await open({
        filename: 'backend/marketplace.db',
        driver: sqlite3.Database
    });

    try {
        // Find first active vendor
        const vendor = await db.get('SELECT id, business_name, stall_number FROM vendors LIMIT 1');
        if (!vendor) {
            console.log('No vendors found to expire.');
            return;
        }

        // Set expiry to last year
        await db.run('UPDATE vendors SET expiry_date = "2025-01-01" WHERE id = ?', [vendor.id]);

        console.log(`✅ EXPIRED VENDOR FOR TESTING:`);
        console.log(`Business: ${vendor.business_name}`);
        console.log(`Stall: ${vendor.stall_number}`);
        console.log(`New Expiry: 2025-01-01 (Past)`);
        console.log(`\nNow go to Notifications, click JANUARY, then check Stall ${vendor.stall_number} on the Map!`);
    } catch (err) {
        console.error(err);
    } finally {
        await db.close();
    }
}

expireVendor();
