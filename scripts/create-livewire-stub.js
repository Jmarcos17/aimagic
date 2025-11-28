#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Cria o diretório se não existir
const stubDir = path.join(__dirname, '../node_modules/livewire/livewire/dist');
const stubFile = path.join(stubDir, 'livewire.esm.js');
const stubFileNoExt = path.join(stubDir, 'livewire.esm');

if (!fs.existsSync(stubDir)) {
  fs.mkdirSync(stubDir, { recursive: true });
}

// Cria o stub do Livewire
const stubContent = `// Temporary stub for Vercel build - Livewire will be loaded from vendor in production
export const Alpine = window.Alpine || (() => {
  console.warn('Alpine.js should be loaded before Livewire');
  return {};
})();

export const Livewire = {
  start: () => {
    console.warn('Livewire.start() called - Livewire should be loaded from vendor in production');
  }
};
`;

fs.writeFileSync(stubFile, stubContent, 'utf8');
// Também cria sem extensão para compatibilidade
fs.writeFileSync(stubFileNoExt, stubContent, 'utf8');
console.log('✓ Livewire stub created for build');

