# mirsaq.ae — GSC Log

---

## GSC Daily Report — 2026-10-31

- **Clicks (3-month total):** 362
- **Impressions (3-month total):** 5,600
- **Avg CTR:** 6.5%
- **Avg position:** 17.6
- **Indexed pages:** 91
- **Not indexed:** 28

### Top queries (by clicks)
| Query | Clicks | Impressions |
|---|---|---|
| mirsaq general trading llc | 10 | 37 |
| mirsaq | 8 | 29 |
| import iphone from dubai | 1 | 33 |
| ps5 wholesale dubai | 1 | 11 |
| nintendo switch оптом | 1 | 11 |
| iphone 18 wholesale | 1 | 5 |
| xbox оптом | 1 | 5 |

Total: 265 queries triggering impressions

### Indexing breakdown (28 not indexed)
| Reason | Count | Status |
|---|---|---|
| Redirect error | 23 | Validation started 19/09/2026 — STALE, clearing |
| Page with redirect | 4 | Validation started — likely same root cause |
| Discovered – currently not indexed | 1 | Passed |
| Crawled - currently not indexed | 0 | — |

**Redirect error diagnosis:** These 23 pages (electronics-wholesale-*, garmin-chasy-optom-*, /contact, dyson-optom-*, accessories-wholesale-*) all exist and return HTTP 200. The error was caused by old `.html` in canonical/og:url tags — fixed in commit `e7aaab0`. Validation started 19/09/2026. Trend is declining (was 70+ pages in Aug, now 23). No action needed — will self-resolve as Googlebot re-crawls. ETA: 2–4 more weeks.

### Shopping / Structured data
- Product snippets: 39 valid, 2 invalid
- Merchant listings: 37 valid, 2 invalid
- Breadcrumbs: 86 valid, 0 invalid

### Core Web Vitals
- No data yet (site may not have enough traffic threshold for CWV report)

### Security / Manual Actions
- None

### HTTPS
- 90 pages HTTPS ✓

### Actions taken
- None (redirect errors are stale and self-resolving)
- Established baseline log

### Next
- Day 2 GSC indexing scheduled for 2026-11-01 10:00 AM (garmin, dyson, jbl pages — 10 URLs)
- Day 3 GSC indexing to be auto-created by Day 2 task (jbl-maldives, sony, playstation, etc. — 6 URLs)
- Monitor redirect error count — should drop below 10 by mid-November
- Watch for new indexing issues as Day 2/3 pages get indexed
- Shopping invalid: investigate 2 invalid product snippets and 2 invalid merchant listings

---

## GSC Daily Report — 2026-11-03

_Data window: 25–31 Oct 2026 vs 18–24 Oct (GSC has a ~3-day lag). Pulled through the OpenSEO Search Console API, because the built-in browser was signed out of Google and the GSC UI couldn't be opened._

- **Clicks (7d):** 46 (+17.9% vs 39)
- **Impressions (7d):** 772 (−11.6% vs 873)
- **Avg CTR:** 5.96% (was 4.47%)
- **Avg position:** 19.1 (was 21.7 — better; daily position ~12–15 since 27 Oct)
- **Pages with impressions:** 91 (was 85)
- **Indexed / Not indexed:** not available (needs the GSC UI; last known 91 / 28 on 2026-10-31)
- **New issues:** None found
- **Actions taken:** None. Indexing requests weren't possible without a GSC UI session.

### Pages with fewer clicks week-over-week (>20% drop, all small numbers)
| Page | Prev → Now |
|---|---|
| / (homepage) | 6 → 4 |
| electronics-wholesale-cis | 3 → 1 (position 36.7 → 3.3, so this is noise) |
| electronics-wholesale-pakistan | 3 → 0 (indexed, crawled 26 Oct) |
| iphone-wholesale-saudi-arabia | 2 → 0 |
| electronics-wholesale-bahrain / -kazakhstan / -kyrgyzstan, garmin-chasy-optom-russia, xbox-wholesale-russia | 1 → 0 |

### Gaining traction
- iphone-wholesale-dubai 3 → 6 clicks (212 impressions, position 41.9, ranking for many "bulk/refurbished iphone" queries in the 50s–70s)
- iphone-wholesale-russia 2 → 4, ps5-wholesale-kazakhstan 1 → 3, nintendo-wholesale-russia 0 → 2, electronics-wholesale-armenia 0 → 2
- garmin-fenix-8/9-optom, dyson-v15-optom, garmin-wholesale-maldives each got clicks
- Pages with impressions for the first time: dyson-supersonic-optom, garmin-epix-pro-optom, garmin-instinct-2-solar-optom, redmi-poco-wholesale-russia, and electronics-wholesale-afghanistan/azerbaijan/bangladesh/ethiopia/ghana/iran/seychelles/tanzania/uzbekistan
- Query wins: "iphone 18 wholesale" (#1), "nintendo switch оптом" (#5), "import iphone from dubai" (#3.8, 6 impressions, 0 clicks — worth checking the snippet)

### URL Inspection checks
| URL | Status |
|---|---|
| blog/dyson-wholesale-dubai-guide | Indexed (crawled 2 Nov) ✓ |
| blog/samsung-wholesale-dubai-guide | **Unknown to Google**. Live 200, in sitemap. Needs an indexing request |
| blog/garmin-wholesale-dubai-guide | **Unknown to Google**. Live 200, in sitemap. Needs an indexing request |
| /contact | "Redirect error" from a stale crawl on 26 Aug. Live now: 200 (www → apex 308). Same known issue; will clear on recrawl |
| sony-wholesale-dubai, dyson-wholesale-dubai, garmin-wholesale-kazakhstan, browse, accessories-wholesale-dubai, electronics-wholesale-pakistan | Indexed ✓ |

Rich results: Product snippet warnings only (missing aggregateRating/review, hasMerchantReturnPolicy). No errors.

### Not checked today (needs a signed-in GSC UI)
- Page indexing counts, Core Web Vitals, sitemap status report, Manual actions / Security. Last check (31 Oct): no manual actions, CWV no data.

### Next
- Sign the built-in browser in to Google (mjjunu313@gmail.com) so daily runs can open the GSC UI again
- Request indexing for blog/samsung-wholesale-dubai-guide and blog/garmin-wholesale-dubai-guide
- Untracked local drafts (blog/apple-, iphone-, jbl-wholesale-dubai-guide.html) aren't committed or live yet
- Keep monitoring /contact redirect error and the other stale redirect errors

---

## GSC Daily Report — 2026-11-04

_Data window: 26 Oct – 1 Nov 2026 vs 19–25 Oct (GSC lags about 3 days). Pulled through the OpenSEO Search Console API. The built-in browser is still signed out of Google, and Claude in Chrome wasn't connected, so the GSC UI couldn't be opened again._

- **Clicks (7d):** 48 (+26.3% vs 38)
- **Impressions (7d):** 707 (−22.1% vs 908)
- **Avg CTR:** 6.79% (was 4.19%)
- **Avg position:** 16.1 (was 23.5, impression-weighted, so better)
- **Pages with impressions:** 95 (was 83)
- **Indexed / Not indexed:** not available (needs the GSC UI; last known 91 / 28 on 2026-10-31)
- **New issues:** None
- **Actions taken:** None. Indexing requests can't be made through the API, and there was nothing to fix.

### Why impressions fell
Most of the drop comes from iphone-wholesale-dubai (284 → 144 impressions). Its position *improved* (50 → 35.3), so this looks like lost deep-SERP impressions, not a ranking loss. iphone-wholesale-maldives also fell (36 → 13). Clicks went up.

### Pages with >20% fewer clicks (all small numbers, so likely noise)
| Page | Prev → Now | Note |
|---|---|---|
| electronics-wholesale-pakistan | 3 → 0 | Indexed, position 3.3 → 7.3 |
| iphone-wholesale-saudi-arabia | 2 → 0 | Indexed, last crawled 20 Sep; position 6.4 → 19.8 |
| electronics-wholesale-cis | 2 → 1 | Position 41.5 → 3.3 |
| blog/iphone-import-dubai | 1 → 0 | 28 impressions at position 5.9 with 0 clicks, so the snippet may need work |
| electronics-wholesale-bahrain / -kazakhstan / -kyrgyzstan, garmin-chasy-optom-russia, xbox-wholesale-russia | 1 → 0 | |

### Gaining traction
- ps5-wholesale-russia 2 → 6 clicks (position 8.9), iphone-wholesale-russia 1 → 4, samsung-wholesale-russia 2 → 3
- nintendo-wholesale-russia 0 → 2, electronics-wholesale-armenia 0 → 2
- First clicks: dyson-optom-kazakhstan, dyson-v15-optom, electronics-wholesale-maldives/-nigeria/-russian, garmin-fenix-8/9-optom, garmin-chasy-optom-azerbaijan, garmin-wholesale-maldives, xiaomi-wholesale-russia
- Homepage position 11.8 → 5.3

### URL Inspection checks
| URL | Status |
|---|---|
| blog/samsung-wholesale-dubai-guide | **Indexed now** (crawled 3 Nov) ✓ |
| blog/garmin-wholesale-dubai-guide | Discovered, not indexed yet (it was unknown yesterday, so progress) |
| blog/apple-, iphone-, jbl-wholesale-dubai-guide, blog/electronics-wholesale-russia-guide | Unknown to Google. All live (200) and in the sitemap since 3 Nov |
| /contact | Same stale "Redirect error" from the 26 Aug crawl; live 200 |
| electronics-wholesale-pakistan, iphone-wholesale-saudi-arabia, blog/iphone-import-dubai | Indexed ✓ |

Sitemap: live, 134 URLs, matches the repo. Its processing status in GSC wasn't checked (needs the UI).

### Not checked today (needs a signed-in GSC UI)
- Page indexing counts, Core Web Vitals, sitemap report, Manual actions / Security. Last check (31 Oct): no manual actions, CWV no data.

### Next
- Sign the built-in browser in to Google (mjjunu313@gmail.com) so daily runs can open the GSC UI and request indexing
- Request indexing for: blog/garmin-wholesale-dubai-guide, blog/apple-wholesale-dubai-guide, blog/iphone-wholesale-dubai-guide, blog/jbl-wholesale-dubai-guide, blog/electronics-wholesale-russia-guide
- Consider rewriting the title/meta of blog/iphone-import-dubai (position ~6, 0% CTR)

---

## GSC Daily Report — 2026-11-05

_Data window: 27 Oct – 2 Nov 2026 vs 20–26 Oct (GSC lags about 3 days). Pulled through the OpenSEO Search Console API. The built-in browser is still signed out of Google and Claude in Chrome isn't connected, so the GSC UI couldn't be opened for the third day running._

- **Clicks (7d):** 57 (+67.6% vs 34)
- **Impressions (7d):** 699 (−23.3% vs 911)
- **Avg CTR:** 8.15% (was 3.73%)
- **Avg position:** 16.9 (was 24.4, impression-weighted, so better)
- **Pages with impressions:** 95 (was 85)
- **Indexed / Not indexed:** not available (needs the GSC UI; last known 91 / 28 on 2026-10-31)
- **New issues:** None
- **Actions taken:** None. Indexing requests can't be made through the API, and there was nothing to fix.

### Notes
- Impressions are down again because iphone-wholesale-dubai lost deep-SERP impressions (306 → 117; position 49 → 40). Clicks on the site as a whole are up strongly.
- 2 Nov had an average position of 30.6 (other days 11–17), which looks like a single-day burst of deep impressions. Partial 3 Nov data shows 14 clicks, the best day in the window.
- blog/iphone-import-dubai: 33 impressions at position 6 and 0 clicks (main query "import iphone from dubai", position 7.4). Its title and meta were refreshed on 31 Oct and Google hasn't recrawled it yet, so I left it unchanged. Check again after the next crawl.

### Pages with >20% fewer clicks (all small numbers)
| Page | Prev → Now | Note |
|---|---|---|
| iphone-wholesale-dubai | 5 → 3 | Indexed, crawled 27 Oct; impressions −62% (deep SERP) |
| ps5-wholesale-kazakhstan | 3 → 1 | Indexed, crawled 31 Oct; position 4.3 → 8.9 |
| electronics-wholesale-pakistan | 2 → 0 | Position 3.6 → 6.0 |
| iphone-wholesale-saudi-arabia | 2 → 0 | Indexed, but last crawled 20 Sep; position 6.3 → 24.0 (watch this) |
| blog/iphone-import-dubai, electronics-wholesale-bahrain/-kazakhstan/-kyrgyzstan, garmin-chasy-optom-russia, xbox-wholesale-russia | 1 → 0 | |

### Gaining traction
- ps5-wholesale-russia 2 → 9 clicks (76 impressions, position 9.3), iphone-wholesale-russia 0 → 5 (position 5.2)
- Homepage 5 → 9 clicks (position 12.2 → 5.9); playstation-wholesale-dubai 2 → 4
- electronics-wholesale-tajikistan 0 → 2, nintendo-wholesale-russia 0 → 2
- First clicks: dyson-airstrait-optom, dyson-wholesale-russia, electronics-wholesale-maldives/-nigeria/-russian, garmin-fenix-8/9-optom, garmin-wholesale-maldives, garmin-chasy-optom-azerbaijan

### URL Inspection checks
| URL | Status |
|---|---|
| blog/samsung-wholesale-dubai-guide | Indexed ✓ (crawled 3 Nov) |
| blog/garmin-wholesale-dubai-guide | Discovered, not indexed yet (no change) |
| blog/apple-, iphone-, jbl-wholesale-dubai-guide, blog/electronics-wholesale-russia-guide | Still unknown to Google. All live (200) and in the sitemap |
| /contact | Same stale "Redirect error" from the 26 Aug crawl; live 200 |
| iphone-wholesale-saudi-arabia, ps5-wholesale-kazakhstan, iphone-wholesale-dubai | Indexed ✓ |

Sitemap: live, 134 URLs. Its processing status in GSC wasn't checked (needs the UI).

### Not checked today (needs a signed-in GSC UI)
- Page indexing counts, Core Web Vitals, sitemap report, Manual actions / Security. Last check (31 Oct): no manual actions, CWV no data.

### Next
- **Blocker:** sign the built-in browser in to Google (mjjunu313@gmail.com), or connect Claude in Chrome, so daily runs can open the GSC UI and request indexing
- Request indexing for: blog/garmin-wholesale-dubai-guide, blog/apple-wholesale-dubai-guide, blog/iphone-wholesale-dubai-guide, blog/jbl-wholesale-dubai-guide, blog/electronics-wholesale-russia-guide, /contact, iphone-wholesale-saudi-arabia (last crawl 20 Sep)
- Recheck blog/iphone-import-dubai CTR after Google recrawls it

---
