// Checks the cast icon that CastWebView.kt draws over videos, in a real browser engine
// (Chromium via Playwright) with touch events like a phone:
//   node tool/check_cast_overlay.js
// Needs `playwright` (npm i playwright). It reads the injected script straight out of
// android/app/src/main/kotlin/com/castflow/castflow/CastWebView.kt.
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const kt = fs.readFileSync(path.join(__dirname, '../android/app/src/main/kotlin/com/castflow/castflow/CastWebView.kt'), 'utf8');
const start = kt.indexOf('private val DETECT_JS = """') + 'private val DETECT_JS = """'.length;
const js = kt.slice(start, kt.indexOf('"""', start));

const html = `<!doctype html><body style="margin:0;height:3000px"><div style="height:60px"></div>
<video id="big" src="https://example.com/big.mp4" style="width:320px;height:180px;display:block;margin-left:20px"></video>
<video id="small" src="https://example.com/small.mp4" style="width:80px;height:45px;display:block"></video>
<video id="hidden" src="https://example.com/hidden.mp4" style="width:320px;height:180px;display:none"></video>
<div style="height:1500px"></div>
<video id="far" src="https://example.com/far.mp4" style="width:320px;height:180px;display:block"></video></body>`;

let failed = 0;
const check = (ok, what) => { console.log((ok ? 'ok   ' : 'FAIL ') + what); if (!ok) failed++; };

(async () => {
  const browser = await chromium.launch();
  for (const mode of ['touch', 'mouse']) {
    const ctx = await browser.newContext({ hasTouch: mode === 'touch', isMobile: mode === 'touch', viewport: { width: 390, height: 700 } });
    const page = await ctx.newPage();
    const errors = [];
    page.on('pageerror', (e) => errors.push(String(e)));
    await page.setContent(html);
    // What the Android WebView provides to the page (CastFlowBridge).
    await page.evaluate(() => {
      window.__taps = [];
      window.CastFlowBridge = { report() {}, drm() {}, castTap: (j) => window.__taps.push(JSON.parse(j)) };
    });
    await page.evaluate(js);
    await page.waitForTimeout(900);
    const visible = () => page.evaluate(() => {
      const root = document.querySelector('[data-castflow]');
      return root ? [...root.children].filter((b) => b.style.display !== 'none').map((b) => { const r = b.getBoundingClientRect(); return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; }) : [];
    });
    let v = await visible();
    check(v.length === 1, `[${mode}] only the large visible video gets an icon`);
    if (mode === 'touch') await page.touchscreen.tap(v[0].x, v[0].y); else await page.mouse.click(v[0].x, v[0].y);
    await page.waitForTimeout(400);
    const taps = await page.evaluate(() => window.__taps);
    check(taps.length === 1 && taps[0].url === 'https://example.com/big.mp4', `[${mode}] one tap casts that video once (got ${taps.length})`);
    await page.evaluate(() => window.scrollTo(0, 1700));
    await page.waitForTimeout(900);
    v = await visible();
    check(v.length === 1, `[${mode}] scrolling moves the icon to the video now on screen`);
    await page.evaluate(() => document.getElementById('far').remove());
    await page.waitForTimeout(900);
    check((await visible()).length === 0, `[${mode}] removing the video removes its icon`);
    check(errors.length === 0, `[${mode}] no script errors`);
    await ctx.close();
  }
  await browser.close();
  process.exit(failed ? 1 : 0);
})();
