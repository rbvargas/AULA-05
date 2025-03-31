# AULA 6
# Taxa de mortalidade por suicídio, homens
library(WDI) 

# DADOS EM PAINEL
taxasuicidio <- WDI(country = "all",
                    indicator = "SH.STA.SUIC.MA.P5")

# CORTE TRANSVERSAL 
taxasuicidio2015 <- WDI(country = "all",
                        indicator = "SH.STA.SUIC.MA.P5",
                        start = 2015, end = 2015)

# SÉRIE TEMPORAL 
taxasuicidio2015 <- WDI(country = "BR",
                        indicator = "SH.STA.SUIC.MA.P5",
                        start = 2015, end = 2015)

library(WDI) 
options (scipen = 999) #AJUSTA A NOT. CIENT.

#FAZER GRÁFICO 
# gglot2 (faz parte do pacote tidyverse)
install.packages ("tidyverse")
library(tidyverse)

grafpainel <- ggplot(taxasuicidio,
                    mapping = aes(y = SH.STA.SUIC.MA.P5,
                                  x = year)) +
geom_point()  

# CORTE TRANSVERSAL

grafcorte <- ggplot(taxasuicidio,
                    mapping = aes(y = SH.STA.SUIC.MA.P5,
                                  x = year)) +
  geom_point()

print(grafcorte)

# SERIE TEMPORAL
grafserie <- ggplot(taxasuicidio,
                    mapping = aes(y = SH.STA.SUIC.MA.P5,
                                  x = year)) +
  geom_line()
print(grafserie)








