import initSqlJs from 'sql.js';
import fs from 'fs';
import path from 'path';

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

    const res = db.exec("SELECT email, last_full_auth_at FROM users");
    console.log(JSON.stringify(res, null, 2));
}

verifyDB();
