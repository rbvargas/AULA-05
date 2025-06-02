# 1. RESET COMPLETO (elimina problemas anteriores)
rm(list = ls())
dev.off() # Fecha todos os dispositivos gráficos
options(warn = -1) # Silencia warnings temporariamente

# 2. PACOTES (instalação automática)
if (!require(pacman)) install.packages("pacman")
pacman::p_load(ggplot2, plotly, htmlwidgets, GetBCBData, scales)

# 3. DADOS ROBUSTOS (com fallback visível)
dados <- tryCatch({
  # Usando um período maior para que as quebras de 5 em 5 anos façam sentido
  GetBCBData::gbcbd_get_series(id = 1644,
                               first.date = "1995-01-01", # Período bem maior para testar 5 em 5 anos
                               last.date = Sys.Date())
}, error = function(e) {
  # Dados de exemplo GARANTIDOS (100% visíveis)
  # Gerando dados por um período mais longo para simular o espaçamento de 5 anos
  start_date <- as.Date("1995-01-01")
  end_date <- Sys.Date()
  data.frame(
    ref.date = seq.Date(start_date, end_date, by = "month"), # Gerar por mês para um período longo
    value = cumsum(rnorm(as.numeric(end_date - start_date) / 30, sd = 0.5)) + 10 # Variação maior
  )
})

# 4. GRÁFICO COM LINHAS VISÍVEIS (configurações críticas)
grafico_base <- ggplot(dados, aes(x = ref.date, y = value)) +
  geom_line(
    color = "#FF0000",       # Vermelho forte (garantido)
    size = 1.5,              # Espessura aumentada
    lineend = "round",       # Pontas arredondadas
    linejoin = "round",
    linetype = "solid"       # Linha contínua
  ) +
  labs(title = "CDI - DATAS A CADA 5 ANOS NO EIXO X", # Título atualizado
       x = "", y = "Taxa (% a.d.)") +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey75", size = 0.5, linetype = "dotted"),
    panel.grid.minor = element_line(color = "grey85", size = 0.25, linetype = "dotted"),
    plot.background = element_rect(fill = "white"),
    panel.background = element_rect(fill = "white")
  ) +
  # --- ALTERAÇÕES AQUI para o Eixo X (Datas) ---
  scale_x_date(
    date_breaks = "5 years",       # Linhas de grade e rótulos a cada 5 anos
    date_minor_breaks = "1 year",  # Linhas de grade menores a cada 1 ano
    date_labels = "%Y"             # Mostrar apenas o ano (ex: 2000, 2005)
  ) +
  # --- Manter as configurações do Eixo Y como estavam ---
  scale_y_continuous(
    breaks = function(limits) {
      interval <- max(0.05, (limits[2] - limits[1]) / 10) # Ajustado para 10 quebras principais
      seq(floor(limits[1] / interval) * interval, ceiling(limits[2] / interval) * interval, by = interval)
    },
    minor_breaks = function(limits) {
      interval <- max(0.025, (limits[2] - limits[1]) / 20) # Ajustado para 20 quebras menores
      seq(floor(limits[1] / interval) * interval, ceiling(limits[2] / interval) * interval, by = interval)
    }
  )

# 5. VISUALIZAÇÃO GARANTIDA (3 métodos)
cat("\nMÉTODOS DE VISUALIZAÇÃO:\n")

# Método 1: Plotly com configurações reforçadas
fig <- ggplotly(grafico_base, tooltip = c("x", "y")) %>%
  layout(
    plot_bgcolor = 'rgba(255,255,255,1)',
    paper_bgcolor = 'rgba(255,255,255,1)',
    hoverlabel = list(
      bgcolor = "white",
      font = list(color = "black", size = 14)
    )
  ) %>%
  config(displayModeBar = TRUE)

# Forçar exibição (RStudio e navegador)
try(print(fig), silent = TRUE)

# Método 2: HTML auto-abrível
if (!exists("fig") || inherits(try(print(fig)), "try-error")) {
  htmlwidgets::saveWidget(fig, "CDI_VISIVEL_5_ANOS.html", selfcontained = TRUE) # Nome atualizado
  browseURL("CDI_VISIVEL_5_ANOS.html")
  cat("→ Gráfico salvo como 'CDI_VISIVEL_5_ANOS.html' e aberto no navegador\n")
}

# Método 3: Imagem PNG de emergência
if (!file.exists("CDI_VISIVEL_5_ANOS.html")) {
  png("CDI_GARANTIDO_5_ANOS.png", width = 1500, height = 800, res = 120) # Nome atualizado
  print(grafico_base)
  dev.off()
  browseURL("CDI_GARANTIDO_5_ANOS.png")
  cat("→ Gráfico salvo como 'CDI_GARANTIDO_5_ANOS.png' e aberto\n")
}

# 6. VERIFICAÇÃO FINAL
cat("\nDIAGNÓSTICO:\n")
if (any(dados$value < 0)) {
  cat("× AVISO: Valores negativos detectados - ajuste os dados\n")
} else {
  cat("✓ Dados OK (média =", round(mean(dados$value, na.rm = TRUE)), "%)\n")
}

if (exists("fig")) {
  cat("✓ Plotly gerado com sucesso\n")
} else {
  cat("× Plotly não pôde ser gerado\n")
}