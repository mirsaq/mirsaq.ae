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
