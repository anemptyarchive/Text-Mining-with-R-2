
# ch4 Twitter投稿テキストの評価 ----------------------------------------------------

# 利用パッケージ
library(rtweet)
library(RMeCab)
library(tidyverse)


rt <- search_tweets("トピックモデル", n = 1000, include_rts = FALSE, retryonratelimit = TRUE)

rt %>% 
  select(text) %>% 
  pull() %>% 
  write("tmp_text/tw_text.txt")

txt_df <- docDF("tmp_text/tw_text.txt", type = 1)

txt_df %>% 
  select(POS1) %>% 
  distinct() %>% 
  pull()

txt_df2 <- txt_df %>% 
  filter(
    POS1 %in% c("名詞", "形容詞", "動詞"), 
    POS2 %in% c("一般", "自立", "非自立", "助詞類接続")
  )

NROW(txt_df2)



# 4.6 ネットワークグラフ -----------------------------------------------------------

# 利用パッケージ
library(igraph)
library(ggraph)
library(dplyr)

# フォルダ名を指定
dir_name <- "tmp_text"

# ファイル名を指定
file_name <- "tw_text.txt"

# 形態素解析
res_mecab <- docDF(paste(dir_name, file_name, sep = "/"), type = 1, N = 2, nDF = TRUE)

# 作図用データフレームを作成
netgraph_df <- res_mecab %>% 
  select(N1, N2, title = file_name) %>% # 列を抽出
  arrange(title) %>% # 昇順に並び替え
  tail(100) # 単語数を指定

# 作図
netgraph_df %>% 
  graph_from_data_frame() %>% # ネットワークグラフ用に変換
  ggraph(layout = 'graphopt') + 
    geom_edge_diagonal(alpha = 1, label_colour = "bule") + 
    geom_node_label(aes(label = name), size = 5, repel = TRUE)

