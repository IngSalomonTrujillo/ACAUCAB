import initializeJsreport from './jsreport-config.js';

// Función para generar reporte de inventario
export async function generateInventarioReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        const result = await jsreportInstance.render({
            template: {
                content: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Reporte de Inventario</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #333; margin-bottom: 10px; }
                        .header p { color: #666; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                        th { background-color: #f2f2f2; font-weight: bold; }
                        tr:nth-child(even) { background-color: #f9f9f9; }
                        .total { font-weight: bold; margin-top: 20px; }
                        .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Reporte de Inventario</h1>
                        <p>Fecha de generación: {{formatDate}}</p>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Producto</th>
                                <th>Cantidad</th>
                                <th>Precio Unitario</th>
                                <th>Valor Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{#each inventario}}
                            <tr>
                                <td>{{id}}</td>
                                <td>{{nombre_producto}}</td>
                                <td>{{cantidad}}</td>
                                <td>${{precio_unitario}}</td>
                                <td>${{valor_total}}</td>
                            </tr>
                            {{/each}}
                        </tbody>
                    </table>
                    
                    <div class="total">
                        <p>Total de productos: {{inventario.length}}</p>
                        <p>Valor total del inventario: ${{sumInventario}}</p>
                    </div>
                    
                    <div class="footer">
                        <p>Reporte generado automáticamente por el sistema Acaucab</p>
                    </div>
                </body>
                </html>
                `,
                engine: 'handlebars',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            },
            data: {
                inventario: data.map(item => ({
                    ...item,
                    valor_total: (item.cantidad * item.precio_unitario).toFixed(2)
                })),
                sumInventario: data.reduce((sum, item) => sum + (item.cantidad * item.precio_unitario), 0).toFixed(2),
                formatDate: new Date().toLocaleDateString('es-ES')
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de inventario:', error);
        throw error;
    }
}

// Función para generar reporte de ventas
export async function generateVentasReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        const result = await jsreportInstance.render({
            template: {
                content: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Reporte de Ventas</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #333; margin-bottom: 10px; }
                        .header p { color: #666; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                        th { background-color: #f2f2f2; font-weight: bold; }
                        tr:nth-child(even) { background-color: #f9f9f9; }
                        .total { font-weight: bold; margin-top: 20px; }
                        .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Reporte de Ventas</h1>
                        <p>Fecha de generación: {{formatDate}}</p>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>ID Venta</th>
                                <th>Cliente</th>
                                <th>Producto</th>
                                <th>Cantidad</th>
                                <th>Precio Unitario</th>
                                <th>Total</th>
                                <th>Fecha</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{#each ventas}}
                            <tr>
                                <td>{{venta_id}}</td>
                                <td>{{nombre_cliente}}</td>
                                <td>{{nombre_producto}}</td>
                                <td>{{cantidad}}</td>
                                <td>${{precio_unitario}}</td>
                                <td>${{total}}</td>
                                <td>{{fecha_venta}}</td>
                            </tr>
                            {{/each}}
                        </tbody>
                    </table>
                    
                    <div class="total">
                        <p>Total de ventas: {{ventas.length}}</p>
                        <p>Ingresos totales: ${{totalIngresos}}</p>
                    </div>
                    
                    <div class="footer">
                        <p>Reporte generado automáticamente por el sistema Acaucab</p>
                    </div>
                </body>
                </html>
                `,
                engine: 'handlebars',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            },
            data: {
                ventas: data,
                totalIngresos: data.reduce((sum, item) => sum + parseFloat(item.total), 0),
                formatDate: new Date().toLocaleDateString('es-ES')
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de ventas:', error);
        throw error;
    }
}

// Función para generar reporte de clientes
export async function generateClientesReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        const result = await jsreportInstance.render({
            template: {
                content: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Reporte de Clientes</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #333; margin-bottom: 10px; }
                        .header p { color: #666; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                        th { background-color: #f2f2f2; font-weight: bold; }
                        tr:nth-child(even) { background-color: #f9f9f9; }
                        .total { font-weight: bold; margin-top: 20px; }
                        .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Reporte de Clientes</h1>
                        <p>Fecha de generación: {{formatDate}}</p>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Dirección</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{#each clientes}}
                            <tr>
                                <td>{{cliente_id}}</td>
                                <td>{{primer_nombre}}</td>
                                <td>{{primer_apellido}}</td>
                                <td>{{email}}</td>
                                <td>{{telefono}}</td>
                                <td>{{direccion}}</td>
                            </tr>
                            {{/each}}
                        </tbody>
                    </table>
                    
                    <div class="total">
                        <p>Total de clientes: {{clientes.length}}</p>
                    </div>
                    
                    <div class="footer">
                        <p>Reporte generado automáticamente por el sistema Acaucab</p>
                    </div>
                </body>
                </html>
                `,
                engine: 'handlebars',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            },
            data: {
                clientes: data,
                formatDate: new Date().toLocaleDateString('es-ES')
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de clientes:', error);
        throw error;
    }
}

// Función para generar reporte de ranking de proveedores
export async function generateRankingProveedoresReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        const result = await jsreportInstance.render({
            template: {
                content: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Ranking de Miembros Proveedores</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #333; margin-bottom: 10px; }
                        .header p { color: #666; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                        th { background-color: #f2f2f2; font-weight: bold; }
                        tr:nth-child(even) { background-color: #f9f9f9; }
                        .ranking { font-weight: bold; color: #e74c3c; }
                        .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Ranking de Miembros Proveedores</h1>
                        <p>Fecha de generación: {{formatDate}}</p>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>Posición</th>
                                <th>Proveedor</th>
                                <th>Tipos de Cerveza</th>
                                <th>Total Cervezas</th>
                                <th>Total Presentaciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{#each proveedores}}
                            <tr>
                                <td class="ranking">{{@index}}</td>
                                <td>{{nombre_proveedor}}</td>
                                <td>{{tipos_cerveza}}</td>
                                <td>{{total_cervezas}}</td>
                                <td>{{total_presentaciones}}</td>
                            </tr>
                            {{/each}}
                        </tbody>
                    </table>
                    
                    <div class="footer">
                        <p>Reporte generado automáticamente por el sistema Acaucab</p>
                    </div>
                </body>
                </html>
                `,
                engine: 'handlebars',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            },
            data: {
                proveedores: data,
                formatDate: new Date().toLocaleDateString('es-ES')
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de ranking de proveedores:', error);
        throw error;
    }
}

// Función para generar reporte de puntos canjeados
export async function generatePuntosCanjeadosReport(data) {
    try {
        console.log('📊 Datos recibidos en generatePuntosCanjeadosReport:', JSON.stringify(data, null, 2));
        
        const jsreportInstance = await initializeJsreport();
        
        // Procesar los datos de forma más simple
        const canjes = data.map(item => ({
            nombre_cliente: item.nombre_cliente || '',
            puntos_canjeados: item.puntos_canjeados || 0,
            valor_bs: item.valor_bs || '0.00',
            fecha_canje: item.fecha_canje || ''
        }));
        
        const totalPuntos = canjes.reduce((sum, item) => sum + (item.puntos_canjeados || 0), 0);
        const totalValor = canjes.reduce((sum, item) => sum + parseFloat(item.valor_bs || 0), 0).toFixed(2);
        
        console.log('📊 Datos procesados para template:', JSON.stringify(canjes, null, 2));
        
        // Crear el HTML manualmente para evitar problemas con handlebars
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Valor de Puntos Canjeados</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .total { font-weight: bold; margin-top: 20px; color: #e74c3c; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Valor de Puntos Canjeados</h1>
                <p>Últimos 6 meses - Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Cliente</th>
                        <th>Puntos Canjeados</th>
                        <th>Valor en Bs</th>
                        <th>Fecha de Canje</th>
                    </tr>
                </thead>
                <tbody>
                    ${canjes.map(item => `
                        <tr>
                            <td>${item.nombre_cliente}</td>
                            <td>${item.puntos_canjeados}</td>
                            <td>Bs ${item.valor_bs}</td>
                            <td>${item.fecha_canje}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            
            <div class="total">
                <p>Total de puntos canjeados: ${totalPuntos}</p>
                <p>Valor total en bolívares: Bs ${totalValor}</p>
            </div>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        console.log('📊 HTML generado, renderizando PDF...');
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm',
                    timeout: 30000,
                    launchOptions: {
                        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']
                    }
                }
            }
        });

        console.log('📊 PDF renderizado, tamaño del buffer:', result.content.length);
        console.log('📊 Tipo de resultado:', typeof result.content);
        
        // Asegurar que devolvemos el buffer correcto
        return result.content;

    } catch (error) {
        console.error('Error generando reporte de puntos canjeados:', error);
        throw error;
    }
}

// Función para generar reporte de flujo de pago
export async function generateFlujoPagoReport(data) {
    try {
        console.log('📊 Datos recibidos en generateFlujoPagoReport:', JSON.stringify(data, null, 2));
        console.log('📊 Tipo de datos:', typeof data, Array.isArray(data));
        
        const jsreportInstance = await initializeJsreport();
        
        // Procesar los datos de forma más simple
        const pagos = data.map(item => ({
            tipo_pago: item.tipo_pago || '',
            cantidad_transacciones: item.cantidad_transacciones || 0,
            monto_total: item.monto_total || '0.00',
            porcentaje: item.porcentaje || 0
        }));
        
        const totalTransacciones = pagos.reduce((sum, item) => sum + (item.cantidad_transacciones || 0), 0);
        const montoTotal = pagos.reduce((sum, item) => sum + parseFloat(item.monto_total || 0), 0).toFixed(2);
        
        // Crear el HTML manualmente para evitar problemas con handlebars
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Flujo de Pago en Tienda Física</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .total { font-weight: bold; margin-top: 20px; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Flujo de Pago en Tienda Física</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Tipo de Pago</th>
                        <th>Cantidad de Transacciones</th>
                        <th>Monto Total</th>
                        <th>Porcentaje</th>
                    </tr>
                </thead>
                <tbody>
                    ${pagos.map(item => `
                        <tr>
                            <td>${item.tipo_pago}</td>
                            <td>${item.cantidad_transacciones}</td>
                            <td>Bs ${item.monto_total}</td>
                            <td>${item.porcentaje}%</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            
            <div class="total">
                <p>Total de transacciones: ${totalTransacciones}</p>
                <p>Monto total: Bs ${montoTotal}</p>
            </div>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de flujo de pago:', error);
        throw error;
    }
}

// Función para generar reporte de duración de pedidos
export async function generateDuracionPedidosReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        const result = await jsreportInstance.render({
            template: {
                content: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Duración Promedio de Pedidos Online</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #333; margin-bottom: 10px; }
                        .header p { color: #666; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                        th { background-color: #f2f2f2; font-weight: bold; }
                        tr:nth-child(even) { background-color: #f9f9f9; }
                        .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Duración Promedio de Pedidos Online</h1>
                        <p>Fecha de generación: {{formatDate}}</p>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>Día de la Semana</th>
                                <th>Pedidos Procesados</th>
                                <th>Tiempo Promedio (minutos)</th>
                                <th>Tiempo Mínimo</th>
                                <th>Tiempo Máximo</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{#each pedidos}}
                            <tr>
                                <td>{{dia_semana}}</td>
                                <td>{{pedidos_procesados}}</td>
                                <td>{{tiempo_promedio}}</td>
                                <td>{{tiempo_minimo}}</td>
                                <td>{{tiempo_maximo}}</td>
                            </tr>
                            {{/each}}
                        </tbody>
                    </table>
                    
                    <div class="footer">
                        <p>Reporte generado automáticamente por el sistema Acaucab</p>
                    </div>
                </body>
                </html>
                `,
                engine: 'handlebars',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            },
            data: {
                pedidos: data,
                formatDate: new Date().toLocaleDateString('es-ES')
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de duración de pedidos:', error);
        throw error;
    }
}

// Función para generar reporte de incumplimientos horarios
export async function generateIncumplimientosHorariosReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        const result = await jsreportInstance.render({
            template: {
                content: `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Empleados con Incumplimientos Horarios</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 20px; }
                        .header { text-align: center; margin-bottom: 30px; }
                        .header h1 { color: #333; margin-bottom: 10px; }
                        .header p { color: #666; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                        th { background-color: #f2f2f2; font-weight: bold; }
                        tr:nth-child(even) { background-color: #f9f9f9; }
                        .incumplimiento { color: #e74c3c; font-weight: bold; }
                        .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="header">
                        <h1>Empleados con Incumplimientos Horarios</h1>
                        <p>Fecha de generación: {{formatDate}}</p>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>Empleado</th>
                                <th>Cédula</th>
                                <th>Llegadas Tarde</th>
                                <th>Salidas Tempranas</th>
                                <th>Total Incumplimientos</th>
                                <th>Último Incidente</th>
                            </tr>
                        </thead>
                        <tbody>
                            {{#each empleados}}
                            <tr>
                                <td>{{nombre_completo}}</td>
                                <td>{{cedula}}</td>
                                <td class="incumplimiento">{{llegadas_tarde}}</td>
                                <td class="incumplimiento">{{salidas_tempranas}}</td>
                                <td class="incumplimiento">{{total_incumplimientos}}</td>
                                <td>{{ultimo_incidente}}</td>
                            </tr>
                            {{/each}}
                        </tbody>
                    </table>
                    
                    <div class="footer">
                        <p>Reporte generado automáticamente por el sistema Acaucab</p>
                    </div>
                </body>
                </html>
                `,
                engine: 'handlebars',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            },
            data: {
                empleados: data,
                formatDate: new Date().toLocaleDateString('es-ES')
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de incumplimientos horarios:', error);
        throw error;
    }
}

// ===== NUEVAS FUNCIONES DE REPORTES =====

// Función para generar reporte de tendencias de ventas
export async function generateTendenciasVentasReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalVentas = data.reduce((sum, item) => sum + Number(item.total_ventas), 0);
        const totalTransacciones = data.reduce((sum, item) => sum + Number(item.cantidad_ventas), 0);
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Tendencias de Ventas</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Tendencias de Ventas</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen del Período</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">Bs ${totalVentas.toLocaleString()}</div>
                        <div class="label">Total Ventas</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalTransacciones}</div>
                        <div class="label">Total Transacciones</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${(totalVentas / totalTransacciones).toFixed(2)}</div>
                        <div class="label">Promedio por Transacción</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${data.length}</div>
                        <div class="label">Días con Ventas</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Total Ventas (Bs)</th>
                        <th>Cantidad de Ventas</th>
                        <th>Promedio por Venta</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => `
                        <tr>
                            <td>${new Date(item.fecha).toLocaleDateString('es-ES')}</td>
                            <td>Bs ${Number(item.total_ventas).toLocaleString()}</td>
                            <td>${item.cantidad_ventas}</td>
                            <td>Bs ${(Number(item.total_ventas) / Number(item.cantidad_ventas)).toFixed(2)}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de tendencias de ventas:', error);
        throw error;
    }
}

// Función para generar reporte de ventas por canal
export async function generateVentasCanalReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalVentas = data.reduce((sum, item) => sum + Number(item.total_ventas), 0);
        const totalTransacciones = data.reduce((sum, item) => sum + Number(item.cantidad_ventas), 0);
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Ventas por Canal</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .canal-fisica { background-color: #e8f5e8; }
                .canal-online { background-color: #e8f0f8; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Ventas por Canal</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen General</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">Bs ${totalVentas.toLocaleString()}</div>
                        <div class="label">Total Ventas</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalTransacciones}</div>
                        <div class="label">Total Transacciones</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${(totalVentas / totalTransacciones).toFixed(2)}</div>
                        <div class="label">Promedio por Transacción</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${data.length}</div>
                        <div class="label">Canales</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Canal</th>
                        <th>Cantidad de Ventas</th>
                        <th>Total Ventas (Bs)</th>
                        <th>Promedio por Venta</th>
                        <th>% del Total</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => {
                        const porcentaje = ((Number(item.total_ventas) / totalVentas) * 100).toFixed(2);
                        const rowClass = item.canal === 'Física' ? 'canal-fisica' : 'canal-online';
                        return `
                            <tr class="${rowClass}">
                                <td><strong>${item.canal}</strong></td>
                                <td>${item.cantidad_ventas}</td>
                                <td>Bs ${Number(item.total_ventas).toLocaleString()}</td>
                                <td>Bs ${Number(item.promedio_venta).toFixed(2)}</td>
                                <td>${porcentaje}%</td>
                            </tr>
                        `;
                    }).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de ventas por canal:', error);
        throw error;
    }
}

// Función para generar reporte de productos top
export async function generateProductosTopReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalUnidades = data.reduce((sum, item) => sum + Number(item.unidades_vendidas), 0);
        const totalVentas = data.reduce((sum, item) => sum + Number(item.total_ventas), 0);
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Productos Top - Más Vendidos</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .top-1 { background-color: #fff3cd; }
                .top-2 { background-color: #f8f9fa; }
                .top-3 { background-color: #e8f5e8; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Productos Top - Más Vendidos</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen del Ranking</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">${data.length}</div>
                        <div class="label">Productos Analizados</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalUnidades}</div>
                        <div class="label">Total Unidades Vendidas</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${totalVentas.toLocaleString()}</div>
                        <div class="label">Total Ventas</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${(totalUnidades / data.length).toFixed(0)}</div>
                        <div class="label">Promedio por Producto</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Posición</th>
                        <th>Producto</th>
                        <th>Presentación</th>
                        <th>Unidades Vendidas</th>
                        <th>Total Ventas (Bs)</th>
                        <th>Cantidad de Ventas</th>
                        <th>Promedio por Venta</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map((item, index) => {
                        const rowClass = index === 0 ? 'top-1' : index === 1 ? 'top-2' : index === 2 ? 'top-3' : '';
                        return `
                            <tr class="${rowClass}">
                                <td><strong>#${index + 1}</strong></td>
                                <td>${item.producto}</td>
                                <td>${item.presentacion}</td>
                                <td>${item.unidades_vendidas}</td>
                                <td>Bs ${Number(item.total_ventas).toLocaleString()}</td>
                                <td>${item.cantidad_ventas}</td>
                                <td>Bs ${(Number(item.total_ventas) / Number(item.cantidad_ventas)).toFixed(2)}</td>
                            </tr>
                        `;
                    }).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de productos top:', error);
        throw error;
    }
}

// Función para generar reporte de rotación de inventario
export async function generateRotacionInventarioReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalStock = data.reduce((sum, item) => sum + Number(item.stock_actual), 0);
        const totalVendidas = data.reduce((sum, item) => sum + Number(item.unidades_vendidas), 0);
        const promedioRotacion = data.reduce((sum, item) => sum + Number(item.rotacion), 0) / data.length;
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Rotación de Inventario</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .alta-rotacion { background-color: #e8f5e8; }
                .baja-rotacion { background-color: #ffe6e6; }
                .sin-stock { background-color: #fff3cd; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Rotación de Inventario</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen del Inventario</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">${data.length}</div>
                        <div class="label">Productos Analizados</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalStock}</div>
                        <div class="label">Total Stock Actual</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalVendidas}</div>
                        <div class="label">Total Unidades Vendidas</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${promedioRotacion.toFixed(2)}</div>
                        <div class="label">Promedio Rotación</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Presentación</th>
                        <th>Stock Actual</th>
                        <th>Unidades Vendidas</th>
                        <th>Rotación</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => {
                        let rowClass = '';
                        let estado = '';
                        
                        if (Number(item.stock_actual) === 0) {
                            rowClass = 'sin-stock';
                            estado = 'Sin Stock';
                        } else if (Number(item.rotacion) > 1) {
                            rowClass = 'alta-rotacion';
                            estado = 'Alta Rotación';
                        } else {
                            rowClass = 'baja-rotacion';
                            estado = 'Baja Rotación';
                        }
                        
                        return `
                            <tr class="${rowClass}">
                                <td>${item.producto}</td>
                                <td>${item.presentacion}</td>
                                <td>${item.stock_actual}</td>
                                <td>${item.unidades_vendidas}</td>
                                <td>${Number(item.rotacion).toFixed(2)}</td>
                                <td><strong>${estado}</strong></td>
                            </tr>
                        `;
                    }).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de rotación de inventario:', error);
        throw error;
    }
}

// Función para generar reporte de análisis de clientes
export async function generateAnalisisClientesReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalClientes = data.length;
        const totalGastado = data.reduce((sum, item) => sum + Number(item.total_gastado), 0);
        const promedioGasto = totalGastado / totalClientes;
        const clientesActivos = data.filter(item => Number(item.cantidad_compras) > 0).length;
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Análisis de Clientes</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .cliente-premium { background-color: #e8f5e8; }
                .cliente-regular { background-color: #f8f9fa; }
                .cliente-nuevo { background-color: #fff3cd; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Análisis de Clientes</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen de Clientes</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">${totalClientes}</div>
                        <div class="label">Total Clientes</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${clientesActivos}</div>
                        <div class="label">Clientes Activos</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${totalGastado.toLocaleString()}</div>
                        <div class="label">Total Gastado</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${promedioGasto.toFixed(2)}</div>
                        <div class="label">Promedio por Cliente</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Cliente</th>
                        <th>RIF</th>
                        <th>Tipo</th>
                        <th>Cantidad Compras</th>
                        <th>Total Gastado (Bs)</th>
                        <th>Promedio Compra</th>
                        <th>Primera Compra</th>
                        <th>Última Compra</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => {
                        let rowClass = '';
                        if (Number(item.total_gastado) > promedioGasto * 2) {
                            rowClass = 'cliente-premium';
                        } else if (Number(item.cantidad_compras) > 1) {
                            rowClass = 'cliente-regular';
                        } else {
                            rowClass = 'cliente-nuevo';
                        }
                        
                        return `
                            <tr class="${rowClass}">
                                <td>${item.nombre_cliente}</td>
                                <td>${item.rif}</td>
                                <td>${item.tipo_cliente}</td>
                                <td>${item.cantidad_compras}</td>
                                <td>Bs ${Number(item.total_gastado).toLocaleString()}</td>
                                <td>Bs ${Number(item.promedio_compra).toFixed(2)}</td>
                                <td>${item.primera_compra ? new Date(item.primera_compra).toLocaleDateString('es-ES') : 'N/A'}</td>
                                <td>${item.ultima_compra ? new Date(item.ultima_compra).toLocaleDateString('es-ES') : 'N/A'}</td>
                            </tr>
                        `;
                    }).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de análisis de clientes:', error);
        throw error;
    }
}

// Función para generar reporte de empleados
export async function generateEmpleadosReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalEmpleados = data.length;
        const empleadosConRol = data.filter(item => item.rol).length;
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Reporte de Empleados</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Reporte de Empleados</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen de Empleados</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">${totalEmpleados}</div>
                        <div class="label">Total Empleados</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${empleadosConRol}</div>
                        <div class="label">Con Rol Asignado</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalEmpleados - empleadosConRol}</div>
                        <div class="label">Sin Rol Asignado</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Apellido</th>
                        <th>Email</th>
                        <th>Teléfono</th>
                        <th>Fecha Contratación</th>
                        <th>Rol</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map(item => `
                        <tr>
                            <td>${item.empleado_id}</td>
                            <td>${item.primer_nombre}</td>
                            <td>${item.primer_apellido}</td>
                            <td>${item.email || 'N/A'}</td>
                            <td>${item.telefono || 'N/A'}</td>
                            <td>${item.fecha_contratacion ? new Date(item.fecha_contratacion).toLocaleDateString('es-ES') : 'N/A'}</td>
                            <td>${item.rol || 'Sin asignar'}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de empleados:', error);
        throw error;
    }
}

// Función para generar reporte de ventas por empleado
export async function generateVentasEmpleadoReport(data) {
    try {
        const jsreportInstance = await initializeJsreport();
        
        const totalVentas = data.reduce((sum, item) => sum + Number(item.total_ventas), 0);
        const totalTransacciones = data.reduce((sum, item) => sum + Number(item.cantidad_ventas), 0);
        
        const htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Ventas por Empleado</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .header h1 { color: #333; margin-bottom: 10px; }
                .header p { color: #666; }
                .summary { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
                .summary h3 { color: #333; margin-bottom: 15px; }
                .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
                .summary-item { text-align: center; }
                .summary-item .value { font-size: 24px; font-weight: bold; color: #667eea; }
                .summary-item .label { color: #666; margin-top: 5px; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f2f2f2; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .top-vendedor { background-color: #e8f5e8; }
                .footer { margin-top: 30px; text-align: center; color: #666; font-size: 12px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Ventas por Empleado</h1>
                <p>Fecha de generación: ${new Date().toLocaleDateString('es-ES')}</p>
            </div>
            
            <div class="summary">
                <h3>Resumen de Ventas</h3>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="value">${data.length}</div>
                        <div class="label">Empleados Activos</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">${totalTransacciones}</div>
                        <div class="label">Total Transacciones</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${totalVentas.toLocaleString()}</div>
                        <div class="label">Total Ventas</div>
                    </div>
                    <div class="summary-item">
                        <div class="value">Bs ${(totalVentas / totalTransacciones).toFixed(2)}</div>
                        <div class="label">Promedio por Transacción</div>
                    </div>
                </div>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>Empleado</th>
                        <th>Cantidad de Ventas</th>
                        <th>Total Ventas (Bs)</th>
                        <th>Promedio por Venta</th>
                        <th>Primera Venta</th>
                        <th>Última Venta</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.map((item, index) => {
                        const rowClass = index === 0 ? 'top-vendedor' : '';
                        return `
                            <tr class="${rowClass}">
                                <td><strong>${item.empleado}</strong></td>
                                <td>${item.cantidad_ventas}</td>
                                <td>Bs ${Number(item.total_ventas).toLocaleString()}</td>
                                <td>Bs ${Number(item.promedio_venta).toFixed(2)}</td>
                                <td>${item.primera_venta ? new Date(item.primera_venta).toLocaleDateString('es-ES') : 'N/A'}</td>
                                <td>${item.ultima_venta ? new Date(item.ultima_venta).toLocaleDateString('es-ES') : 'N/A'}</td>
                            </tr>
                        `;
                    }).join('')}
                </tbody>
            </table>
            
            <div class="footer">
                <p>Reporte generado automáticamente por el sistema Acaucab</p>
            </div>
        </body>
        </html>
        `;
        
        const result = await jsreportInstance.render({
            template: {
                content: htmlContent,
                engine: 'none',
                recipe: 'chrome-pdf',
                chrome: {
                    format: 'A4',
                    margin: '1cm'
                }
            }
        });

        return result;
    } catch (error) {
        console.error('Error generando reporte de ventas por empleado:', error);
        throw error;
    }
} 