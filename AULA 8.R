# AULA 6 - Taxa de mortalidade por suicídio (homens) - Versão Corrigida

# Carregar bibliotecas
library(WDI)
library(tidyverse)
library(ggplot2)
options(scipen = 999) # Desativa notação científica

# 1. DADOS EM PAINEL - Todos os países com dados disponíveis
taxasuicidio <- WDI(country = "all", 
                    indicator = "SH.STA.SUIC.MA.P5",
                    extra = TRUE) # Inclui metadados dos países

# Filtrar apenas países (removendo agregados regionais)
paises_validos <- taxasuicidio %>%
  filter(region != "Aggregates" & !is.na(region)) %>%
  distinct(country, iso2c)

# Obter dados apenas para países válidos
taxasuicidio <- WDI(country = paises_validos$iso2c,
                    indicator = "SH.STA.SUIC.MA.P5")

# 2. CORTE TRANSVERSAL - 2015
taxasuicidio2015 <- WDI(country = paises_validos$iso2c,
                        indicator = "SH.STA.SUIC.MA.P5",
                        start = 2015, end = 2015) %>%
  filter(!is.na(SH.STA.SUIC.MA.P5)) # Remover NAs

# 3. SÉRIE TEMPORAL - Brasil (corrigido o nome do objeto)
taxasuicidio_brasil <- WDI(country = "BR",
                           indicator = "SH.STA.SUIC.MA.P5",
                           start = 1990, end = 2020) # Ampliado o período

#---------------------------------------------------------
# GRÁFICOS MELHORADOS
#---------------------------------------------------------

# 1. Gráfico de Painel (todos países, todos anos)
grafpainel <- ggplot(taxasuicidio, 
                     aes(x = year, y = SH.STA.SUIC.MA.P5, group = country)) +
  geom_line(alpha = 0.3, color = "steelblue") +
  geom_smooth(aes(group = 1), method = "loess", color = "red", se = FALSE) +
  labs(title = "Evolução da Taxa de Suicídio Masculino (por 100.000 hab.)",
       subtitle = "Todos os países com dados disponíveis",
       x = "Ano",
       y = "Taxa de suicídio",
       caption = "Fonte: World Bank WDI") +
  theme_minimal() +
  theme(legend.position = "none")

print(grafpainel)

# 2. Gráfico de Corte Transversal (2015)
# Ordenar países por taxa para melhor visualização
taxasuicidio2015 <- taxasuicidio2015 %>%
  arrange(desc(SH.STA.SUIC.MA.P5)) %>%
  mutate(country = factor(country, levels = country))

grafcorte <- ggplot(taxasuicidio2015[1:30, ], # Top 30 países
                    aes(x = reorder(country, SH.STA.SUIC.MA.P5), 
                        y = SH.STA.SUIC.MA.P5)) +
  geom_col(fill = "darkred", alpha = 0.8) +
  coord_flip() +
  labs(title = "Taxa de Suicídio Masculino em 2015 (por 100.000 hab.)",
       x = "País",
       y = "Taxa de suicídio",
       caption = "Fonte: World Bank WDI") +
  theme_minimal()

print(grafcorte)

# 3. Gráfico de Série Temporal (Brasil)
grafserie <- ggplot(taxasuicidio_brasil, 
                    aes(x = year, y = SH.STA.SUIC.MA.P5)) +
  geom_line(color = "darkgreen", size = 1.5) +
  geom_point(color = "darkgreen", size = 3) +
  labs(title = "Evolução da Taxa de Suicídio Masculino no Brasil",
       subtitle = "Por 100.000 habitantes",
       x = "Ano",
       y = "Taxa de suicídio",
       caption = "Fonte: World Bank WDI") +
  theme_minimal() +
  scale_x_continuous(breaks = seq(1990, 2020, by = 5))

print(grafserie)