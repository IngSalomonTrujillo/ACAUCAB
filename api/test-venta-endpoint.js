const fetch = require('node-fetch');

async function testVentaEndpoint() {
    console.log('🧪 Probando endpoint de ventas...');
    
    const testData = {
        clienteRif: "V123456789",
        carrito: [
            {
                id: 1,
                quantity: 2,
                price: 10.50,
                cerveza_id: 1,
                presentacion_id: 1
            }
        ],
        metodosPago: [
            {
                tipo: "Efectivo",
                monto: 21.00,
                detalles: {}
            }
        ],
        puntosUsados: 0,
        tasaCambioId: 1,
        subtotal: 21.00,
        iva: 0,
        total: 21.00
    };

    try {
        console.log('📤 Enviando datos de prueba:', JSON.stringify(testData, null, 2));
        
        const response = await fetch('http://localhost:3000/api/compras/realizar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(testData)
        });

        console.log('📥 Respuesta recibida:');
        console.log('Status:', response.status);
        console.log('Status Text:', response.statusText);
        
        const responseData = await response.text();
        console.log('Body:', responseData);
        
        if (response.ok) {
            console.log('✅ Prueba exitosa!');
        } else {
            console.log('❌ Prueba falló!');
        }
        
    } catch (error) {
        console.error('❌ Error en la prueba:', error.message);
    }
}

testVentaEndpoint(); 