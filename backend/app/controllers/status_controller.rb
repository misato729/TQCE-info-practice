class StatusController < ApplicationController
  def show
    render html: status_page.html_safe
  end

  private

  def status_page
    <<~HTML
      <!doctype html>
      <html lang="ja">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>TQCE API Status</title>
          <style>
            :root {
              color-scheme: light;
              font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
              color: #172033;
              background: #f4f7f6;
            }

            body {
              min-height: 100vh;
              margin: 0;
              display: grid;
              place-items: center;
              padding: 24px;
              box-sizing: border-box;
            }

            main {
              width: min(680px, 100%);
            }

            .label {
              margin: 0 0 10px;
              color: #087f5b;
              font-size: 13px;
              font-weight: 700;
              text-transform: uppercase;
            }

            h1 {
              margin: 0;
              font-size: clamp(30px, 7vw, 52px);
              line-height: 1.1;
            }

            .description {
              margin: 18px 0 28px;
              color: #526070;
              font-size: 17px;
              line-height: 1.7;
            }

            .status {
              display: flex;
              align-items: center;
              gap: 12px;
              padding: 16px;
              border: 1px solid #cbd5d1;
              border-radius: 8px;
              background: #fff;
            }

            .dot {
              width: 12px;
              height: 12px;
              flex: 0 0 auto;
              border-radius: 50%;
              background: #12a36d;
              box-shadow: 0 0 0 4px #d8f5e9;
            }

            code {
              color: #075c43;
              font-weight: 700;
            }

            a {
              color: #0969da;
            }
          </style>
        </head>
        <body>
          <main>
            <p class="label">TQCE Backend</p>
            <h1>Rails API is running</h1>
            <p class="description">
              高等学校「情報」教員資格認定試験 問題演習サイトのバックエンドです。
            </p>
            <div class="status">
              <span class="dot" aria-hidden="true"></span>
              <span>
                API status:
                <a href="/api/v1/health"><code>/api/v1/health</code></a>
              </span>
            </div>
          </main>
        </body>
      </html>
    HTML
  end
end
