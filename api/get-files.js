// Vercel Serverless Function - GitHub dosyalarını getir
export default async function handler(req, res) {
    // CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET');

    if (req.method === 'OPTIONS') {
        res.status(200).end();
        return;
    }

    try {
        const response = await fetch('https://api.github.com/repos/simsekdogukan/files/contents/', {
            headers: {
                'User-Agent': 'Vercel-Function',
                'Accept': 'application/vnd.github.v3+json'
            }
        });

        if (!response.ok) {
            throw new Error(`GitHub API error: ${response.status}`);
        }

        const allFiles = await response.json();

        // Dosyaları filtrele
        const files = allFiles.filter(file =>
            file.type === 'file' &&
            !file.name.startsWith('.') &&
            file.name !== 'README.md' &&
            file.name !== 'index.html' &&
            file.name !== 'vercel.json'
        );

        res.status(200).json({ success: true, files });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
}
