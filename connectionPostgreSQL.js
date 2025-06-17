import pg from "pg"

const pool=new pg.Pool({
    host:"localhost",
    port:5432,
    database:"ACAUCAB",
    user:"postgres",
    password:"1234"
});
const res = await pool.query('select * from HORARIO')
console.log(res.rows)

export default pool;