const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./sepshop/electron/backend/database.sqlite');
db.all("SELECT id, business_name, payment_history FROM vendors WHERE status != 'archived' LIMIT 10", (err, rows) => {
    if (err) {
        console.error(err);
        process.exit(1);
    }
    rows.forEach(row => {
        console.log('Vendor:', row.business_name);
        try {
            const hist = JSON.parse(row.payment_history || '[]');
            const march = hist.find(e => e && e.month === '2026-03');
            if (march) {
                console.log('  March Invoice:', JSON.stringify(march));
            } else {
                console.log('  No March Invoice');
            }
        } catch (e) {
            console.log('  Error parsing history');
        }
    });
    db.close();
});
