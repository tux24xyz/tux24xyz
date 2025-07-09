---
title: "Harsh --- 我無意間發現的 Based Habit Tracker"
date: 2025-07-08T14:57:34+08:00 # 撰寫時間
publishDate: 2025-07-10T06:00:00+08:00  # 預約之後發布
#lastmod: 2025-06-30 # 最後修改時間
draft: false
tags: ["🖥️科技", "🛟生活"]

# 文章設定
toc: true         # 是否顯示目錄
math: false       # 是否啟用數學公式
code: true        # 是否有程式碼
---

# 前言

會發現這個工具純粹是因為我搜尋了 "habit tracker on linux " 這個關鍵字。

先放它的 [Github 頁面](https://github.com/wakatara/harsh)。

寫這篇文章時我還沒解釋過我發明的 "Based" 這個詞，留著未來回來改。

我等等就去改我的 `/use`。

# 介紹

Harsh 是一個純文字介面的 habit tracker，可以讓你用終端機指令（只有三個！）輕鬆的追蹤你設定好的習慣。它甚至還能用來統計你的各項習慣之間的關係（例如：頭痛發作的日子沒有出去跑步），而且是視覺化的展示：

    $ harsh log
                              ▄▃▃▄▄▃▄▆▆▆▅▆▆▇▆▄▃▄▆▃▆▃▆▂▅▄▃▄▅▆▅▃▃▃▆▂▄▅▄▅▅▅▆▄▄▆▇▆▅▅▄▃▅▆▄▆▃▃▂▅▆
                    Meditated ━       ━ ━  ━━         ━    ━   ━ ━   ━━━━━━━━━━━   ━ ━   ━━
        Cleaned the apartment ━──────                 ━──────           ━──────    •······
               Had a headache             ━  ━     ━━                  ━━   ━   ━━
                   Used harsh ━ ━━━ ━  ━━━   ━ ━ ━       ━ ━ ━  ━ ━ ━━ ━ ━ ━━━━   ━    ━
                                             ... some habits omitted ...

    Yesterday's score: 88.3%

類似它 Github 頁面上的這個例子。

# 怎麼用

harsh 只有三個指令：`ask` 、`log` 、`todo` 
功能分別是：

1. `ask`: harsh 會開始問你今天的習慣有沒有達成
2. `log`: harsh 會展示你追蹤的習慣的執行情況
3. `todo`: harsh 會列出你今天還沒執行的習慣

使用 `$ harsh ask` 指令時，面對每個習慣，你有四個回答選項，yes/no/skip/don't ask now（按 Enter）。

1. yes: 你今天有堅持這個習慣
2. no: 你今天沒有堅持這個習慣
3. skip: 今天做不到（例如：你有「整理房間」這個習慣，但你要出國一週），先跳過
4. don't ask now（按 Enter）: 先不問，如果你今天再次使用了 ask 指令，harsh 會再問你一次

那麼要怎麼告訴 harsh 你要它追蹤哪些習慣呢？
在 Linux 上，harsh 預設會建立兩個文字檔放在 `~/.config/harsh`，一個是 `habits`，另一個是 `log`。
你只要用文字編輯器打開 `habits` 檔案，按照指定的格式填入習慣就好了。

指定的格式如下說明：

```
# 這是你的 habits 檔案
# 它會告訴 harsh 有哪些習慣要追蹤以及追蹤的頻率
# 1 代表每天，7 代表每週，14 代表每兩個禮拜，以此類推
# 你也可以用以下方式指定追蹤頻率：
# 例如每週游泳 4 次你可以這麼寫：Swim: 4/7
# 0 代表純追蹤，harsh 不會因為你的這個習慣沒堅持住而提醒你
# 你可以用 !（半形驚嘆號）開頭接著文字來幫習慣分類，如下，習慣很多時這功能很實用
# 你只需要這麼寫： 習慣名（不可以含冒號） + 半形冒號 + 數字


# 範例（就是我寫的啦）:

! dailies

Got 8 hours of sleep: 1
Drink water (2 liter): 1
Update the blog: 1
Push-ups x50: 1
Cold bath: 1

! weeklies

Read a book: 7
Playing RPG: 2/7
Go out to meet friends: 7
Swim: 4/7

! monthly+

! tracking

No cellphone before bed: 0

```

至於 `log` 檔案你不用管它，那只是 harsh 紀錄你習慣執行進程的地方。harsh 會把 `log` 檔案的內容轉換成視覺化的形式（你上面看到的那個）輸出給使用者。

## 壞習慣

harsh 不只可以用來追蹤好習慣，壞習慣其實也行，有兩種方式給你參考：

1. 每天都不能做的壞習慣：直接把習慣名寫成「不」做某事，然後當成好習慣就好。例如：`沒有抽菸: 1`
2. 只是想追蹤壞習慣：把習慣的頻率設為「0」，例如：`沒有在第 17 杯咖啡前結束辯論: 0`

## 更多資訊

在 harsh 的 Github 頁面，作者寫了個超詳細的 `readme.md`，這篇文章的內容都是從那邊來的，還想知道更多使用方式的話就去看吧。
我是覺得這樣已經夠了，而且 harsh 內建的說明（使用 `$ harsh help`，第四個指令，我剛沒提到）我覺得夠詳細了。

# 註記

我習慣名都寫英文，我不確定寫中文 harsh 能不能正常運作，我想應該不會有問題。

這個專案看起來挺冷門的，作者卻有頻繁更新，值得鼓勵。幫他按個 star 吧。

我搞不好是第一個用 harsh 的臺灣人（至少是第一個寫文章介紹它的）。