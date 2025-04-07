# Filtrar dados para 2015 e remover NAs
taxa2015 <- taxasuicidio2015[complete.cases(taxasuicidio2015), ]

grafcorte <- ggplot(taxa2015, 
                    aes(x = reorder(country, -SH.STA.SUIC.MA.P5), 
                        y = SH.STA.SUIC.MA.P5)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Taxa de suicídio masculino em 2015 (por 100 mil hab.)",
       x = "País",
       y = "Taxa de suicídio") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

print(grafcorte)
