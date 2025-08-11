param(
  [string]$BuildDir = "build\web",
  [string]$Branch = "gh-pages"
)

# gh-pages を worktree でマウント
if (Test-Path ".git") {
  git fetch origin $Branch 2>$null
} else {
  Write-Error "ここはGitリポジトリではありません。git init / remote設定を確認してください。"
  exit 1
}

if (!(Test-Path ".git\worktrees\gh-pages")) {
  git worktree add -f "build\gh-pages" $Branch 2>$null
}

# 中身をコピー（/MIRで完全同期）
robocopy "$BuildDir" "build\gh-pages" /MIR /NFL /NDL /NJH /NJS | Out-Null

# コミット＆プッシュ
Push-Location "build\gh-pages"
git add .
git commit -m "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>$null
git push origin $Branch
Pop-Location

Write-Host "✅ Deploy completed to branch $Branch"
