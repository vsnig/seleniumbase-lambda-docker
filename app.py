from seleniumbase import SB

# https://github.com/seleniumbase/SeleniumBase/issues/2459
from seleniumbase.core import browser_launcher

browser_launcher.override_driver_dir("/tmp")

with SB(
    uc=True,
    test=True,
    locale="en",
    headless=True,
    xvfb=True,
    chromium_arg=",".join(
        [
            "--autoplay-policy=user-gesture-required",
            "--disable-background-networking",
            "--disable-background-timer-throttling",
            "--disable-backgrounding-occluded-windows",
            "--disable-breakpad",
            "--disable-client-side-phishing-detection",
            "--disable-component-update",
            "--disable-default-apps",
            "--disable-dev-shm-usage",
            "--disable-domain-reliability",
            "--disable-extensions",
            "--disable-features=AudioServiceOutOfProcess",
            "--disable-hang-monitor",
            "--disable-ipc-flooding-protection",
            "--disable-notifications",
            "--disable-offer-store-unmasked-wallet-cards",
            "--disable-popup-blocking",
            "--disable-print-preview",
            "--disable-prompt-on-repost",
            "--disable-renderer-backgrounding",
            "--disable-setuid-sandbox",
            "--disable-speech-api",
            "--disable-sync",
            "--disk-cache-size=33554432",
            "--hide-scrollbars",
            "--ignore-gpu-blacklist",
            "--metrics-recording-only",
            "--mute-audio",
            "--no-default-browser-check",
            "--no-first-run",
            "--no-pings",
            "--no-sandbox",
            "--no-zygote",
            "--password-store=basic",
            "--use-gl=swiftshader",
            "--use-mock-keychain",
            "--single-process",
            "--disable-gpu",
        ]
    ),
) as sb:
    print("Start")
    sb.activate_cdp_mode("https://seleniumbase.io/demo_page")
    print(f"Title: {sb.get_title()}")
