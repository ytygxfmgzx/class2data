# 飞书反馈代理 Worker

Cloudflare Worker 代理层，隐藏飞书 webhook 地址，防止 APK 反编译后 webhook 泄露被滥用。

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
