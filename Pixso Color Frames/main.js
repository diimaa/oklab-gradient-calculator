const FRAME_WIDTH = 1;
const FRAME_HEIGHT = 64;
const FRAME_GAP = 0;

let cachedColors = [];

pixso.showUI(__html__, { width: 360, height: 420 });

pixso.ui.onmessage = (msg) => {
  if (msg.type === 'parseColors') {
    cachedColors = extractHexColors(msg.payload);
    pixso.ui.postMessage({ type: 'colorCount', count: cachedColors.length });
    return;
  }

  if (msg.type === 'generateFrames') {
    if (!cachedColors.length) {
      pixso.ui.postMessage({ type: 'error', message: 'Сначала введите корректный список цветов.' });
      return;
    }

    const createdNodes = [];
    const viewportCenter = pixso.viewport.center;
    const totalWidth =
      cachedColors.length * FRAME_WIDTH + (cachedColors.length - 1) * FRAME_GAP;
    const startX = viewportCenter.x - totalWidth / 2;

    cachedColors.forEach((hex, index) => {
      const frame = pixso.createFrame();
      frame.resize(FRAME_WIDTH, FRAME_HEIGHT);
      frame.x = startX + index * (FRAME_WIDTH + FRAME_GAP);
      frame.y = viewportCenter.y - FRAME_HEIGHT / 2;
      frame.fills = [
        {
          type: 'SOLID',
          color: hexToRgb01(hex),
          opacity: 1
        }
      ];
      frame.name = `color_${String(index + 1).padStart(3, '0')}`;
      pixso.currentPage.appendChild(frame);
      createdNodes.push(frame);
    });

    pixso.currentPage.selection = createdNodes;
    pixso.viewport.scrollAndZoomIntoView(createdNodes);
    pixso.closePlugin(`Создано ${createdNodes.length} фреймов.`);
  }
};

function extractHexColors(input) {
  if (!input) return [];
  return input
    .split(',')
    .map((token) => token.trim().toUpperCase())
    .filter((token) => /^#[0-9A-F]{6}$/.test(token));
}

function hexToRgb01(hex) {
  const clean = hex.replace('#', '');
  const r = parseInt(clean.slice(0, 2), 16) / 255;
  const g = parseInt(clean.slice(2, 4), 16) / 255;
  const b = parseInt(clean.slice(4, 6), 16) / 255;
  return { r, g, b };
}