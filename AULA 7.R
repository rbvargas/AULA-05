# Série temporal (apenas Brasil)
taxa_brasil <- WDI(country = "BR", indicator = "SH.STA.SUIC.MA.P5")

ggplot(taxa_brasil, aes(x = year, y = SH.STA.SUIC.MA.P5)) +
  geom_line(color = "darkgreen", size = 1.2) +
  geom_point(color = "darkgreen") +
  labs(title = "Série Temporal: Suicídio Masculino no Brasil",
       x = "Ano",
       y = "Taxa por 100 mil habitantes") +
  theme_minimal()