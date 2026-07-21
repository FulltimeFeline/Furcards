import { Router } from "express";
import path from "node:path";

const EFFECTIVE_DATE = "14 July 2026";
const APK_PATH = path.resolve(process.cwd(), "public/furcards.apk");
const FAVICON_PATH = path.resolve(process.cwd(), "public/favicon.png");
const CONTACT_EMAIL = "navi@fulltimefeline.com";
const DEVELOPER = "FulltimeFeline";

function page(title, bodyHtml) {
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="index,follow">
<link rel="icon" type="image/png" href="/favicon.png">
<link rel="apple-touch-icon" href="/favicon.png">
<title>${title}</title>
<style>
  :root { color-scheme: dark; --accent: #D470CC; --bg: #0f0d12; --panel: #17141b; --text: #ece8f0; --muted: #a79fb0; }
  * { box-sizing: border-box; }
  body { margin: 0; background: var(--bg); color: var(--text);
    font: 16px/1.65 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
  .wrap { max-width: 760px; margin: 0 auto; padding: 40px 22px 80px; }
  header { border-bottom: 1px solid #2a2530; padding-bottom: 20px; margin-bottom: 28px; }
  .brand { font-weight: 800; font-size: 20px; letter-spacing: .3px; color: #fff; }
  .brand span { color: var(--accent); }
  h1 { font-size: 28px; margin: 18px 0 4px; }
  .eff { color: var(--muted); font-size: 14px; margin: 0; }
  h2 { font-size: 20px; margin: 34px 0 8px; color: #fff; }
  h3 { font-size: 16px; margin: 20px 0 6px; color: #fff; }
  p, li { color: var(--text); }
  a { color: var(--accent); }
  ul { padding-left: 22px; }
  li { margin: 6px 0; }
  .note { background: var(--panel); border: 1px solid #2a2530; border-radius: 12px; padding: 14px 16px; color: var(--muted); font-size: 14px; }
  footer { margin-top: 48px; padding-top: 20px; border-top: 1px solid #2a2530; color: var(--muted); font-size: 14px; }
  footer a { color: var(--muted); }
  .btn { display: inline-block; margin: 6px; background: var(--accent); color: #0f0d12; font-weight: 800; padding: 15px 36px; border-radius: 14px; text-decoration: none; }
  .btn.ghost { background: transparent; color: var(--accent); border: 1.5px solid var(--accent); }
</style>
</head>
<body>
<div class="wrap">
  <header>
    <div class="brand">Fur<span>cards</span></div>
  </header>
  ${bodyHtml}
  <footer>
    <p>${DEVELOPER} · <a href="/privacy">Privacy</a> · <a href="/terms">Terms</a> · <a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a></p>
  </footer>
</div>
</body>
</html>`;
}

const privacyBody = `
  <h1>Privacy Policy</h1>
  <p class="eff">Effective ${EFFECTIVE_DATE}</p>

  <p>Furcards is a proximity social app: you build a digital trading card, automatically trade cards with the people around you (Nearby Trading), and bump phones to unlock each other's Shiny card. Furcards is <strong>serverless</strong> — there are no accounts and no Furcards server. Your card travels directly from your phone to other people's phones over Bluetooth, and everything the app stores lives on your device. This policy explains exactly what that means.</p>

  <div class="note">The short version: we don't collect your data, because there is nowhere to collect it to. The app never sends anything to us. Furcards is intended for people aged 18 and over.</div>

  <h2>Who we are</h2>
  <p>Furcards is made by ${DEVELOPER} (“we”, “us”). For any privacy question or request, contact <a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a>.</p>

  <h2>What stays on your device</h2>
  <ul>
    <li><strong>Your card</strong> — display name, pronouns, identity flags, bio, tags, social links, a short message, and any artwork you add. You create it locally; it is the content you intend to share.</li>
    <li><strong>Your collection and history</strong> — the cards you've collected, who you've bumped, and when. Stored only on your device.</li>
    <li><strong>Optional location stamps</strong> — <strong>off by default</strong>. If you turn on location stamps in Settings, the app records a one-time location when an encounter happens: city-level for a Nearby Trading pass, more precise for a bump. These stamps are attached to your private history <strong>on your device only</strong>. They are never transmitted to other users and never to us. With the toggle off (or permission denied), encounters record a timestamp only. Furcards never uses location in the background and never tracks where you go.</li>
    <li><strong>Your signing key</strong> — the app creates a cryptographic keypair that signs your card so others can tell it's really yours. The private key is protected by your device's secure hardware (Keychain / Android Keystore) and never leaves it.</li>
  </ul>

  <h2>What other people receive</h2>
  <p>Furcards is social by design, and sharing happens device-to-device:</p>
  <ul>
    <li><strong>Nearby Trading.</strong> When it's on and you're near another user, your phones exchange your <em>public</em> cards directly over Bluetooth. Fields you mark friends-only are shared only after a mutual bump.</li>
    <li><strong>Rotating identifiers.</strong> Over the air, your phone advertises a random identifier that changes every 15 minutes, so passers-by can't use Bluetooth to track you over time.</li>
    <li><strong>Once shared, a card is shared.</strong> Cards you send live on the recipients' devices, like a physical trading card. Deleting the app doesn't recall cards other people already collected.</li>
  </ul>

  <h2>What we collect</h2>
  <p><strong>From the app: nothing.</strong> The app makes no connection to any Furcards server — there isn't one. No analytics, no crash reporting, no advertising, no tracking, and nothing to sell.</p>
  <p><strong>From this website:</strong> if you visit furcards.app (for example to read this page or download the Android alpha), our hosting provider (Amazon Web Services, Frankfurt, EU) processes standard access logs including your IP address, kept briefly for operation and abuse prevention. The website sets no cookies.</p>

  <h2>Backups and export</h2>
  <ul>
    <li><strong>Device backups.</strong> Your settings and collection are included in your own device backup (iCloud on iPhone, Google backup on Android) under <em>your</em> account, so a new phone restores your collection. We have no access to your backups. Your signing key is device-bound and is <em>not</em> backed up; a restored install creates a fresh one.</li>
    <li><strong>Manual export.</strong> You can export your identity and collection to a file encrypted with a passphrase you choose (for switching between iPhone and Android). Only someone with the passphrase can read it. Keep it safe — we cannot recover it.</li>
  </ul>

  <h2>Notifications</h2>
  <p>The optional daily recap ("you traded cards with N people") is computed and scheduled entirely on your device. Nothing about it goes anywhere.</p>

  <h2>Purchases</h2>
  <p>If you make an optional donation, the payment is processed by <strong>Apple</strong> or <strong>Google</strong> through their in-app purchase systems. We never see your payment details.</p>

  <h2>Your controls</h2>
  <ul>
    <li><strong>Nearby Trading toggle</strong> — turn passive trading off any time in Settings.</li>
    <li><strong>Location stamps toggle</strong> — off by default; encounters work fine without it.</li>
    <li><strong>Blocking</strong> — block anyone from their card; your device will drop and never re-collect their cards.</li>
    <li><strong>Delete</strong> — clear your collection or delete the app; because everything is local, that really is everything.</li>
  </ul>

  <h2>How long data is kept</h2>
  <p>As long as you keep it. Everything lives on your device, so retention is entirely in your hands: remove cards, clear your collection, or delete the app and your own backups.</p>

  <h2>Your rights</h2>
  <p>Laws like the GDPR and CCPA give you rights over personal data an organisation holds about you. We hold none — your data is on your device, and the in-app tools above let you access, export, and erase it directly. For website access logs or anything else, contact <a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a>. You also have the right to complain to your local data-protection authority.</p>

  <h2>Children</h2>
  <p>Furcards is not directed to children and is intended for users 18 and older.</p>

  <h2>Changes to this policy</h2>
  <p>We may update this policy as the app evolves. We will change the effective date above and, for material changes, provide notice in the app.</p>

  <h2>Contact</h2>
  <p>Questions or requests: <a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a>.</p>
`;

const termsBody = `
  <h1>Terms of Use</h1>
  <p class="eff">Effective ${EFFECTIVE_DATE}</p>

  <p>These Terms govern your use of Furcards, made by ${DEVELOPER}. By using the app, you agree to these Terms and acknowledge our <a href="/privacy">Privacy Policy</a>.</p>

  <h2>Eligibility</h2>
  <p>You must be at least 18 years old to use Furcards. By using the app you confirm that you are.</p>

  <h2>How Furcards works</h2>
  <p>Furcards has no accounts and no server. Your card is created on your device, cryptographically signed, and exchanged directly with other users' phones over Bluetooth. We provide the software; we do not host, transmit, store, or moderate the content that moves between devices — we never see it.</p>

  <h2>Your content</h2>
  <p>You own the content you put on your card. Sharing works like handing out a physical trading card: when you trade with someone, a copy of your public card lives on their device and <strong>cannot be remotely recalled</strong>. Share only what you're comfortable with strangers keeping. You grant other users permission to store and display your card within the app as part of how Furcards works. Don't share content you don't have the right to share, and don't impersonate others.</p>

  <h2>Community standards — zero tolerance</h2>
  <p>Furcards is for everyone, and everyone deserves to feel safe and respected. The following are strictly prohibited on any card or message, without exception:</p>
  <ul>
    <li><strong>No discrimination or hate.</strong> No content or conduct that attacks, demeans, dehumanises, harasses, or discriminates against people on the basis of race, ethnicity, national origin, colour, gender, gender identity or expression, sexual orientation, disability, medical condition, religion or belief, age, or any other protected or personal characteristic.</li>
    <li><strong>No hate symbols or hate speech.</strong> No slurs, hateful imagery, extremist or hate-group symbols or names, or content that promotes, glorifies, or incites hatred or violence against any group or individual.</li>
    <li><strong>Absolutely no sexual content involving minors.</strong> Any sexualisation of minors, or any child sexual abuse material (CSAM), is forbidden without exception. Where we become aware of it, we report the material and those responsible to law enforcement.</li>
    <li><strong>No zoophilia or bestiality.</strong> No content that depicts, promotes, or solicits sexual activity involving animals.</li>
    <li><strong>18+ only.</strong> Furcards is exclusively for adults aged 18 and over.</li>
    <li><strong>No harassment, threats, or violence.</strong> No bullying, stalking, threats, doxxing, or incitement of violence or self-harm toward anyone.</li>
    <li><strong>Everything must be legal in Spain.</strong> Furcards is operated from and governed by the laws of Spain. Any content or conduct that is illegal under Spanish law is prohibited, wherever you are located.</li>
  </ul>
  <p><strong>Enforcement in a serverless app:</strong> because cards travel directly between devices, there is no central moderation — we cannot see, remove, or ban anything remotely. You are solely responsible and liable for the content you share. Protect yourself with the in-app <strong>Block</strong> feature, which permanently drops someone's cards from your device, and report unlawful content to the relevant authorities and to <a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a>.</p>

  <h2>Acceptable use</h2>
  <p>In addition to the community standards above, you agree not to:</p>
  <ul>
    <li>share illegal, infringing, non-consensual, or sexually explicit content, or content you don't have the right to share;</li>
    <li>impersonate anyone, forge cards, or misrepresent your identity;</li>
    <li>spam, flood, or otherwise disrupt the Bluetooth exchange, or attempt to track other users;</li>
    <li>use Furcards for any unlawful purpose.</li>
  </ul>

  <h2>Safety</h2>
  <p>Furcards helps you meet people in the real world. Use good judgment when interacting with others; we do not vet users and are not responsible for their conduct. You can block any user from their card at any time.</p>

  <h2>Purchases</h2>
  <p>Optional donations are processed by Apple or Google under their terms and are generally non-refundable except as required by law or their policies.</p>

  <h2>Disclaimer &amp; limitation of liability</h2>
  <p>Furcards is provided “as is”, without warranties of any kind. To the fullest extent permitted by law, ${DEVELOPER} is not liable for any indirect, incidental, or consequential damages, for the conduct of other users, or for content other users share with you.</p>

  <h2>Termination</h2>
  <p>You may stop using Furcards at any time by deleting the app; because there are no accounts, nothing else is required. These Terms apply for as long as you use the app.</p>

  <h2>Governing law</h2>
  <p>These Terms and your use of Furcards are governed by the laws of Spain, and any disputes are subject to the jurisdiction of the competent courts of Spain, without regard to conflict-of-law rules. Nothing here removes mandatory consumer protections you may have where you live.</p>

  <h2>Changes</h2>
  <p>We may update these Terms; we will update the effective date and, for material changes, notify you in the app. Continued use after changes means you accept them.</p>

  <h2>Contact</h2>
  <p>Questions or reports of prohibited content: <a href="mailto:${CONTACT_EMAIL}">${CONTACT_EMAIL}</a>.</p>
`;

const homeBody = `
  <div style="text-align:center; padding-top:24px;">
    <h1 style="font-size:44px; margin:0;">Fur<span style="color:var(--accent)">cards</span></h1>
    <p style="color:var(--muted); margin:10px auto 0; max-width:560px;">A trading-card app for furries and friends. Build a digital fursona card and swap it with the people around you — phone to phone, no accounts, no server. Your cards never leave the devices involved.</p>
  </div>

  <div style="text-align:center; margin:28px 0 8px;">
    <a class="btn" href="/download/android">Android alpha</a>
    <a class="btn ghost" href="https://testflight.apple.com/join/rYBC5zr7">iPhone beta (TestFlight)</a>
  </div>
  <p style="text-align:center; color:var(--muted); font-size:13px; margin:0 auto 8px;">Alpha 2.0 · the iPhone beta runs through Apple's TestFlight.</p>

  <h2>How it works</h2>
  <p>Furcards is fully <strong>serverless</strong>. There are no accounts and nothing to sign up for — everything happens directly between phones over Bluetooth, and everything you collect lives on your device.</p>
  <ul>
    <li><strong>Build your card.</strong> Add your fursona's name, pronouns, art, bio, tags, and links. It's the profile everyone around you sees.</li>
    <li><strong>Nearby Trading.</strong> Turn it on and your phone quietly swaps public cards with other Furcards users you pass — no tapping, no opening the app. They collect yours, you collect theirs.</li>
    <li><strong>Bump to go Shiny.</strong> Met someone in person? Both open each other's card and tap Bump, phones held together. A mutual bump unlocks each other's glowing Shiny card — the private links you don't share with just anyone.</li>
    <li><strong>Trade in the Background.</strong> Pocket your phone at a con and keep collecting as you walk around.</li>
  </ul>

  <h2>Android vs iPhone: trading in your pocket</h2>
  <p>Both apps trade cards the exact same way when they're open. They differ in one place: what happens when the phone goes in your pocket.</p>
  <ul>
    <li><strong>Android</strong> can trade <strong>fully in the background</strong>. Once Nearby Trading is on, it keeps a lightweight service running, so it quietly collects and shares cards even with the app closed, the screen off, and the phone locked in your pocket. Nothing to keep open.</li>
    <li><strong>iPhone</strong> can't do that, and it's not our choice — Apple pauses an app's Bluetooth the moment it isn't active on screen. So for hands-free trading you tap <strong>"Trade in the Background"</strong>: the app shows a dark, dimmed screen that stays awake (with a gentle bouncing marker so nothing burns in) and keeps trading while it's in your pocket. The one rule is <strong>don't lock your phone</strong> — as soon as the screen locks, iOS stops the Bluetooth and trading pauses until you wake it again. Battery drain at that brightness is minimal.</li>
  </ul>
  <div class="note">In short: on Android, turn it on and forget it. On iPhone, open "Trade in the Background" and leave the screen unlocked while it's in your pocket.</div>

  <h2>Your data stays yours</h2>
  <ul>
    <li><strong>No server, no accounts, no tracking.</strong> The app never sends your data anywhere — there's nowhere for it to go.</li>
    <li><strong>Signed cards.</strong> Every card is cryptographically signed, so the one you receive is provably the real thing.</li>
    <li><strong>Private by default.</strong> Optional location stamps are off unless you turn them on, and friends-only links stay hidden until you bump.</li>
    <li><strong>You're in control.</strong> Block or remove anyone from their card, and reset everything from Settings whenever you like.</li>
  </ul>

  <div style="text-align:center; margin:30px 0 4px;">
    <a class="btn" href="/download/android">Android alpha</a>
    <a class="btn ghost" href="https://testflight.apple.com/join/rYBC5zr7">iPhone beta (TestFlight)</a>
  </div>
  <p style="text-align:center; margin:14px 0 0;"><a href="/privacy">Privacy Policy</a> &nbsp;·&nbsp; <a href="/terms">Terms of Use</a></p>
`;

export const legalRouter = Router();

function sendPage(res, title, body) {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'none'; style-src 'unsafe-inline'; img-src 'self' data:; base-uri 'none'; form-action 'none'"
  );
  res.type("html").send(page(title, body));
}

legalRouter.get("/", (_req, res) => sendPage(res, "Furcards", homeBody));
legalRouter.get("/privacy", (_req, res) => sendPage(res, "Privacy Policy — Furcards", privacyBody));
legalRouter.get("/terms", (_req, res) => sendPage(res, "Terms of Use — Furcards", termsBody));

legalRouter.get("/download/android", (_req, res) => {
  res.type("application/vnd.android.package-archive");
  res.setHeader("Content-Disposition", 'attachment; filename="Furcards-Alpha-2.0.apk"');
  res.sendFile(APK_PATH, (err) => {
    if (err && !res.headersSent) res.status(404).send("apk not found");
  });
});

legalRouter.get(["/favicon.png", "/favicon.ico"], (_req, res) => {
  res.type("image/png");
  res.sendFile(FAVICON_PATH, (err) => {
    if (err && !res.headersSent) res.status(404).end();
  });
});
