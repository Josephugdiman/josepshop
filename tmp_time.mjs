import initSqlJs from 'sql.js';

async function testTime() {
    const SQL = await initSqlJs();
    const db = new SQL.Database();

    const resNow = db.exec("SELECT datetime('now')");
    const resLocal = db.exec("SELECT datetime('now', 'localtime')");

    console.log("sqlite now:", resNow[0].values[0][0]);
    console.log("sqlite localtime:", resLocal[0].values[0][0]);

    // How node parses it:
    const nodeDateLocal = new Date(resLocal[0].values[0][0]);
    const nodeNow = new Date();

    console.log("node parsed localtime:", nodeDateLocal);
    console.log("node real now:", nodeNow);

    const hours = (nodeNow - nodeDateLocal) / (1000 * 60 * 60);
    console.log("hours since:", hours);
}

testTime();
