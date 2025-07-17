import jsreport from 'jsreport-core';
import handlebars from 'jsreport-handlebars';
import chromePdf from 'jsreport-chrome-pdf';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

// Configurar jsreport
let jsreportInstance = null;

async function initializeJsreport() {
    if (!jsreportInstance) {
        const __filename = fileURLToPath(import.meta.url);
        const __dirname = dirname(__filename);
        
        jsreportInstance = jsreport({
            parentModuleDirectory: __dirname
        })
            .use(handlebars())
            .use(chromePdf({
                timeout: 30000,
                launchOptions: {
                    args: ['--no-sandbox', '--disable-setuid-sandbox']
                }
            }));
        
        try {
            await jsreportInstance.init();
            console.log('✅ jsreport inicializado correctamente');
        } catch (error) {
            console.error('❌ Error inicializando jsreport:', error);
            throw error;
        }
    }
    return jsreportInstance;
}

export default initializeJsreport; 