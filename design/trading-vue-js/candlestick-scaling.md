# Candlestick scaling: model and math

This document describes how the chart scales candlestick **width** (time axis) and **height** (price axis) from data space to screen pixels. It focuses on the **model and derived variables** so you can reimplement the same behavior in any framework or language.

---

## Context

- **Data**: Each candlestick is one OHLCV point: `[t, o, h, l, c, v]` — time, open, high, low, close, volume. Time and prices are in your data units (e.g. ms and dollars).
- **Goal**: Map the **visible window** of data onto a **pixel rectangle** (chart area), and compute for each candle:
  - **Horizontal**: center x, width in pixels.
  - **Vertical**: pixel y for open, high, low, close (and optionally volume bar height).

So we need:

- **Time → x**: map timestamp `t` to screen x (and derive candle width from “pixels per bar”).
- **Price → y**: map price (or log(price)) to screen y.

Everything below is in terms of **tracked (main) variables** and **derived variables** used to draw.

---

## Main variables (what to track)

These are the inputs / state your chart keeps. All scaling is expressed from them.

| Variable | Meaning | Units / notes |
|----------|---------|----------------|
| **time_range** | Visible time window | `[t_min, t_max]` in same units as `t` (e.g. ms) |
| **bar_interval** | Time step between consecutive candles in the main series | Same units as `t` (e.g. 60000 for 1‑minute bars) |
| **chart_width** | Chart drawing width | Pixels (often “total width − sidebar”) |
| **chart_height** | Chart drawing height (for the price axis) | Pixels |
| **price_high** | Upper bound of visible price range | Data price units |
| **price_low** | Lower bound of visible price range | Data price units |
| **use_log_scale** | Use log(price) for Y axis | Boolean |

Optional config (tunable constants):

- **candle_width_ratio** — candle width as fraction of the “step” (e.g. `0.6` ⇒ 60% of `pixels_per_bar`).
- **price_range_expand** — fractional padding of the price range (e.g. `0.15` ⇒ 15% above high and below low).
- **volume_height_ratio** — target fraction of height used for volume (e.g. `0.15`).

**price_high** and **price_low** are either:

- **Auto**: from data in view — e.g. `data_high = max(high)`, `data_low = min(low)` over visible subset, then optionally:
  - **Linear**: `price_high = data_high + (data_high - data_low) * price_range_expand`, `price_low = data_low - (data_high - data_low) * price_range_expand`.
  - **Log**: keep `price_high = data_high`, `price_low = data_low` then apply a log-scale expand (see Log scale section).
- **Fixed**: user-defined or from a fixed y-axis range.

So the **main variables** you must keep track of are: **time_range**, **bar_interval**, **chart_width**, **chart_height**, **price_high**, **price_low**, and **use_log_scale** (plus optional config). The **subset of data** in view is implied by **time_range** (and your data source).

---

## Derived variables (from main variables)

All of these can be computed from the main variables above. They are what you actually use to convert data → pixels and to choose candle dimensions.

### X-axis (time → screen)

| Variable | Formula | Meaning |
|----------|--------|--------|
| **time_span** | `time_range[1] - time_range[0]` | Time span currently visible |
| **draw_width** | `chart_width - sidebar` (or just `chart_width`) | Drawable horizontal pixels |
| **bar_capacity** | `time_span / bar_interval` | Number of “candle slots” in the visible window |
| **pixels_per_bar** | `draw_width / bar_capacity` | Pixels per candle slot (one bar step) |
| **px_per_time** | `draw_width / time_span` | Pixels per unit of time |

**Time → x:**

- **time_to_screen(t)** = `(t - time_range[0]) * px_per_time`  
  So `time_range[0]` → 0, `time_range[1]` → `draw_width`.  
  In the codebase this is often stored as a function and then used as `floor(time_to_screen(t)) ± 0.5` for pixel alignment.

**Candle width (horizontal):**

- **candle_width_px** = `pixels_per_bar * candle_width_ratio`  
  So candle width is a fixed fraction of the step. When you have overlays with a different bar interval (e.g. higher timeframe), use **interval_ratio** = overlay_interval / main_interval and set **candle_width_px** = `pixels_per_bar * candle_width_ratio * interval_ratio`.

So for **width** you only need: **pixels_per_bar** (from **time_range**, **bar_interval**, **draw_width**) and **candle_width_ratio** (and optional **interval_ratio**). Candle **center x** is **time_to_screen(t)** (with whatever rounding you use).

### Y-axis (price → screen)

We want: price at **price_high** at the **top** of the chart (small y) and **price_low** at the **bottom** (large y). So we use a linear map **y = price × price_scale + price_offset** with **price_scale** negative.

**Linear scale:**

| Variable | Formula | Meaning |
|----------|--------|--------|
| **price_scale** | `- chart_height / (price_high - price_low)` | Pixels per price unit (negative so high → top) |
| **price_offset** | `- price_high * price_scale` | Shift so that `price_high` → 0 |

Then:

- **price → y**: `y = price * price_scale + price_offset`.  
  So `price_high` → 0, `price_low` → `chart_height`.
- When drawing, use integer pixel: e.g. `y_px = floor(price * price_scale + price_offset)` for o, h, l, c.

**Log scale:**

Use the same idea in **log(price)** space:

- **price_scale** = `- chart_height / (log(price_high) - log(price_low))`
- **price_offset** = `- log(price_high) * price_scale`
- **price → y**: `y = log(price) * price_scale + price_offset`
- For **screen → price**: `price = exp((y - price_offset) / price_scale)`.

So the **derived** Y variables are **price_scale** and **price_offset**; all candle o, h, l, c in pixels come from applying this transform to the raw prices (or their logs).

### Per-candle draw variables (all derived)

For each OHLCV point **p** = `[t, o, h, l, c, v]`:

| Quantity | Formula (linear) | Formula (log) |
|----------|-------------------|---------------|
| **x** | `time_to_screen(p[0])` (+ optional 0.5 for centering) | same |
| **candle_width_px** | `pixels_per_bar * candle_width_ratio` (× interval_ratio if different interval) | same |
| **o** | `floor(p[1] * price_scale + price_offset)` | `floor(log(p[1]) * price_scale + price_offset)` |
| **h** | `floor(p[2] * price_scale + price_offset)` | `floor(log(p[2]) * price_scale + price_offset)` |
| **l** | `floor(p[3] * price_scale + price_offset)` | `floor(log(p[3]) * price_scale + price_offset)` |
| **c** | `floor(p[4] * price_scale + price_offset)` | `floor(log(p[4]) * price_scale + price_offset)` |

From these you draw:

- **Wick**: vertical line from **(x, h)** to **(x, l)**.
- **Body**: rectangle from **(x - candle_width_px/2, min(o,c))** to **(x + candle_width_px/2, max(o,c))** (with your convention for up/down and minimum body height for dojis).

So **candle height** on screen is not a single “scale” number: it comes from the **Y transform (price_scale, price_offset)** applied to **o, h, l, c**. The “scale” of the candle in the vertical direction is **price_scale** (pixels per price unit, or per log(price) in log mode).

### Volume bar height (optional)

If you draw volume bars:

- **max_volume** = max of `p[5]` over the visible subset.
- **volume_scale** = `volume_height_ratio * chart_height / max_volume` (pixels per volume unit).
- **Bar height** for volume at **p** = `p[5] * volume_scale` (pixels).

So volume height is derived from **chart_height**, **volume_height_ratio**, and the max volume in view.

---

## Log scale: why use it and a numeric example

### Why use log scale?

On a **linear** Y-axis, a move of +10 dollars always uses the same vertical distance, whether the price is 100 or 10,000. So a +10 move from 100 to 110 looks much larger than a +10 move from 10,000 to 10,010, even though the first is +10% and the second is +0.1%. For many assets, **percentage (relative) moves** are what matter: a 5% move is similar in meaning whether the price is 50 or 500.

A **log scale** maps **log(price)** to y. Equal *percentage* changes in price become equal *distances* on the screen. For example:

- Doubling from 100 → 200 is the same percentage change as 500 → 1000.
- In log space: log(200) − log(100) = ln(2) ≈ 0.693, and log(1000) − log(500) = ln(2) ≈ 0.693.
- So both “doublings” get the same vertical pixel distance.

That makes log scale better when:

- You care about relative (percent) moves rather than absolute moves.
- Price spans several orders of magnitude (e.g. 10 to 10,000).
- You want to compare shape of moves at different price levels.

### Example in numbers

Suppose **price_high** = 1000, **price_low** = 100, **chart_height** = 300 px.

**Linear scale:**

- **price_scale** = −300 / (1000 − 100) = −1/3.
- **price_offset** = −1000 × (−1/3) = 1000/3 ≈ 333.33.
- Move 100 → 200: Δprice = 100 → Δy = 100 × (−1/3) = −33.33 px (about 11% of chart height).
- Move 900 → 1000: Δprice = 100 → Δy = 100 × (−1/3) = −33.33 px (same 11% of chart height).

So in linear scale, the same *absolute* move (100) always gets the same pixels; the *percentage* move 100→200 (+100%) is drawn much bigger than 900→1000 (+11%).

**Log scale:**

- log(100) ≈ 4.605, log(1000) ≈ 6.908.
- **price_scale** = −300 / (6.908 − 4.605) ≈ −130.2 (in “per log(price)”).
- **price_offset** = −6.908 × (−130.2) ≈ 900.2.

Now equal *percentage* moves get equal pixel distance:

- 100 → 200 (+100%): Δlog = log(200) − log(100) = ln(2) ≈ 0.693 → Δy = 0.693 × (−130.2) ≈ −90.2 px.
- 500 → 1000 (+100%): Δlog = log(1000) − log(500) = ln(2) ≈ 0.693 → Δy ≈ −90.2 px.

So both “double from X to 2X” moves use the same vertical space. A +10% move (e.g. 100 → 110) always uses the same pixel height as any other +10% move (e.g. 500 → 550), because log(1.1) is constant.

---

## Summary: what to track vs what to derive

**Track (main state):**

- **time_range** = [t_min, t_max]
- **bar_interval** (main series bar interval)
- **chart_width**, **chart_height** (drawable pixels)
- **price_high**, **price_low** (visible price range, possibly expanded)
- **use_log_scale** (and config: candle_width_ratio, price_range_expand, volume_height_ratio)

**Derive for drawing:**

- **px_per_time** = draw_width / time_span; **time_to_screen(t)** = (t − time_range[0]) × px_per_time
- **pixels_per_bar** = draw_width / (time_span / bar_interval); **candle_width_px** = pixels_per_bar × candle_width_ratio (× interval_ratio if needed)
- **price_scale** = −chart_height / (price_high − price_low), **price_offset** = −price_high × price_scale (linear); or same with log(price) for log scale
- Per candle: **x** = time_to_screen(t), **o,h,l,c** = floor(price × price_scale + price_offset) (or log(price) × price_scale + price_offset)
- Volume: **volume_scale** = volume_height_ratio × chart_height / max_volume; bar height = v × volume_scale

With this, you can reimplement the same scaling and drawing logic in any language or UI framework: keep the main variables updated when the user changes range, interval, or size, then recompute the derived values and redraw.
