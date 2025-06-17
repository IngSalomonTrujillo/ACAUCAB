import pool from "./connectionPostgreSQL.js";

const getHorario=async()=> {
    try {
        const result=await pool.query("SELECT horario_id, dias_semana, hora_entrada_esperada, hora_salida_esperada FROM horario");
        console.table(result.rows);
        console.log("Horarios Listados")
    } catch (error) {
        console.error(error);
    }
};

getHorario();