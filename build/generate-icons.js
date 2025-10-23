// Generate Ö icon for Ördin
// This script creates PNG icons programmatically using Canvas

const fs = require('fs');
const path = require('path');

// Check if canvas is available
let Canvas;
try {
    Canvas = require('canvas');
} catch (e) {
    console.log('Canvas not installed. Installing would require: npm install canvas');
    console.log('Alternative: Open build/generate-o-icon.html in a browser and download the icons manually.');
    process.exit(0);
}

const { createCanvas } = Canvas;

function generateIcon(size, outputPath) {
    const canvas = createCanvas(size, size);
    const ctx = canvas.getContext('2d');
    
    // Fill background with dark gray (VS Code navbar color)
    ctx.fillStyle = '#2d2d30';
    ctx.fillRect(0, 0, size, size);
    
    // Calculate font size (about 75% of canvas size for good fit)
    const fontSize = Math.floor(size * 0.75);
    
    // Draw Ö symbol in green
    ctx.fillStyle = '#2e8b57';
    ctx.font = `bold ${fontSize}px Arial, sans-serif`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('Ö', size / 2, size / 2);
    
    // Save to file
    const buffer = canvas.toBuffer('image/png');
    fs.writeFileSync(outputPath, buffer);
    console.log(`✓ Generated: ${outputPath} (${size}×${size})`);
}

// Build directory
const buildDir = __dirname;

// Generate icon sizes
const sizes = [
    { size: 16, name: 'icon-16.png' },
    { size: 32, name: 'icon-32.png' },
    { size: 48, name: 'icon-48.png' },
    { size: 64, name: 'icon-64.png' },
    { size: 128, name: 'icon-128.png' },
    { size: 256, name: 'icon.png' },      // Main icon
    { size: 512, name: 'icon-512.png' },
    { size: 1024, name: 'icon-1024.png' }
];

console.log('Generating Ö icons for Ördin...\n');

sizes.forEach(config => {
    const outputPath = path.join(buildDir, config.name);
    generateIcon(config.size, outputPath);
});

console.log('\n✓ All icons generated successfully!');
console.log('\nMain icons:');
console.log('  - icon.png (256×256) - For Windows/Linux');
console.log('  - icon-512.png (512×512) - For macOS and high-DPI displays');
console.log('  - icon-1024.png (1024×1024) - For macOS Retina displays');
console.log('\nTo use in Electron, rebuild the app:');
console.log('  npm run make');
