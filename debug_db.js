const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('backend/marketplace.db');

console.log('--- SYSTEM SETTINGS ---');
db.all('SELECT * FROM system_settings', [], (err, rows) => {
    if (err) console.error(err);
    else console.log(JSON.stringify(rows, null, 2));

    console.log('\n--- VENDORS (Sample) ---');
    db.all('SELECT business_name, stall_number, expiry_date FROM vendors LIMIT 5', [], (err, rows) => {
        if (err) console.error(err);
        else console.log(JSON.stringify(rows, null, 2));
        db.close();
    });
});
