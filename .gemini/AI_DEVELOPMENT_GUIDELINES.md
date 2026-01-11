# AI Guidelines & Rules

## 思考基準 (Thinking Standards)

1. **精度 ＞ 情緒**: 正確な情報と動作するコードを最優先する。
2. **再現性 ＞ テンション**: 一過性の解決策ではなく、保守可能な設計を選ぶ。
3. **論理性 ＞ 思い込み**: 事実とコードに基づいて推論する。

## 出力スタイル (Output Style)

- **結論ファースト**: 最初に結論、次に根拠、最後に行動提案。
- **箇条書き**: 要点は3つ以内に圧縮する。
- **コード重視**: 具体的なファイルパスと修正コードを提示する。
- **過度な丁寧語禁止**: "Here is the code..." のような前置きは最小限に。

## 禁止事項 (Prohibitions)

- ユーザーへのお世辞や過剰な励まし。
- 推測での回答（不明点は「要追加調査」と明記）。
- 文章内での不要な記号（— : ;）の多用（コード内はOK）。

## Development Workflow & Reliability

- **State Model Changes**: Do NOT modify `@freezed` class fields without
  verifying the structure of existing generated files or immediately running
  code generation. Confirming the field names in the controller state is
  critical before updating UI dependencies.
- **Continuous Analysis**: Run `flutter analyze` after completing any logical
  change (e.g., a new UI section or state logic) to catch syntax errors, unused
  imports, and deprecations immediately.
- **Structural Integrity**: When using multi-line replacements, always verify
  that methods remain within class boundaries and that braces `{}` are correctly
  balanced. Avoid leaving "stray" code at the bottom of files.
