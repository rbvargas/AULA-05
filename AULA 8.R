# AULA 6 - Taxa de mortalidade por suicídio (homens) - Versão Corrigida

# Carregar bibliotecas
library(WDI)
library(tidyverse)
library(ggplot2)
options(scipen = 999) # Desativa notação científica

# 1. DADOS EM PAINEL - Todos os países com dados disponíveis
taxasuicidio <- WDI(country = "all", 
                    indicator = "SH.STA.SUIC.MA.P5",
                    extra = TRUE,
                    start = 2000) # Inclui metadados dos países

# Filtrar apenas países (removendo agregados regionais)
paises_validos <- taxasuicidio %>%
  filter(region != "Aggregates" & !is.na(region)) %>%
  distinct(country, iso2c)

taxasuicidio <- WDI(country = "all", 
                    indicator = "SH.STA.SUIC.MA.P5",
                    extra = TRUE,
                    start = 2000) # Inclui metadados dos países

# 2. CORTE TRANSVERSAL - 2015
taxasuicidio2015 <- WDI(country = paises_validos$iso2c,
                        indicator = "SH.STA.SUIC.MA.P5",
                        start = 2015, end = 2015) %>%
  filter(!is.na(SH.STA.SUIC.MA.P5)) # Remover NAs

# 3. SÉRIE TEMPORAL - Brasil (corrigido o nome do objeto)
taxasuicidio_brasil <- WDI(country = "BR",
                           indicator = "SH.STA.SUIC.MA.P5",
                           start = 2000, end = 2020) # Ampliado o período

#---------------------------------------------------------
# GRÁFICOS MELHORADOS
#---------------------------------------------------------

install.packages("ggrepel")
library(ggplot2)
library(dplyr)

# Carregar dados (substitua pelo seu dataframe real)
# taxasuicidio <- ...

# Filtrar países com dados completos
paises_validos <- taxasuicidio %>%
  group_by(country) %>%
  summarise(n_anos = sum(!is.na(SH.STA.SUIC.MA.P5))) %>%
  filter(n_anos >= 10) %>%
  pull(country)

dados_filtrados <- taxasuicidio %>% 
  filter(country %in% paises_validos)

# Selecionar países para destacar (top 10% mais altos/baixos + específicos)
dados_destaque <- dados_filtrados %>%
  group_by(country) %>%
  summarise(
    media_taxa = mean(SH.STA.SUIC.MA.P5, na.rm = TRUE),
    ultimo_ano = max(year, na.rm = TRUE),
    ultima_taxa = last(na.omit(SH.STA.SUIC.MA.P5))
  ) %>%
  ungroup() %>%
  mutate(
    rank = rank(-media_taxa),
    destacar = rank <= 15 | rank >= (n() - 15) | country %in% c("Brazil", "United States")
  ) %>%
  filter(destacar)

# Criar gráfico SEM ggrepel
ggplot(dados_filtrados, aes(x = year, y = SH.STA.SUIC.MA.P5, group = country)) +
  # Linhas base
  geom_line(color = "gray85", alpha = 0.4, linewidth = 0.3) +
  
  # Linhas destacadas
  geom_line(
    data = dados_filtrados %>% filter(country %in% dados_destaque$country),
    aes(color = country),
    linewidth = 0.8
  ) +
  
  # Rótulos manuais (posicionados apenas no último ano)
  geom_text(
    data = dados_filtrados %>%
      filter(country %in% dados_destaque$country) %>%
      group_by(country) %>%
      filter(year == max(year)),
    aes(label = country, color = country),
    hjust = 0, nudge_x = 1, size = 3, check_overlap = TRUE  # Evita sobreposição
  ) +
  
  # Média global
  stat_summary(
    aes(group = 1),
    fun = mean, geom = "line",
    color = "black", linewidth = 1.2, linetype = "dashed"
  ) +
  
  # Configurações
  labs(title = "Taxa de Suicídio Masculino (Países Destacados)",
       subtitle = "Linha tracejada: Média global | Labels: Top 15 mais altos/baixos + Brasil/EUA",
       x = "Ano", y = "Taxa por 100.000 habitantes") +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.15)))

# Filtrar e ordenar
top30_2015 <- taxasuicidio2015 %>%
  filter(!is.na(SH.STA.SUIC.MA.P5)) %>%
  arrange(desc(SH.STA.SUIC.MA.P5)) %>%
  slice(1:30) %>%
  mutate(country = fct_reorder(country, SH.STA.SUIC.MA.P5))

# Criar gráfico
grafcorte_melhorado <- ggplot(top30_2015,
                              aes(x = SH.STA.SUIC.MA.P5, y = country, 
                                  fill = SH.STA.SUIC.MA.P5)) +
  geom_col(width = 0.8) +
  # Adicionar valores
  geom_text(aes(label = round(SH.STA.SUIC.MA.P5, 1)), 
            hjust = -0.2, size = 3.5, color = "black") +
  # Escala de cores
  scale_fill_gradientn(colors = c("#FEE08B", "#FDAE61", "#D53E4F"),
                       name = "Taxa") +
  # Configurações
  labs(title = "TOP 30 PAÍSES COM MAIORES TAXAS DE SUICÍDIO MASCULINO - 2015",
       x = "Taxa por 100.000 habitantes",
       y = NULL,
       caption = "Fonte: World Bank WDI") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.y = element_text(size = 10),
    legend.position = "none"
  ) +
  scale_x_continuous(expand = expansion(mult = c(0, 0.15))) +
  coord_cartesian(clip = "off")

print(grafcorte_melhorado)

grafserie_melhorado <- ggplot(taxasuicidio_brasil, 
                              aes(x = year, y = SH.STA.SUIC.MA.P5)) +
  # Área de fundo
  geom_area(fill = "#A6D96A", alpha = 0.4) +
  # Linha e pontos
  geom_line(color = "#1A9641", linewidth = 1.5) +
  geom_point(color = "#1A9641", size = 3.5) +
  # Valores
  geom_text(aes(label = round(SH.STA.SUIC.MA.P5, 1)), 
            vjust = -1.5, size = 4, color = "#1A9641", fontface = "bold") +
  # Configurações
  labs(title = "EVOLUÇÃO DA TAXA DE SUICÍDIO MASCULINO NO BRASIL",
       subtitle = "Taxa por 100.000 habitantes (1990-2020)",
       x = "Ano",
       y = "Taxa de suicídio",
       caption = "Fonte: World Bank WDI") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5, color = "#1A9641"),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "white", color = NA)
  ) +
  scale_x_continuous(breaks = seq(2000, 2020, by = 5)) +
  scale_y_continuous(limits = c(0, max(taxasuicidio_brasil$SH.STA.SUIC.MA.P5) * 1.2),
                     expand = expansion(mult = c(0, 0.1))) +
  # Destaque para o último ano
  annotate("text", 
           x = max(taxasuicidio_brasil$year), 
           y = max(taxasuicidio_brasil$SH.STA.SUIC.MA.P5),
           label = paste("Brasil", max(taxasuicidio_brasil$year)), 
           hjust = 1.1, vjust = 0, color = "#1A9641", size = 5)

print(grafserie_melhorado)