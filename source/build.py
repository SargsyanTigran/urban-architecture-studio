#!/usr/bin/env python3
"""Inlines the Ostrich Sans woff2 font (base64) into the two design-direction
HTML templates so each deliverable is a single standalone file."""
import base64, pathlib

root = pathlib.Path(__file__).resolve().parent
out = root.parent
woff2 = (out / "fonts" / "OstrichSans-Medium.woff2").read_bytes()
otf = (out / "fonts" / "OstrichSans-Medium.otf").read_bytes()
b64_woff2 = base64.b64encode(woff2).decode()
b64_otf = base64.b64encode(otf).decode()

for name in ["direction_1_isometric_studio.html", "direction_2_futuristic_workspace.html"]:
    tpl = (root / (name + ".tpl")).read_text()
    html = tpl.replace("__FONT_WOFF2_B64__", b64_woff2).replace("__FONT_OTF_B64__", b64_otf)
    (out / name).write_text(html)
    print("wrote", out / name, f"({len(html)//1024} KB)")
