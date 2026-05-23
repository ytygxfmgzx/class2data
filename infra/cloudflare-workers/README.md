# Cloudflare Workers

本项目包含多个 Cloudflare Worker，代码存放在此目录下，通过 Cloudflare Dashboard 手动部署。

## Worker 列表

| Worker | 文件 | 域名 | 说明 |
|--------|------|------|------|
| feishu-feedback-proxy | `feedback-proxy.js` | `feishufeedback.riddles.top` | 飞书反馈代理 |
| heartbeat-worker | `heartbeat-worker.js` | `heartbeat.riddles.top` | 心跳上报与设备统计 |
| kexiaoji-update-proxy | `update-proxy.js` | `update.riddles.top` | GitHub Release 更新代理 |

---

## 飞书反馈代理 Worker

隐藏飞书 webhook 地址，防止 APK 反编译后 webhook 泄露被滥用。

## 架构

```
Flutter App → Cloudflare Worker (token + rate limit) → 飞书 Webhook
```

## 环境变量

在 Cloudflare Dashboard → Workers → Settings → Variables 中配置为**加密变量**：

| 变量名 | 说明 |
|--------|------|
| `FEISHU_WEBHOOK_URL` | 飞书 webhook 完整 URL |
| `FEEDBACK_TOKEN` | 随机密钥，用于验证 App 请求 |

## 部署步骤

1. Cloudflare Dashboard → Workers & Pages → `feishu-feedback-proxy`
2. Edit Code → 用 `feedback-proxy.js` 内容替换 → Deploy
3. Settings → Variables → 添加加密变量：`FEISHU_WEBHOOK_URL`、`FEEDBACK_TOKEN`

## Flutter 构建

```bash
flutter build apk \
  --dart-define=FEEDBACK_TOKEN=<你的token>
```

## 验证

```bash
# 正常请求（应返回飞书响应）
curl -X POST https://feishufeedback.riddles.top \
  -H "Content-Type: application/json" \
  -H "X-Feedback-Token: <你的token>" \
  -d '{"msg_type":"text","content":{"text":"test"}}'

# 无 token（应返回 401）
curl -X POST https://feishufeedback.riddles.top \
  -H "Content-Type: application/json" \
  -d '{"msg_type":"text","content":{"text":"test"}}'
```

## Token 轮换

1. 本地生成新 token：`openssl rand -hex 32`
2. 更新 Cloudflare 变量：Settings → Variables → 编辑 `FEEDBACK_TOKEN`
3. 用新 token 重新构建 App

## 安全层级

- **反编译 APK**：只能看到 Worker URL + Token，看不到飞书 webhook
- **Token 泄露**：配合 rate limiting（每 IP 每 60 秒 10 次）限制滥用
- **源码公开**：webhook 地址在 Cloudflare 加密变量中，代码无泄露

---

## GitHub Release 更新代理 Worker

代理 GitHub Releases API，供 APP 检查版本更新和下载 APK。通过 Cloudflare CDN 加速国内访问。

### 架构

```
Flutter App → Cloudflare Worker (Cache API) → GitHub Releases API
```

### API

| 路由 | 方法 | 说明 |
|------|------|------|
| `/api/latest-release` | GET | 获取最新 Release 信息（版本号、更新日志、APK 下载地址），缓存 5 分钟 |
| `/download?url=<github_url>` | GET | 流式代理 APK 下载，`url` 必须以 `https://github.com/ytygxfmgzx/class2data/releases/` 开头 |

### 部署步骤

1. Cloudflare Dashboard → Workers & Pages → Create → `kexiaoji-update-proxy`
2. Edit Code → 粘贴 `update-proxy.js` 内容 → Deploy
3. Settings → Domains & Routes → 添加自定义域名 `update.riddles.top`
4. 无需配置环境变量

### 验证

```bash
# 检查最新版本
curl https://update.riddles.top/api/latest-release

# 下载 APK（需要实际的 GitHub Release 下载链接）
curl -L "https://update.riddles.top/download?url=https://github.com/ytygxfmgzx/class2data/releases/download/v0.6.0/kexiaoji-release-0.6.0.apk" -o app.apk
```
